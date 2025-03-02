// year_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studylink_admin/constants/color_constants.dart';
import 'package:studylink_admin/screens/semester_list_screen.dart';

class YearSelectionScreen extends StatelessWidget {
  final String departmentId;
  // final String departmentName;

  const YearSelectionScreen({super.key, 
    required this.departmentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Select Year',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ColorConstants.primaryColor,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    width: 3,
                    color: ColorConstants.primaryColor.withOpacity(0.4),
                  )),
              title: Center(
                  child: Text(
                '2019-2022',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              )),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SemesterListScreen(
                      year: '2019-2022',
                      departmentId: departmentId,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    width: 3,
                    color: ColorConstants.primaryColor.withOpacity(0.4),
                  )),
              title: Center(
                child: Text(
                  '2023-Current',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SemesterListScreen(
                      year: '2023-Current',
                      departmentId: departmentId,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
