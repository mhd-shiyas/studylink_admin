import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink_admin/constants/color_constants.dart';
import 'package:studylink_admin/controllers/home_controller.dart';
import 'package:studylink_admin/screens/department_list_screen.dart';
import 'package:studylink_admin/widgets/custom_button.dart';
import 'package:studylink_admin/widgets/custom_textfield.dart';
import '../controllers/admin_data_controller.dart';

class AddDepartmentScreen extends StatefulWidget {
  const AddDepartmentScreen({super.key});

  @override
  State<AddDepartmentScreen> createState() => _AddDepartmentScreenState();
}

class _AddDepartmentScreenState extends State<AddDepartmentScreen> {
  final TextEditingController _departmentNameController =
      TextEditingController();
  // String? _selectedYear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Add Department',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: ColorConstants.primaryColor,
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextfield(
              controller: _departmentNameController,
              label: 'Department Name',
              hint: 'Department Name',
            ),
            // const SizedBox(height: 20),
            // const Text(
            //   'Select Year:',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            // Row(
            //   children: [
            //     Checkbox(
            //       activeColor: ColorConstants.primaryColor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(4)),
            //       value: _selectedYear == '2019-2022',
            //       onChanged: (value) {
            //         setState(() {
            //           _selectedYear = value! ? '2019-2022' : null;
            //         });
            //       },
            //     ),
            //     const Text(
            //       '2019-2022',
            //       style: TextStyle(
            //         fontSize: 15,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     const SizedBox(width: 20),
            //     Checkbox(
            //       activeColor: ColorConstants.primaryColor,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(4)),
            //       value: _selectedYear == '2023-Current',
            //       onChanged: (value) {
            //         setState(() {
            //           _selectedYear = value! ? '2023-Current' : null;
            //         });
            //       },
            //     ),
            //     const Text(
            //       '2023-Current',
            //       style: TextStyle(
            //         fontSize: 15,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onTap: () async {
                  if (_departmentNameController.text.isNotEmpty) {
                    try {
                      await Provider.of<AdminDataProvider>(context,
                              listen: false)
                          .addDepartment(
                        _departmentNameController.text,
                        // _selectedYear ?? '',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Department added successfully!')),
                      );
                      _departmentNameController.clear();
                      Navigator.pop(context);
                      Provider.of<HomeController>(context, listen: false)
                          .fetchDepartment();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                title: 'Add Department',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
