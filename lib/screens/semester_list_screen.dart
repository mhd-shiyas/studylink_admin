import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink_admin/constants/color_constants.dart';
import 'package:studylink_admin/controllers/home_controller.dart';
import 'package:studylink_admin/screens/add_semester_screen.dart';
import 'package:studylink_admin/screens/subject_list_screen.dart';

import '../controllers/admin_data_controller.dart';

class SemesterListScreen extends StatefulWidget {
  final String year;
  final String departmentId;
  const SemesterListScreen({
    super.key,
    required this.year,
    required this.departmentId,
  });

  @override
  State<SemesterListScreen> createState() => _SemesterListScreenState();
}

class _SemesterListScreenState extends State<SemesterListScreen> {
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<HomeController>(context, listen: false).fetchSemesters(
      widget.departmentId,
      widget.year,
    );
  }

  Future<void> _deleteSemester(String semesterId) async {
    final adminProvider =
        Provider.of<AdminDataProvider>(context, listen: false);
    try {
      await adminProvider.deleteSemester(semesterId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semester deleted successfully')),
      );
      fetchInitialData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting department: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Semesters',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ColorConstants.primaryColor,
            ),
          )),
      body: RefreshIndicator(
        onRefresh: fetchInitialData,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<HomeController>(
            builder: (context, value, child) {
              return value.isSemesterLoading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.primaryColor,
                      ),
                    )
                  : value.semesters!.isEmpty
                      ? Center(
                          child: Text("No Semesters"),
                        )
                      : ListView.separated(
                          //padding: const EdgeInsets.all(16.0),
                          shrinkWrap: true,
                          // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          //   crossAxisCount: 2,
                          //   crossAxisSpacing: 16.0,
                          //   mainAxisSpacing: 16.0,
                          // ),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 12,
                          ),
                          itemCount: value.semesters?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = value.semesters?[index];
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SubjectListScreen(
                                          semesterID: item?.semesterId ?? '',
                                        ),
                                      )),
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    height: 70,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: ColorConstants.secondaryColor
                                              .withOpacity(0.7),
                                          width: 2,
                                        )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: AutoSizeText(
                                            item?.semesterName ?? '',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'Delete Department'),
                                                content: const Text(
                                                    'Are you sure you want to delete this department?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context); // Close the dialog
                                                      _deleteSemester(
                                                          item?.semesterId ??
                                                              '');
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
            },
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSemesterScreen(
                year: widget.year,
                departmentId: widget.departmentId,
              ),
            )),
        child: Container(
          margin: EdgeInsets.all(10),
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
              color: ColorConstants.primaryColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: ColorConstants.primaryColor.withOpacity(0.5),
                  width: 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add Semesters',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
