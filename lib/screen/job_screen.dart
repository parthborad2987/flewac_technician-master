// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, avoid_print, use_build_context_synchronously, unused_local_variable, unused_field, non_constant_identifier_names, unnecessary_import, prefer_final_fields, no_logic_in_create_state, unused_element, avoid_function_literals_in_foreach_calls, sort_child_properties_last, prefer_interpolation_to_compose_strings, deprecated_member_use
import 'dart:convert';
import 'dart:io';
import 'package:flewac_technician/screen/Attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Drawer/app_drawer.dart';
import 'package:camera/camera.dart';
import '../jobs/punch_in.dart';
import '../jobs/punch_out.dart';
import '../model/job_model.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key,});
  @override
  State<Jobs> createState() => _JobState();
}

class _JobState extends State<Jobs> {
  var logout;
  List<Job> job = [];
  var totalJobs = 0;
  Future<List<Job>>? gatdata;

  @override
  void initState() {
    super.initState();
    gatdata = getJobData();
    setState(() {});
  }

  Future<List<Job>> getJobData() async {
    var url = "https://crm.flewac.com/ANDROID/Tech/V1/Jobs/";
    var sharedPref = await SharedPreferences.getInstance();
    var data = {"accessToken": sharedPref.getString('accessToken'),};
    var body = json.encode(data);
    var urlParse = Uri.parse(url);
    Response response = await http.post(
      urlParse,
      body: {
        "type":"GETDATA",
        "data":body
      },
    );
    var dataa = jsonDecode(response.body);
    sharedPref.setString('id', dataa["data"][0]["id"]);
    if(dataa["status"] == "success") {
      sharedPref.getString('is_def');
      final List<dynamic> DataSet = dataa["data"];
      final List<Map<String, dynamic>> DataList = [];

      DataSet.forEach((data) {
        final Map<String,dynamic> DataList = {
         "id" : data["id"],
         "cname" : data["cname"],
         "site_adr" : data["site_adr"],
         "mobile" : data["mobile"],
         "phone" : data["phone"],
         "remark" : data["remark"],
         "payment" : data["payment"],
          "items" : data["items"],
         "status" : int.parse(data["status"])
       };

       job.add(Job.fromJson(DataList));
        totalJobs++;setState(() {

        });
      });
    return job;
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["status"])));
    } else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(dataa["msg"])));
      return job;
    }
  }

  Future<void> _refreshJob() async{
    setState(() {
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Jobs()));
    });
    print('refreshing stocks...');
  }

  Future<bool> _logoutapp() async {
    return await showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return WillPopScope(onWillPop: () async {
          const maxDuration = Duration(seconds: 2);
          final isWarning = logout == null;
          if(isWarning) {
            logout = DateTime.now();
            const snackbar = SnackBar(content: Text('Double tap tp Close app'),
              duration: maxDuration,);
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(snackbar);
            return false;
          } else {
            return true;
          }
        }, child: Container(
          child:  AlertDialog(
            scrollable: true,
            title:  const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Logout'),
                SizedBox(height: 20,),
                Text('Do you want to Logout ?',style: TextStyle(fontSize: 15),),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Cancel',
                  style: TextStyle(fontSize: 16, color: Colors.white),),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Logout',
                  style: TextStyle(fontSize: 20, color: Colors.white),),
                onPressed: () async {
                  if(Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else {
                    exit(0);
                  }
                },
              ),
            ],
          ),
        ),);
      },);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _logoutapp,
        child: Scaffold(
      backgroundColor: Colors.white,
        drawer: const AppDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(0, 152, 218, 5),
        title: const Text('Job', style: TextStyle(fontSize: 25, height: 0,color: Colors.white),),
        actions: [
          TextButton.icon(
              onPressed: ()  {
                setState(() {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceScreen(),));
                });
              }, icon:  const Icon(Icons.edit_calendar_outlined,color: Colors.white,), label: const Text(""),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
           Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80,),
              const Text(
                'You Have', style: TextStyle(fontSize: 25, color: Colors.black),
                textAlign: TextAlign.center,),
              const SizedBox(width: 5,),
              Text(totalJobs.toString(), style: const TextStyle(fontSize: 25, color: Colors.red),
                textAlign: TextAlign.center,),
              const SizedBox(width: 5,),
              const Text('jobs', style: TextStyle(fontSize: 25, color: Colors.black),
                textAlign: TextAlign.center,),
            ],),
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: FutureBuilder(
              future: gatdata,
              builder: (context, AsyncSnapshot  snapshot) {
                if(snapshot.hasData) {
                  return RefreshIndicator(
                    onRefresh: () {
                       return _refreshJob();
                    },
                  child: ListView.builder(
                    itemCount: job.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        child: Container(
                          // height: 900.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Company Name :-',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromRGBO(59, 89, 152, 5),
                                  ),
                                ),
                                const SizedBox(height: 13,),
                                Text(job[index].cname, style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                                  overflow: TextOverflow.ellipsis, maxLines: 3,),
                                const SizedBox(height: 13,),
                                const Text('Site Address :- ', style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color.fromRGBO(59, 89, 152, 5)),),
                                const SizedBox(height: 13,),
                                Row(crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const SizedBox(height: 13,),
                                    Expanded(child: TextButton(
                                      child: Text(
                                        job[index].site_adr,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 10,),
                                      onPressed: () {
                                        // ignore: unnecessary_string_interpolations
                                        var url = Uri.encodeComponent('${job[index].site_adr}');
                                        launch('https://www.google.com/maps/search/$url}');
                                       print(url);
                                      },
                                    ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 13,),
                                Row(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Mobile :- ', style: TextStyle(fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color.fromRGBO(59, 89, 152, 5)),),
                                    InkWell(onTap: () {
                                      launch('tel: ${job[index].mobile.toString()}');
                                    }, child: Text(job[index].mobile,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,)),
                                  ],
                                ),
                                const SizedBox(height: 13,),
                                Row(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Phone :- ', style: TextStyle(fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color.fromRGBO(59, 89, 152, 5)),),
                                     InkWell(onTap: () {
                                       launch('tel: ${job[index].phone.toString()}');
                                     }, child: Text(job[index].phone,
                                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
                                       overflow: TextOverflow.ellipsis,
                                       maxLines: 5,)),
                                  ],
                                ),
                                const SizedBox(height: 13,),
                                Center(
                                  child:Column(children: [
                                    Table(
                                      border: TableBorder.all(borderRadius: BorderRadius.circular(0)),
                                      columnWidths: const {
                                        0: FractionColumnWidth(0.8)
                                      },
                                      children: [
                                        buildRow(['Problem','qty']),
                                      ],
                                    ),
                                    Table(
                                      border: TableBorder.all(borderRadius: BorderRadius.circular(0)),
                                      columnWidths: const {
                                        0: FractionColumnWidth(0.8)
                                      },
                                      children: job[index].items.map((items){
                                        List<String> strlist = [items["actype"]+"   "+items["product"]];
                                        String str1 = strlist.join();
                                        return buildRow([str1,items["qty"]]);
                                      }).toList(),
                                    ),
                                  ],), 
                                ),
                                const SizedBox(height: 13,),
                                Row(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Remark :- ', style: TextStyle(fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color.fromRGBO(59, 89, 152, 5)),),
                                    Expanded(child: Text(job[index].remark,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 13,),
                                Row(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Payment :- ', style: TextStyle(fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color.fromRGBO(59, 89, 152, 5)),),
                                    Expanded(child: Text(job[index].payment,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 13,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    job[index].status == 1 ?
                                    ElevatedButton(
                                      onPressed: () async {
                                        var sharedPref = await SharedPreferences.getInstance();
                                        sharedPref.setString('jobid', job[index].id);
                                        WidgetsFlutterBinding.ensureInitialized();

                                        final camera = await availableCameras();

                                        final firstCamera = camera.last;

                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PunchIn(camera: firstCamera),));                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: const Color.fromRGBO(0, 152, 218, 15),
                                      ),
                                      child: const Text('Punch In',style: TextStyle(fontSize: 20, color: Colors.white),),
                                    ) :
                                    ElevatedButton(
                                      onPressed: () async {
                                        var sharedPref = await SharedPreferences.getInstance();
                                        sharedPref.setString('jobid', job[index].id);
                                        WidgetsFlutterBinding.ensureInitialized();
                                        final camera = await availableCameras();
                                        final firstCamera = camera.last;
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PunchOut(camera: firstCamera),));
                                        },
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color.fromRGBO(220, 53, 69, 15),
                                      ),

                                      child: const Text('Punch out',style: TextStyle(fontSize: 20, color: Colors.white),),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow buildRow(List<String> list) =>
      TableRow(
        decoration: const BoxDecoration(
            color: Colors.white60
        ),
        children: list.map((e) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Center(child: Text(e, style: const TextStyle(fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black),)),
          );
        }).toList(),
      );
}