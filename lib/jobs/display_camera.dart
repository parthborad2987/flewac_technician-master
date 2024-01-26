// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';
import 'package:flewac_technician/provider/job_punchin.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath,latitude,longitude;
  const DisplayPictureScreen({super.key, required this.imagePath, required this.latitude, required this.longitude});

  @override
  State<DisplayPictureScreen> createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  var _imageBase64;
  Position? currentPosition;
  String currentAddress = 'My Address';
  String? latlong = '',address = '';

  void _getImageBase64() {
    File imageResponse = File(widget.imagePath);
    _imageBase64 = base64Encode(imageResponse.readAsBytesSync());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobPunchInProvider>(context);

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
              fit: BoxFit.cover,
          ),
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
                          provider.base64String(context, _imageBase64);
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
}