import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink_admin/controllers/auth_controller.dart';
import 'package:studylink_admin/screens/department_list_screen.dart';
import 'package:studylink_admin/screens/login_screen.dart';
import 'package:studylink_admin/screens/teacher_request_screen.dart';

import '../constants/color_constants.dart';
import '../controllers/admin_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: Text(
          "Admin Panel",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorConstants.primaryColor,
        leading: InkWell(
            onTap: () {
              Provider.of<AdminAuthProvider>(context, listen: false).logout(
                  onSuccess: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
            child: Icon(
              Icons.logout,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: RefreshIndicator(
          onRefresh: fetchInitialData,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DepartmentListScreen(),
                    )),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ColorConstants.secondaryColor.withOpacity(0.7),
                        width: 2,
                      )),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text(
                        'Add Departments',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<RequestProvider>(
        builder: (context, value, child) => InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeacherRequestsPage(),
              )),
          child: Container(
            margin: EdgeInsets.all(10),
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
                color: value.pendingRequests.isEmpty
                    ? ColorConstants.secondaryColor
                    : ColorConstants.primaryColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: ColorConstants.primaryColor.withOpacity(0.5),
                    width: 2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Teachers Requests',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: value.pendingRequests.isEmpty
                          ? ColorConstants.primaryColor
                          : Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    value.pendingRequests.isNotEmpty
                        ? CircleAvatar(
                            radius: 5,
                          )
                        : SizedBox(),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "${value.pendingRequests.length.toString()} Requests",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: value.pendingRequests.isEmpty
                              ? ColorConstants.primaryColor
                              : Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
