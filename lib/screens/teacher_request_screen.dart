import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink_admin/constants/color_constants.dart';
import 'package:studylink_admin/controllers/admin_controller.dart';
import 'package:studylink_admin/widgets/custom_button.dart';

class TeacherRequestsPage extends StatefulWidget {
  const TeacherRequestsPage({super.key});

  @override
  State<TeacherRequestsPage> createState() => _TeacherRequestsPageState();
}

class _TeacherRequestsPageState extends State<TeacherRequestsPage> {
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<RequestProvider>(context, listen: false).fetchPendingRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Teacher Requests',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ColorConstants.primaryColor,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<RequestProvider>(
          builder: (context, value, child) => value.pendingRequests.isEmpty
              ? Center(
                  child: Text(
                    "No Requests",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchInitialData,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                    itemCount: value.pendingRequests.length,
                    itemBuilder: (context, index) {
                      final request = value.pendingRequests[index];
                      final teacherId = request['teacherId'];
                      return Container(
                        padding: EdgeInsets.all(10),
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 2,
                            color: ColorConstants.primaryColor.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DetailsWidget(
                              title: "Name",
                              value: request['name'] ?? '',
                            ),
                            DetailsWidget(
                              title: "Email",
                              value: request["email"] ?? '',
                            ),
                            DetailsWidget(
                              title: "Department",
                              value: request["department"] ?? '',
                            ),
                            DetailsWidget(
                              title: "Status",
                              value: request["status"] ?? '',
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                      title: "Accept",
                                      onTap: () async {
                                        try {
                                          await value.approveRequest(teacherId);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Teacher approved successfully!')),
                                          );
                                          fetchInitialData();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(e.toString())),
                                          );
                                        }
                                      }),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                      buttonColor: Colors.white,
                                      textColor: ColorConstants.primaryColor,
                                      title: "Reject",
                                      onTap: () async {
                                        try {
                                          await value.rejectRequest(teacherId);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    'Teacher request rejected!')),
                                          );
                                          fetchInitialData();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(e.toString())),
                                          );
                                        }
                                      }),
                                )
                              ],
                            )
                          ],
                        ),
                      );

                      //  Card(
                      //   margin: const EdgeInsets.all(8.0),
                      //   child: ListTile(
                      //     title: Text(request['email']),
                      //     subtitle: Text('Status: ${request['status']}'),
                      //     trailing: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         IconButton(
                      //           icon: Icon(Icons.check, color: Colors.green),
                      //           onPressed: () {
                      //             value.updateTeacherRequest(
                      //                 request['id'], true);
                      //           },
                      //         ),
                      //         IconButton(
                      //           icon: Icon(Icons.close, color: Colors.red),
                      //           onPressed: () {
                      //             value.updateTeacherRequest(
                      //                 request['id'], false);
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}

class DetailsWidget extends StatelessWidget {
  final String title;
  final String value;
  const DetailsWidget({super.key, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$title: ",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
