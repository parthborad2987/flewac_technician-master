// ignore_for_file: prefer_typing_uninitialized_variables, void_checks, avoid_unnecessary_containers, library_prefixes, avoid_print, override_on_non_overriding_member, use_build_context_synchronously, deprecated_member_use, unrelated_type_equality_checks, sized_box_for_whitespace, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flewac_technician/Drawer/responsive.dart';
import 'package:flewac_technician/provider/attendance_punchinprovider..dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:math' as Math;


class AttendancePunchIn extends StatefulWidget {
  final imagePath;
  final Position position;
  const AttendancePunchIn({super.key, required this.imagePath, required this.position});

  @override
  State<AttendancePunchIn> createState() => _AttendancePunchInState();
}

class _AttendancePunchInState extends State<AttendancePunchIn> {
  var status;
  var distance = 0.00;
  var _imageBase64;
  double lat11 = 23.0417981;
  double lon11 = 72.6784746;
  static const LatLng _pGooglemap = LatLng(23.0417981, 72.6784746);

  @override
  void initState() {
    super.initState();
    _distances();
    _getImageBase64();
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

  @override
  void dispose() {
    distance.toDouble();
    super.dispose();
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
    final provider = Provider.of<AttendancePunchInProvider>(context);
    final LatLng pGooglemapsource = LatLng(widget.position.latitude, widget.position.longitude);

    return  Scaffold(
      // drawer: const AppDrawer(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(0, 152, 218, 5),
          title: const Text('Punch In',style: TextStyle(fontSize: 25,color: Colors.white),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body:Stack(
          children: [
        Container(
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
            Responsive.isMobile(context) ? Positioned(
              bottom: MediaQuery.of(context).size.height * 0.02,
              right: MediaQuery.of(context).size.width * 0.25,
              child: Container(
                height: 70,width: 200 ,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                     provider.attendancepunchin(context, distance, status, widget.position.latitude, widget.position.longitude, _imageBase64);
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.transparent,), child: const Text('Submit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                ),),) : Container(),
            Responsive.isTablet(context) ? Positioned(
              bottom: MediaQuery.of(context).size.height * 0.02,
              right: MediaQuery.of(context).size.width * 0.39,
              child: Container(
                height: 70,width: 200 ,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      provider.attendancepunchin(context, distance, status, widget.position.latitude, widget.position.longitude, _imageBase64);
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.transparent,), child: const Text('Submit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                ),),) : Container(),

          ],)
    );
  }

}