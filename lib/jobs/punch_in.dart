// ignore_for_file: non_constant_identifier_names, avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, prefer_typing_uninitialized_variables, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'display_camera.dart';

class PunchIn extends StatefulWidget {
  final CameraDescription camera;
    const PunchIn({super.key, required this.camera});

  @override
  State<PunchIn> createState() => _PunchInState();
}

class _PunchInState extends State<PunchIn> {
  Position? currentPosition;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller = CameraController(widget.camera, ResolutionPreset.veryHigh);
    _initializeControllerFuture = _controller.initialize().then((_) {
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: const Text('Take a picture',
          style: TextStyle(color: Colors.white),
        ),
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
            return Container(
              height: MediaQuery.of(context).size.height * 0.99,
              width: MediaQuery.of(context).size.width * 0.99,
              child: CameraPreview(_controller),
            );
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
            if (!mounted) return;
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                  latitude: '${currentPosition?.latitude.toString()}',
                  longitude: '${currentPosition?.longitude.toString()}',
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

