import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink_admin/constants/color_constants.dart';
import 'package:studylink_admin/controllers/home_controller.dart';
import 'package:studylink_admin/screens/add_department_screen.dart';
import 'package:studylink_admin/screens/year_selection_screen.dart';

import '../controllers/admin_data_controller.dart';

class DepartmentListScreen extends StatefulWidget {
  const DepartmentListScreen({super.key});

  @override
  State<DepartmentListScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    Provider.of<HomeController>(context, listen: false).fetchDepartment();
  }

  Future<void> _deleteDepartment(String departmentId) async {
    final adminProvider =
        Provider.of<AdminDataProvider>(context, listen: false);
    try {
      await adminProvider.deleteDepartment(departmentId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Department deleted successfully')),
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
            'Departments',
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
              return value.isloading == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorConstants.primaryColor,
                      ),
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
                      itemCount: value.department?.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = value.department?[index];
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YearSelectionScreen(
                                      departmentId: item?["departmentId"] ?? '',
                                    ),
                                  ));
                              },
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
                                        item?["dep_name"] ?? '',
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
                                                  _deleteDepartment(
                                                      item?['departmentId']);
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
              builder: (context) => AddDepartmentScreen(),
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
                'Add Departments',
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
