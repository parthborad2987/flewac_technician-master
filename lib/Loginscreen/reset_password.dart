// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers, unused_local_variable, non_constant_identifier_names, use_build_context_synchronously, avoid_print
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/job_screen.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formfiled = GlobalKey<FormState>();
  final TextEditingController newpassword = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final TextEditingController _pinOne = TextEditingController();
  final TextEditingController _pinTwo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 152, 218, 15),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 45),
        child:Center(child: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
            children: [
              logoWidget("assets/logo2.png",),
              _buildChangePassword(context),
              // _buildChangePin(),
              const SizedBox(height: 10,),
              Center(
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                    color:  const Color.fromRGBO(0, 152, 218, 15),
                    borderRadius:  const BorderRadius.all(Radius.circular(30),),
                  ),
                  child: TextButton(
                    child: const Text('Submit',
                      style: TextStyle(fontSize: 20, color: Colors.white),),
                    onPressed: () {
                      if(formfiled.currentState!.validate()) {
                        resetPasswordPin();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ),
      ),
     ),
     ),
    );
  }

  Widget _buildChangePassword(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
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
            spreadRadius: 3,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
    );

    return Form(
        key: formfiled,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child:SingleChildScrollView(child: Column(
              children: [
                const SizedBox(height: 20,),
                const Text('Reset Password',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: newpassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter new password',
                    labelStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if(value!.isEmpty) {
                      return "Enter new Password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: confirmpassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter Confirm Password',
                    labelStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if(newpassword.text != confirmpassword.text) {
                      return 'Password do not match';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20,),
                      const Center(child: Text('Reset Pin',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),),
                      const SizedBox(height: 10,),
                      const Text('Enter new Pin',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      const SizedBox(height: 15,),
                      Pinput(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        length: 4,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration?.copyWith(
                            border: Border.all(color: Colors.green),
                          ),
                        ),
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'Please Enter Pin';
                          }
                          return null;
                        },
                        controller: _pinOne,
                        obscureText: true,
                        onCompleted: (pin) => debugPrint(pin),
                      ),
                      const SizedBox(height: 15,),
                      const Text('Enter Confirm Pin',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      const SizedBox(height: 15,),
                      Pinput(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        length: 4,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration?.copyWith(
                            border: Border.all(color: Colors.green),
                          ),
                        ),
                        validator: (value) {
                          if(_pinOne.text != _pinTwo.text) {
                            return 'Password do not match';
                          }
                          return null;
                        },
                        controller: _pinTwo,
                        obscureText: true,
                        onCompleted: (pin) => debugPrint(pin),
                      ),
                      const SizedBox(height: 15,),
                    ],
                  ),
                ),
              ],
            ),
            ),
      ),
    );
  }

  void resetPasswordPin() async {
    var url = "https://crm.flewac.com/ANDROID/Tech/V1/Login/";
    var sharedPref = await SharedPreferences.getInstance();
    var data = {"accessToken": sharedPref.getString('accessToken'),"password": newpassword.text.toString(),"mpin": _pinOne.text.toString()};
    var body = json.encode(data);
    var urlParse = Uri.parse(url);
    Response response = await http.post(
      urlParse,
      body: {
        "type":"RESET",
        "data":body
      },
    );
    var dataa = jsonDecode(response.body);
    print(body);
    print(dataa);

    if(dataa["status"] == "success"){
      sharedPref.getString('is_def');
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Jobs(),),);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["msg"])));
    }
  }

  logoWidget(String s) {
    return Image.asset(s,
      scale: 0.6,
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.8,
    );
  }
}
