// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPinProvider with ChangeNotifier {
  void resetPin(Oldpin,newpin,confirmpin,BuildContext context) async {
    var url = "https://crm.flewac.com/ANDROID/Tech/V1/Profile/";
    var sharedPref = await SharedPreferences.getInstance();
    var data = {
      "accessToken": sharedPref.getString('accessToken'),
      "old": Oldpin,
      "new": newpin,
    };
    var body = json.encode(data);
    var urlParse = Uri.parse(url);
    Response response = await http.post(
      urlParse,
      body: {
        "type":"CHANGEMPIN",
        "data":body
      },
    );
    var dataa = jsonDecode(response.body);
    print(body);
    print(dataa);

    if(dataa["status"] == "success"){
      sharedPref.getString('is_def');
      Oldpin.clear();
      newpin.clear();
      confirmpin.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["status"])));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["msg"])));
    }
  }

}