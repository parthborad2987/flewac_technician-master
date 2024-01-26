// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../jobs/job_review.dart';

class JobPunchOutProvider with ChangeNotifier {
  void base642String(BuildContext context,resolution,Creview,imageBase64,imageEncoded,) async {
    List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");
    var url = "https://crm.flewac.com/ANDROID/Tech/V1/Jobs/";
    var sharedPref = await SharedPreferences.getInstance();

    var data = {
      "accessToken": sharedPref.getString('accessToken'),
      "jobid": sharedPref.getString('jobid'),
      "resolve": resolution,
      "review": Creview,
      "dlocation": "${locations.last.latitude.toString()},${locations.last.longitude.toString()}",
      "dpic": imageBase64,
      "sign": imageEncoded,
    };

    var body = json.encode(data);
    var urlParse = Uri.parse(url);
    Response response = await http.post(
      urlParse,
      body: {
        "type":"PUNCHOUT",
        "data":body
      },
    );
    var dataa = jsonDecode(response.body);
    print(body);
    print(dataa);
    if(dataa["status"] == "success") {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const JobReview()));
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["status"])));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["msg"])));
    }
  }

}