import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink_admin/constants/color_constants.dart';
import 'package:studylink_admin/controllers/home_controller.dart';
import 'package:studylink_admin/screens/add_subject_screen.dart';

import '../controllers/admin_data_controller.dart';

class SubjectListScreen extends StatefulWidget {
  final String semesterID;
  const SubjectListScreen({
    super.key,
    required this.semesterID,
  });

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<HomeController>(context, listen: false)
        .fetchSubject(widget.semesterID);
  }

  Future<void> _deleteSubjects(String subjectId) async {
    final adminProvider =
        Provider.of<AdminDataProvider>(context, listen: false);
    try {
      await adminProvider.deleteSubjects(subjectId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subject deleted successfully')),
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
            'Subjects',
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
              return value.isSubjectLoading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.primaryColor,
                      ),
                    )
                  : value.subjects!.isEmpty
                      ? Center(
                          child: Text("No Subjects"),
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
                          itemCount: value.subjects?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = value.subjects?[index];
                            return Container(
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
                                      item?.subjectName ?? '',
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
                                          title:
                                              const Text('Delete Department'),
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
                                                _deleteSubjects(
                                                    item?.subjectId ?? '');
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
              builder: (context) => AddSubjectScreen(
                semesterID: widget.semesterID,
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
                'Add Subjects',
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
