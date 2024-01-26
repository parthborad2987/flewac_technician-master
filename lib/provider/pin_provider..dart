// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, non_constant_identifier_names
import 'dart:convert';
import 'package:flewac_technician/Loginscreen/pinscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Loginscreen/reset_password.dart';
import '../screen/job_screen.dart';

class PinProvider with ChangeNotifier{
  void registerPin(BuildContext context,pinOne) async {
    var url = "https://crm.flewac.com/ANDROID/Tech/V1/Login/";
    var sharedPref = await SharedPreferences.getInstance();
    var data = {
      "accessToken": sharedPref.getString('accessToken'),
      "mpin": pinOne,
    };
    var body = json.encode(data);
    var urlParse = Uri.parse(url);
    Response response = await http.post(
      urlParse,
      body: {
        "type": "MPIN",
        "data": body
      },
    );
    var dataa = jsonDecode(response.body);
    print(body);
    print(dataa);

    if (dataa["status"] == "success") {
      sharedPref.setString('accessToken',dataa["accessToken"]);
      var is_def = sharedPref.getString('is_def');
      if(is_def == 1){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPassword(),),);
      }else{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Jobs()),(route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(dataa["msg"])));
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PinScreen(),),);
    }
  }
}