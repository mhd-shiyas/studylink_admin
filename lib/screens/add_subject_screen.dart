import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink_admin/constants/color_constants.dart';
import 'package:studylink_admin/screens/subject_list_screen.dart';
import 'package:studylink_admin/widgets/custom_button.dart';

import '../controllers/admin_data_controller.dart';
import '../widgets/custom_textfield.dart';

class AddSubjectScreen extends StatefulWidget {
  final String semesterID;
  const AddSubjectScreen({
    super.key,
    required this.semesterID,
  });
  @override
  _AddSubjectScreenState createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final TextEditingController _subjectNameController = TextEditingController();
  String? _selectedDepartment;
  String? _selectedSemester;
  final List<Map<String, String>> _semesters = [];

  @override
  Widget build(BuildContext context) {
    final adminProvider =
        Provider.of<AdminDataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Add Subjects',
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
            CustomTextfield(
              controller: _subjectNameController,
              label: 'Subject Name',
              hint: 'Subject Name',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                title: 'Add Subject',
                onTap: () async {
                  if (_subjectNameController.text.isNotEmpty) {
                    try {
                      await adminProvider.addSubject(
                        widget.semesterID,
                        _subjectNameController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Subject added successfully!')),
                      );
                      _subjectNameController.clear();
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
