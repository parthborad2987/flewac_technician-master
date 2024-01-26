// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flewac_technician/Loginscreen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Loginscreen/reset_password.dart';
import '../screen/job_screen.dart';

class LoginProvider with ChangeNotifier{

  void registerUser(BuildContext context,String userName,String password) async {
    try{
      var url = "https://crm.flewac.com/ANDROID/Tech/V1/Login/";
      var data = {"username": userName,"password": password};
      var body = json.encode(data);
      var urlParse = Uri.parse(url);
      Response response = await http.post(
        urlParse,
        body: {
          "type":"LOGIN",
          "data":body
        },
      );
      var dataa = jsonDecode(response.body);
      print(body);
      print(dataa);

      if(dataa["status"] == "success"){
        final SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('accessToken',dataa["accessToken"]);
        sp.setString('is_def',dataa["is_def"]);
        sp.setString('name',dataa["name"].toString());
        sp.setString('mobile',dataa["mobile"].toString());

        if(int.parse(dataa["is_def"]) == 1){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPassword(),),);
        }else{
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Jobs()),(route) => false);
        }
      }else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["msg"])));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login()),(route) => false);
      }
    } catch(e) {
      // print('$e');
    }
  }
}