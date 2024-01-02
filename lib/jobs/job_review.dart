// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, dead_code

import 'dart:convert';
import 'package:flewac_technician/screen/job_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../model/job_model.dart';
import '../model/jobreview_model.dart';

class JobReview extends StatefulWidget {
  const JobReview({super.key});

  @override
  State<JobReview> createState() => _JobReviewState();
}

class _JobReviewState extends State<JobReview> {
  List<Jobreview> jobreview = [];
  var jobdataa;
  var getreview;

  @override
  void initState() {
    super.initState();
    setState(() {
      getreview = _jobreviewData();
    });
  }

   _jobreviewData() async {
   var sharedPref = await SharedPreferences.getInstance();
    var url = "https://crm.flewac.com/ANDROID/Tech/V1/Jobs/";
    var data = {
      "accessToken": sharedPref.getString('accessToken'),
      "jobid": sharedPref.getString('id'),
    };
    var body = json.encode(data);
    var urlParse = Uri.parse(url);
    Response response = await http.post(
      urlParse,
      body: {
        "type": "GETJOB",
        "data": body
      },
    );
    jobdataa = jsonDecode(response.body);
    // print(body);
    //  print(jobdataa["data"]);

    if(jobdataa["status"] == "success") {
      // for(Map<String, dynamic> data in jobdataa["data"]) {
        jobreview.add(Jobreview.fromJson(jobdataa["data"]));
      // }print(data);
      return jobreview;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(jobdataa["status"])));
    } else {
      return jobreview;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("msg")));
    }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 152, 218, 5),
        title: const Text('Job Review',style: TextStyle(fontSize: 25,color: Colors.white),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: getreview,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return ListView.builder(
              itemCount: jobreview.length,
              itemBuilder: (context, index) {
                print(jobreview[index].id);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Job Id:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue),),
                  Text('FSI'+' '+'${jobdataa["data"]["id"]}',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Client name:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue),),
                        Text('${jobdataa["data"]["cname"]}',style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 20),),
                        const Text('Site Address:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue),),
                        Text('${jobdataa["data"]["site_adr"]}',style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 20),),
                        const Text('Problem:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue),),
                        Text('${jobdataa["data"]["problem"]}',style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 20),),
                        const Text('Technician:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue),),
                        Text('${jobdataa["data"]["technician"]}',style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 20),),
                        const Text('Helper:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue),),
                        Text('${jobdataa["data"]["helper"]}',style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 20),),
                        const Text('PunchIn:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue),),
                        Image.network('${jobdataa["data"]["apic"]}',),
                        Text(DateFormat('dd/MM/yyyy hh:mm').format(DateTime.parse(jobdataa["data"]["start_at"])),style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 20),),
                        const Text('PunchOut:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue),),
                        Image.network('${jobdataa["data"]["dpic"]}',),
                        Text(DateFormat('dd/MM/yyyy hh:mm').format(DateTime.parse(jobdataa["data"]["end_at"])),style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 20),),
                        const Text('Solution:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue),),
                        Text('${jobdataa["data"]["resolve"]}',style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 20),),
                        const Text('Payment:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue),),
                        Text('${jobdataa["data"]["payment"]}',style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 20),),
                        const Text('Client Feedback:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue),),
                        Text('${jobdataa["data"]["review"]}',style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 20),),
                        const Text('Client Signature:-',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.blue),),
                        Image.network('${jobdataa["data"]["signature"]}',),
                        Center(child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                            color:  Colors.red,
                            borderRadius:  const BorderRadius.all(Radius.circular(30),),
                          ),
                          child: TextButton(
                            child: const Text('Done',
                              style: TextStyle(fontSize: 20, color: Colors.white),),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Jobs()));
                            },
                          ),
                        ),),
                        const SizedBox(height: 20,)
                      ],
                    ),
                  ),
                ],
              );
            },);
            } else {
             return const Center(child: CircularProgressIndicator(),);
          }
            },
           ),
    );
  }
}
