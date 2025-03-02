import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studylink_admin/controllers/admin_controller.dart';
import 'package:studylink_admin/controllers/auth_controller.dart';
import 'package:studylink_admin/controllers/home_controller.dart';
import 'package:studylink_admin/screens/splash_screen.dart';

import 'controllers/admin_data_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RequestProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdminDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdminAuthProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
