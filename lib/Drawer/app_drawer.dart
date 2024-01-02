// ignore_for_file: unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, avoid_unnecessary_containers, use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/Attendance_screen.dart';
import '../screen/job_screen.dart';
import '../screen/profile_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key,});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  DateTime? logout;
  var name;
  var mobile;

  @override
  void initState() {
    super.initState();
      namenumberText();
  }

  void namenumberText() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
     name = sp.getString('name');
     mobile = sp.getString('mobile');
     setState(() {
     });
  }

  Future _logoutapp() async {
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
    return Drawer(
      elevation: 0,
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color.fromRGBO(0, 152, 218, 5)),
            accountName: Text(name.toString()),
            accountEmail: Text(mobile.toString()),
            currentAccountPicture: GestureDetector(
              child:  CircleAvatar(
                radius: 80.0,
                backgroundColor: Colors.white,
                child: Image.asset("assets/men.png",),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.work,color: Colors.black,size: 35),
            title: const Text('Job',style: TextStyle(fontSize: 20),),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>  const Jobs()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_calendar_outlined,color: Colors.black,size: 35),
            title: const Text('Attendance',style: TextStyle(fontSize: 20),),
            onTap: () async {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceScreen(),));
            },
          ),
          ListTile(
            leading: const Icon(Icons.face,color: Colors.black,size: 35),
            title: const Text('Profile',style: TextStyle(fontSize: 20),),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Profile()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout,color: Colors.black,size: 35),
            title: const Text('Logout',style: TextStyle(fontSize: 20),),
            onTap: () {
              _logoutapp();
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}




