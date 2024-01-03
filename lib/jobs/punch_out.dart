// ignore_for_file: non_constant_identifier_names, avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'display_camera2.dart';

class PunchOut extends StatefulWidget {
  final CameraDescription camera;
  const PunchOut({super.key, required this.camera,});

  @override
  State<PunchOut> createState() => _PunchOutState();
}

class _PunchOutState extends State<PunchOut> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String currentAddress = 'My Address';
  Position? currentPosition2;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize().then((_) {
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please keep your Location on.');
    }
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permission is denied');
      }
    }
    if(permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Permission is denied forever');
    }
    Position positioned = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(positioned.latitude, positioned.longitude);
      Placemark place = placemarks[0];
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    File fileData;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: const Text('Take a picture',style: TextStyle(color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(height: MediaQuery.of(context).size.height * 0.99,width: MediaQuery.of(context).size.width * 0.99,child: CameraPreview(_controller),);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.2,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () async {
            _determinePosition();
            try {
              await _initializeControllerFuture;
              XFile image = await _controller.takePicture();
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPicture2Screen(
                    imagePath: image.path, latitude: '${currentPosition2?.latitude}', longitude: '${currentPosition2?.longitude}',
                  ),
                ),
              );
            } catch (e) {
              print(e);
            }
          },
          child: const  Icon(Icons.camera_alt,color: Colors.black,),
        ),
      ),
    );
  }
}

