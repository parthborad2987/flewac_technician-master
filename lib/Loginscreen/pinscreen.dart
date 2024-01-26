// ignore_for_file: deprecated_member_use, non_constant_identifier_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, use_build_context_synchronously, avoid_print, unrelated_type_equality_checks
import 'dart:convert';
import 'package:flewac_technician/provider/pin_provider..dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/job_screen.dart';
import 'login_screen.dart';
import 'reset_password.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  var isLoading = false;
  final _formfiled = GlobalKey<FormState>();
  final TextEditingController _pinOne = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
        width: 56,
        height: 60,
        textStyle: TextStyle(
          fontSize: 22,
          color: Colors.black,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white54),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        )
    );
    final provider = Provider.of<PinProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color.fromRGBO(0, 152, 218, 15),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  logoWidget("assets/logo.png",),
                  Container(
                    child: const Text(
                      'Enter Pin',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                      child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          child: Form(
                            key: _formfiled,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: MenWidget("assets/men.png",),
                                ),
                                const SizedBox(height: 20),
                                Pinput(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  length: 4,
                                  defaultPinTheme: defaultPinTheme,
                                  focusedPinTheme: defaultPinTheme.copyWith(
                                    decoration: defaultPinTheme.decoration
                                        ?.copyWith(
                                      border: Border.all(color: Colors.green),
                                    ),
                                  ),
                                  controller: _pinOne,
                                  obscureText: true,
                                  onCompleted: (pin) => debugPrint(pin),
                                ),
                                const SizedBox(height: 25,),
                                Container(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                    color: const Color.fromRGBO(
                                        0, 152, 218, 15),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30),),
                                  ),
                                  child: Container(
                                    child: TextButton(
                                        child: isLoading
                                          ? const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(color: Colors.white,),
                                            SizedBox(width: 24,),
                                            Text('Please Wait...',style: TextStyle(color: Colors.white)),
                                          ],)
                                          : Text('Sign in', style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          if(isLoading) return;
                                          if (_formfiled.currentState!.validate()) {
                                            setState(() => isLoading = true);
                                            provider.registerPin(
                                                context,
                                                _pinOne.text.toString(),
                                            );
                                            print('pin');
                                          }
                                        }),),
                                ),
                                SizedBox(height: 15,),
                                TextButton(
                                    child: const Text('Back',
                                      style: TextStyle(
                                        fontSize: 20,
                                          color: Colors.black),),
                                    onPressed: () async {
                                      final SharedPreferences sharedPref
                                      = await SharedPreferences.getInstance();
                                      sharedPref.remove('accessToken');
                                      sharedPref.remove('is_def');
                                      print('accessToken');
                                      print('is_def');
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => const Login(),),);
                                    }),
                              ],
                            ),),
                        ),
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  logoWidget(String s) {
    return Image.asset(s,
      alignment: const Alignment(0.4, 0),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.2,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.6,
    );
  }

  MenWidget(String s) {
    return Image.asset(s,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.2,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.7,
    );
  }
}
