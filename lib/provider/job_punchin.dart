// ignore_for_file: use_build_context_synchronously, avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/job_screen.dart';

class JobPunchInProvider with ChangeNotifier {
  void base64String(BuildContext context,imageBase64) async {
    List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");

    var url = "https://crm.flewac.com/ANDROID/Tech/V1/Jobs/";
    var sharedPref = await SharedPreferences.getInstance();
    var data = {
      "accessToken": sharedPref.getString('accessToken'),
      "jobid": sharedPref.getString('jobid'),
      "alocation": "${locations.last.longitude.toString()},${locations.last.latitude.toString()}",
      "apic": imageBase64,
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
    print(dataa);
    if(dataa["status"] == "success") {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Jobs()),);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["status"])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["msg"])));
    }
  }
}
