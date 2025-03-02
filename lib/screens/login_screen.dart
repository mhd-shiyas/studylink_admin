import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:studylink_admin/screens/home_screen.dart';
import 'package:studylink_admin/screens/password_screen.dart';
import 'package:studylink_admin/screens/signup_screen.dart';

import '../constants/color_constants.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //final AuthController _authController = AuthController();

  // void login() {
  //   final authProvider =
  //       Provider.of<AuthenticationProvider>(context, listen: false);
  //   String email = emailController.text.trim();
  //   String password = passwordController.text.trim();
  //   authProvider.loginWithEmailPassword(
  //       email: email,
  //       password: password,
  //       context: context,
  //       onSuccess: () {
  //         authProvider.setSignIn().then((value) {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => HomeScreen(),
  //             ),
  //           );
  //         });
  //       });
  // }
  // void sendEmail() {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   String email = emailController.text.trim();
  //   authProvider.sendOtpToEmail(
  //     email,
  //     context: context,
  //     onOtpSent: (email) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => OtpScreen(email: email),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Country selecetCountry = Country(
  //   phoneCode: "91",
  //   countryCode: "IN",
  //   e164Sc: 0,
  //   geographic: true,
  //   level: 1,
  //   name: "India",
  //   example: "India",
  //   displayName: "India",
  //   displayNameNoCountryCode: "IN",
  //   e164Key: "",
  // );

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AdminAuthProvider>(context);

    emailController.selection = TextSelection.fromPosition(
        TextPosition(offset: emailController.text.length));
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0).copyWith(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 200,
                  width: 200,
                  child: SvgPicture.asset(
                    "assets/icons/login.svg",
                  )),
              Text(
                "Sign In.!",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Enter your email to access your account",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextfield(
                onChanged: (value) {
                  setState(() {
                    emailController.text = value;
                  });
                },
                fontStyle: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                label: "Email",
                hint: "Email",
                controller: emailController,
              ),
              const SizedBox(height: 12),
              CustomTextfield(
                onChanged: (value) {
                  setState(() {
                    passwordController.text = value;
                  });
                },
                fontStyle: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                label: "Password",
                hint: "Password",
                controller: passwordController,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ));
                  },
                  child: const Text(
                    'Forgot Your Password?',
                    style: TextStyle(
                      color: ColorConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  title: "login",
                  onTap: emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty
                      ? () {
                          authProvider.login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            context: context,
                            onSuccess: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            },
                          );
                          authProvider
                              .saveLoginSession(_firebaseAuth.currentUser!.uid);
                        }
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't Have an Account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: ColorConstants.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
