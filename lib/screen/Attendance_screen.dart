// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, dead_code, unnecessary_null_comparison, prefer_typing_uninitialized_variables, avoid_print, unnecessary_string_interpolations, unused_local_variable, depend_on_referenced_packages

import 'dart:convert';
import 'package:flewac_technician/Drawer/responsive.dart';
import 'package:flewac_technician/model/todayattendance_model.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:flewac_technician/model/attendance_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Drawer/app_drawer.dart';
import '../Attendance/attendance_punchin_selfy.dart';
import '../Attendance/attendance_punchout_selfy.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key,});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var dataa;
  int selectedMonth = 1;
  var getAttendance;
  List<Attendance> attendance = [];
  List<ToDayAttendance> todayattendance = [];

  @override
  void initState() {
    super.initState();
     bindData();
  }

  void bindData() {
  //Bind data logic
    getAttendance = _MYATTENDANCE(selectedMonth);
  }

  Future<void> _refreshJob() async{
    setState(() {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const AttendanceScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 152, 218, 5),
        title: const Text('Attendance',style: TextStyle(fontSize: 25,color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Padding(padding: const EdgeInsets.only(top: 15,right: 10,left: 10,),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black,width: 4),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
              value: selectedMonth,
              isExpanded: true,
              iconSize: 36,
              icon: const Icon(Icons.arrow_drop_down,color: Colors.black,),
              items: List.generate(
                12,
                    (index) => DropdownMenuItem(
                value: index + 1,
                child: Text("  Month : ${index + 1}"),
               ),
              ),
              onChanged: (value) {
                attendance.clear();

                setState(() {
                  selectedMonth = value!;
                });
              },
                onTap: () {
                  attendance.clear();
                },
            ),
          ),),),

          Container(
                height: MediaQuery.of(context).size.height * 0.79,
                padding: const EdgeInsets.only(top: 70,right: 10, left: 10,bottom: 5),
                child : FutureBuilder(
                  future: _MYATTENDANCE(selectedMonth),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return RefreshIndicator(
                           onRefresh:  () {
                             return _refreshJob();
                           },
                          child: ListView.builder(
                        itemCount: attendance.length,
                        itemBuilder: (context, index) {
                           if(Responsive.isMobile(context)) {
                             return Padding(
                               padding: const EdgeInsets.symmetric(
                                 vertical: 8,),
                               child: Container(
                                 height: 130,width: 120,
                                 decoration: BoxDecoration(
                                   color: Colors.grey.shade200,
                                   borderRadius: const BorderRadius.all(Radius.circular(30),),
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Container(
                                       height: 110,width: 90,
                                       decoration: const BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.all(Radius.circular(40),),
                                       ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Text('${DateFormat('dd').format(DateTime.parse(attendance[index].date))}',style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                           const SizedBox(height: 10,),
                                           Text('${DateFormat('EEE').format(DateTime.parse(attendance[index].date))}',overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                                         ],
                                       ),
                                     ),
                                     const SizedBox(width: 30.0),
                                     Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         const Text('Punch In',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                         const SizedBox(height: 20,),
                                         Text('${attendance[index].punchin}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade700),),
                                       ],),
                                     const SizedBox(width: 30.0),
                                     Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         const Text('Punch Out',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                         const SizedBox(height: 20,),
                                         Text('${attendance[index].punchout}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade700),),
                                       ],),
                                   ],
                                 ),
                               ),
                             );
                           }
                           if(Responsive.isTablet(context)) {
                             return Padding(
                               padding: const EdgeInsets.symmetric(
                                 vertical: 8,),
                               child: Container(
                                 height: 130,width: 120,
                                 decoration: BoxDecoration(
                                   color: Colors.grey.shade200,
                                   borderRadius: const BorderRadius.all(Radius.circular(30),),
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Container(
                                       height: 110,width: 90,
                                       decoration: const BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.all(Radius.circular(40),),
                                       ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Text('${DateFormat('dd').format(DateTime.parse(attendance[index].date))}',style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                           const SizedBox(height: 10,),
                                           Text('${DateFormat('EEE').format(DateTime.parse(attendance[index].date))}',overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                                         ],
                                       ),
                                     ),
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                                     Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         const Text('Punch In',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                         const SizedBox(height: 20,),
                                         Text('${attendance[index].punchin}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade700),),
                                       ],),
                                     SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                                     Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         const Text('Punch Out',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                         const SizedBox(height: 20,),
                                         Text('${attendance[index].punchout}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade700),),
                                       ],),
                                   ],
                                 ),
                               ),
                             );
                           }
                           if(Responsive.isDesktop(context)) {
                             return Padding(
                               padding: const EdgeInsets.symmetric(
                                 vertical: 8,),
                               child: Container(
                                 height: MediaQuery.of(context).size.height * 0.15,width: MediaQuery.of(context).size.width * 0.9,
                                 decoration: BoxDecoration(
                                   color: Colors.grey.shade200,
                                   borderRadius: const BorderRadius.all(Radius.circular(30),),
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Container(
                                       height: 110,width: 90,
                                       decoration: const BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.all(Radius.circular(40),),
                                       ),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Text('${DateFormat('dd').format(DateTime.parse(attendance[index].date))}',overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                           const SizedBox(height: 10,),
                                           Text('${DateFormat('EEE').format(DateTime.parse(attendance[index].date))}',overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                                         ],
                                       ),
                                     ),
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.35),
                                     Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         const Text('Punch In',overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                         const SizedBox(height: 20,),
                                         Text('${attendance[index].punchin}',overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade700),),
                                       ],),
                                     SizedBox(width: MediaQuery.of(context).size.width * 0.35 ),
                                     Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         const Text('Punch Out',overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                                         const SizedBox(height: 20,),
                                         Text('${attendance[index].punchout}',overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey.shade700),),
                                       ],),
                                   ],
                                 ),
                               ),
                             );
                           }
                           return null;
                         },
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  },
                ),
              ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 12),
                child: FutureBuilder(
                 future: getAttendance,
                   builder: (context, snapshot) {
                   if(snapshot.hasData) {
                       return Column(children: [
                        Responsive.isMobile(context) ? Container(
                         height: 130,
                         decoration: const BoxDecoration(
                           color: Colors.amber,
                           borderRadius: BorderRadius.all(Radius.circular(30),),
                         ),
                         child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Container(
                                 height: 110,width: 90,
                                 decoration: const BoxDecoration(
                                   color: Color.fromRGBO(135, 68, 105, 25),
                                   borderRadius: BorderRadius.all(Radius.circular(40),),
                                 ),
                                 child:  Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Text('${DateTime.now().day}',style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                                     const SizedBox(height: 10,),
                                     Text('${DateFormat('EEE').format(DateTime.now())}',style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                                   ],
                                 ),
                               ),
                               const SizedBox(width: 60.0,),
                               Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} (Today)', style: const TextStyle(
                                       fontSize: 22,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.white),),
                                   const SizedBox(height: 20,),
                                   dataa["today"]["punchin"] == "--:--"
                                       ? TextButton(
                                     onPressed: () async {
                                       setState(() {});
                                       WidgetsFlutterBinding.ensureInitialized();

                                       final camera = await availableCameras();

                                       final firstCamera = camera.last;

                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => AttendancePunchInSelfy(camera: firstCamera)),
                                       );
                                     },
                                     child: const Text('Punch In', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
                                   )
                                       : dataa["today"]["punchout"] == "--:--" ?
                                     TextButton(
                                       onPressed: () async {
                                         setState(() {});
                                         WidgetsFlutterBinding.ensureInitialized();

                                         final camera = await availableCameras();

                                         final firstCamera = camera.last;

                                           Navigator.push(
                                             context,
                                             MaterialPageRoute(builder: (context) => AttendancePunOutSelfy(camera: firstCamera)),
                                           );
                                       },
                                       child: const Text('Punch Out', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
                                     )
                                   : const Text("")
                                 ],),
                             ],
                           ),
                       ) : Container(),
                        Responsive.isTablet(context) ? Container(
                           height: 130,
                           decoration: const BoxDecoration(
                             color: Colors.amber,
                             borderRadius: BorderRadius.all(Radius.circular(30),),
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Container(
                                 height: 110,width: 90,
                                 decoration: const BoxDecoration(
                                   color: Color.fromRGBO(135, 68, 105, 25),
                                   borderRadius: BorderRadius.all(Radius.circular(40),),
                                 ),
                                 child:  Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Text('${DateTime.now().day}',style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                                     const SizedBox(height: 10,),
                                     Text('${DateFormat('EEE').format(DateTime.now())}',style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                                   ],
                                 ),
                               ),
                                const SizedBox(width: 500.0),
                               Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} (Today)', style: const TextStyle(
                                       fontSize: 22,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.white),),
                                   const SizedBox(height: 20,),
                                   dataa["today"]["punchin"] == "--:--"
                                       ? TextButton(
                                     onPressed: () async {
                                       setState(() {});
                                       WidgetsFlutterBinding.ensureInitialized();

                                       final camera = await availableCameras();

                                       final firstCamera = camera.last;

                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => AttendancePunchInSelfy(camera: firstCamera)),
                                       );
                                     },
                                     child: const Text('Punch In', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
                                   )
                                       : dataa["today"]["punchout"] == "--:--" ?
                                   TextButton(
                                     onPressed: () async {
                                       setState(() {});
                                       WidgetsFlutterBinding.ensureInitialized();

                                       final camera = await availableCameras();

                                       final firstCamera = camera.last;

                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => AttendancePunOutSelfy(camera: firstCamera)),
                                       );
                                     },
                                     child: const Text('Punch Out', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
                                   )
                                       : const Text("")
                                 ],),
                             ],
                           ),
                         ) : Container(),
                        Responsive.isDesktop(context) ? Container(
                           height: 130,
                           decoration: const BoxDecoration(
                             color: Colors.amber,
                             borderRadius: BorderRadius.all(Radius.circular(30),),
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Container(
                                 height: 110,width: 90,
                                 decoration: const BoxDecoration(
                                   color: Color.fromRGBO(135, 68, 105, 25),
                                   borderRadius: BorderRadius.all(Radius.circular(40),),
                                 ),
                                 child:  Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Text('${DateTime.now().day}',overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                                     const SizedBox(height: 10,),
                                     Text('${DateFormat('EEE').format(DateTime.now())}',overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),),
                                   ],
                                 ),
                               ),
                               SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                               Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} (Today)', overflow: TextOverflow.ellipsis,style: const TextStyle(
                                       fontSize: 22,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.white),),
                                   const SizedBox(height: 20,),
                                   dataa["today"]["punchin"] == "--:--"
                                       ? TextButton(
                                     onPressed: () async {
                                       setState(() {});
                                       WidgetsFlutterBinding.ensureInitialized();

                                       final camera = await availableCameras();

                                       final firstCamera = camera.last;

                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => AttendancePunchInSelfy(camera: firstCamera)),
                                       );
                                     },
                                     child: const Text('Punch In',overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
                                   )
                                       : dataa["today"]["punchout"] == "--:--" ?
                                   TextButton(
                                     onPressed: () async {
                                       setState(() {});
                                       WidgetsFlutterBinding.ensureInitialized();

                                       final camera = await availableCameras();

                                       final firstCamera = camera.last;

                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => AttendancePunOutSelfy(camera: firstCamera)),
                                       );
                                     },
                                     child: const Text('Punch Out',overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
                                   )
                                       : const Text("")
                                 ],),
                             ],
                           ),
                         ) : Container(),
                       ],);
                   } else {
                     return Container();
                   }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

 Future _MYATTENDANCE(int Month) async {
    var sharedPref = await SharedPreferences.getInstance();
    var url = "https://crm.flewac.com/ANDROID/Tech/V1/Attendance/";
    var data = {
      "accessToken": sharedPref.getString('accessToken'),
      "month":selectedMonth,
    };print(selectedMonth);
    var body = json.encode(data);
    var urlParse = Uri.parse(url);
    Response response = await http.post(
      urlParse,
      body: {
        "type":"MYATTENDANCE",
        "data":body
      },
    );
    dataa = jsonDecode(response.body);

    if(dataa["status"] == "success") {
      for(Map<String,dynamic> data in dataa["data"]) {
        attendance.add(Attendance.fromJson(data));
      }
      return attendance;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["status"])));
    } else {
      return attendance;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["msg"])));
    }

    if(dataa["status"] == "success") {
      for (Map<String,dynamic> today in dataa["today"]) {
        todayattendance.add(ToDayAttendance.fromJson(today));
      }
      return todayattendance;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["status"])));
    } else {
      return todayattendance;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["msg"])));
    }
  }

 DropdownMenuItem<String> buildMenuItem(String item) =>
    DropdownMenuItem(
      value: item,
      child: Text(item,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
    );
}