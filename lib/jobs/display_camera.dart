// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/job_screen.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath,latitude,longitude;
  const DisplayPictureScreen({super.key, required this.imagePath, required this.latitude, required this.longitude});

  @override
  State<DisplayPictureScreen> createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  String currentAddress = 'My Address';
  Position? currentPosition;
  String? latlong = '',address = '';
  var _imageBase64;

  void _getImageBase64() {
    File imageResponse = File(widget.imagePath);
    _imageBase64 = base64Encode(imageResponse.readAsBytesSync());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.file(File(widget.imagePath),
              height:MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover),

          Padding(padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Retry',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      TextButton(
                        onPressed: () async {
                           _getImageBase64();
                          base64String();
                        },
                        child: const Text('Ok',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void base64String() async {
    List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");

    var url = "https://crm.flewac.com/ANDROID/Tech/V1/Jobs/";
    var sharedPref = await SharedPreferences.getInstance();
    var data = {
      "accessToken": sharedPref.getString('accessToken'),
      "jobid": sharedPref.getString('jobid'),
      "alocation": "${locations.last.longitude.toString()},${locations.last.latitude.toString()}",
      "apic": _imageBase64,
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
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Jobs()),(route) => false);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["status"])));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["msg"])));
    }
  }
}