// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'submit_form.dart';

class DisplayPicture2Screen extends StatefulWidget {
  final String imagePath,latitude,longitude;
  const DisplayPicture2Screen({super.key, required this.imagePath, required this.latitude, required this.longitude});

  @override
  State<DisplayPicture2Screen> createState() => DisplayPicture2ScreenState();
}

class DisplayPicture2ScreenState extends State<DisplayPicture2Screen> {
  String currentAddress = 'My Address';
  Position? currentPosition;
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
                const SizedBox(height: 20,),
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
                        onPressed: () {
                          _getImageBase64();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SubmitForm(_imageBase64)),(route) => false);
                        },
                        child: const Text('Ok',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),),
        ],
      ),
    );
  }
}