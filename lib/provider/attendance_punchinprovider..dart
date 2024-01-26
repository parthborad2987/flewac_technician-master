// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/Attendance_screen.dart';

class AttendancePunchInProvider with ChangeNotifier {
  attendancepunchin(BuildContext context,distance,status,latitude,longitude,_imageBase64) async {
    var sharedPref = await SharedPreferences.getInstance();
    if(distance < 100) {
      status = 1;
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You are in a Office')));
    } else {
      status = 0;
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You are in a not Office')));
    }print(status.toString());

    var url = "https://crm.flewac.com/ANDROID/Tech/V1/Attendance/";
    var data = {
      "in_loc": "$latitude,$longitude",
      "in_status": status.toString(),
      "accessToken": sharedPref.getString('accessToken'),
      "pic": _imageBase64,
    };
    var body = json.encode(data);
    var urlParse = Uri.parse(url);
    Response response = await http.post(
      urlParse,
      body: {
        "type":"PUNCHIN",
        "data":body
      },
    );
    var dataa = jsonDecode(response.body);
    print(body);
    print(dataa["status"]);
    if(dataa["status"] == "success") {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>  const AttendanceScreen()),(route) => false);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["status"])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["msg"])));
    }
  }
}