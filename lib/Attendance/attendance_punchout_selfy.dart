// ignore_for_file: non_constant_identifier_names, avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, prefer_typing_uninitialized_variables
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'attendance_punchout.dart';

class AttendancePunOutSelfy extends StatefulWidget {
  final CameraDescription camera;
  const AttendancePunOutSelfy({super.key, required this.camera});

  @override
  State<AttendancePunOutSelfy> createState() => _AttendancePunOutSelfyState();
}

class _AttendancePunOutSelfyState extends State<AttendancePunOutSelfy> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _determinePosition();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize().then((_) {
      if(mounted) {
        setState(() {
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    File fileData;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            return CameraPreview(_controller);
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
            Position position = await _determinePosition();
            try {
              await _initializeControllerFuture;
              XFile image = await _controller.takePicture();
               if (!mounted) return;
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AttendancePunchOut(
                imagePath: image.path, position: position,
              ),),);
            } catch (e) {
              print(e);
            }
          },
          child: const Icon(Icons.camera_alt,color: Colors.black,size: 50),
        ),
      ),
    );
  }
}

