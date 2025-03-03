import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink_admin/constants/color_constants.dart';
import 'package:studylink_admin/widgets/custom_button.dart';
import '../controllers/admin_data_controller.dart';
import '../widgets/custom_textfield.dart';

class AddSemesterScreen extends StatefulWidget {
  final String year;
  final String departmentId;
  const AddSemesterScreen({
    super.key,
    required this.year,
    required this.departmentId,
  });

  @override
  _AddSemesterScreenState createState() => _AddSemesterScreenState();
}

class _AddSemesterScreenState extends State<AddSemesterScreen> {
  final TextEditingController _semesterNameController = TextEditingController();
  String? _selectedYear;

  @override
  Widget build(BuildContext context) {
    final adminProvider =
        Provider.of<AdminDataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Add Semester',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: ColorConstants.primaryColor,
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // DropdownButtonFormField<String>(
            //   value: _selectedDepartment,
            //   hint: const Text('Select Department'),
            //   items: _departments
            //       .map((dept) => DropdownMenuItem(
            //             value: dept['departmentId'],
            //             child: Text(dept['name'] ?? ''),
            //           ))
            //       .toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       _selectedDepartment = value;
            //     });
            //   },
            // ),
            // const SizedBox(height: 10),
            CustomTextfield(
              controller: _semesterNameController,
              label: 'Semester Name',
              hint: 'Semester Name',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                title: "Add Semester",
                onTap: () async {
                  if (_semesterNameController.text.isNotEmpty) {
                    try {
                      await adminProvider.addSemester(
                        widget.year,
                        _semesterNameController.text,
                        widget.departmentId,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Semester added successfully!')),
                      );
                      _semesterNameController.clear();
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
