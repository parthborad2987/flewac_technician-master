import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/job_screen.dart';

class ResetPinPasswordProvider with ChangeNotifier {
  void resetPasswordPin(newpassword,pinOne,BuildContext context) async {
    var url = "https://crm.flewac.com/ANDROID/Tech/V1/Login/";
    var sharedPref = await SharedPreferences.getInstance();
    var data = {"accessToken": sharedPref.getString('accessToken'),"password": newpassword,"mpin": pinOne};
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
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Jobs(),),);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["msg"])));
    }
  }
}