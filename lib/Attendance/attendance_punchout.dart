// ignore_for_file: prefer_typing_uninitialized_variables, void_checks, avoid_unnecessary_containers, library_prefixes, avoid_print, override_on_non_overriding_member, use_build_context_synchronously, deprecated_member_use, unrelated_type_equality_checks, sized_box_for_whitespace

import 'dart:convert';
import 'dart:io';
import 'package:flewac_technician/screen/Attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as Math;


class AttendancePunchOut extends StatefulWidget {
  final imagePath;
  final Position position;
  const AttendancePunchOut({super.key, required this.imagePath, required this.position});

  @override
  State<AttendancePunchOut> createState() => _AttendancePunchOutState();
}

class _AttendancePunchOutState extends State<AttendancePunchOut> {
  var distance = 0.00;
  static const LatLng _pGooglemap = LatLng(23.0417981, 72.6784746);
  double lat11 = 23.0417981;
  double lon11 = 72.6784746;
  var _imageBase64;
  var status;

  @override
  void initState() {
    super.initState();
    _getImageBase64();
    _distances();
  }

  @override
  void dispose() {
    distance.toDouble();
    super.dispose();
  }

  void _distances() async {
    distance = distanceInKmBetweenEarthCoordinates(lat11,lon11,widget.position.latitude,widget.position.longitude) * 1000;
  }

  void _getImageBase64() {
    File imageResponse = File(widget.imagePath);
    _imageBase64 = base64Encode(imageResponse.readAsBytesSync());
  }

  @override
  degreesToRadians(degrees) {
    return degrees * Math.pi / 180;
  }

  num distanceInKmBetweenEarthCoordinates(lat1,lon1,lat2,lon2) {
    var earthRadiusKm = 6371;
    var dLat = degreesToRadians(lat2-lat1);
    var dLon = degreesToRadians(lon2-lon1);
    lat1 = degreesToRadians(lat1) as double;
    lat2 = degreesToRadians(lat2) as double;

    var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return earthRadiusKm * c;
  }

  @override
  Widget build(BuildContext context) {
    final LatLng pGooglemapsource = LatLng(widget.position.latitude, widget.position.longitude);


    return  Scaffold(
      // drawer: const AppDrawer(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(0, 152, 218, 5),
          title: const Text('Punch Out',style: TextStyle(fontSize: 25,color: Colors.white),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body:Stack(
          children: [
            Container(
              // height: MediaQuery.of(context).size.height * 0.8,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                    target: _pGooglemap,
                    zoom: 15),
                markers: {
                  const Marker(markerId: MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _pGooglemap),
                  Marker(markerId: const MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: pGooglemapsource),
                },),),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.02,
              right: MediaQuery.of(context).size.width * 0.25,
              child: Container(
                height: 70,width: 200 ,
                child: ElevatedButton(
                  onPressed: () {
                      _attendancepunchout();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.transparent,), child: const Text('Submit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                ),),),
          ],)
    );
  }

  _attendancepunchout() async {
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
      "out_loc": "${widget.position.latitude},${widget.position.longitude}",
      "out_status": status.toString(),
      "accessToken": sharedPref.getString('accessToken'),
      "pic": _imageBase64,
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
    print(dataa["status"]);

    if(dataa["status"] == "success") {
      setState(() {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>  const AttendanceScreen()),(route) => false);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["status"])));
      });
    } else {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["msg"])));
    }
  }
}