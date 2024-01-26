// ignore_for_file: constant_identifier_names, non_constant_identifier_names, unused_local_variable, prefer_typing_uninitialized_variables, unrelated_type_equality_checks, avoid_print, unnecessary_null_comparison
import 'dart:async';
import 'package:flewac_technician/provider/attendance_punchinprovider..dart';
import 'package:flewac_technician/provider/attendance_punchoutprovider.dart';
import 'package:flewac_technician/provider/job_punchin.dart';
import 'package:flewac_technician/provider/login_provider.dart';
import 'package:flewac_technician/provider/pin_provider..dart';
import 'package:flewac_technician/provider/resetpassword_provider.dart';
import 'package:flewac_technician/provider/resetpin_provider..dart';
import 'package:flewac_technician/provider/resetpinpassword_provider..dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Loginscreen/first_screen.dart';
import 'Loginscreen/login_screen.dart';
import 'Loginscreen/pinscreen.dart';
import 'Loginscreen/reset_password.dart';
import 'provider/Job_punchoutprovider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginProvider()),
      ChangeNotifierProvider(create: (_) => PinProvider()),
      ChangeNotifierProvider(create: (_) => JobPunchInProvider()),
      ChangeNotifierProvider(create: (_) => JobPunchOutProvider()),
      ChangeNotifierProvider(create: (_) => AttendancePunchInProvider()),
      ChangeNotifierProvider(create: (_) => AttendancePunchOutProvider()),
      ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
      ChangeNotifierProvider(create: (_) => ResetPinProvider()),
      ChangeNotifierProvider(create: (_) => ResetPinPasswordProvider()),
    ],
    child: MaterialApp(
      theme: ThemeData(
      ),
      debugShowCheckedModeBanner: false,
      home: const FirstScreen(),
  ),);
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => SplashscreenState();
}

class SplashscreenState extends State<Splashscreen> {
  @override
 void initState() {
   whereToGo();
   super.initState();
  }

  void whereToGo() async {
  final SharedPreferences Shared = await SharedPreferences.getInstance();
  var accessToken = Shared.getString('accessToken');
  print(accessToken);
  var is_def = Shared.getString('is_def');

  Timer( const Duration(microseconds: 0),() {
    if(accessToken != null){
      if(is_def != 0){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PinScreen(),),);
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPassword(),),);
      }
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login(),),);
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}


