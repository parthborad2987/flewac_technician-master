// ignore_for_file: unused_local_variable, non_constant_identifier_names, deprecated_member_use, no_leading_underscores_for_local_identifiers, use_build_context_synchronously, avoid_print
import 'package:flewac_technician/provider/resetpassword_provider.dart';
import 'package:flewac_technician/provider/resetpin_provider..dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../Drawer/app_drawer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formfiled = GlobalKey<FormState>();
  final TextEditingController Oldpassword = TextEditingController();
  final TextEditingController newpassword = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final _formfiled = GlobalKey<FormState>();
  final TextEditingController _Oldpin = TextEditingController();
  final TextEditingController _newpin = TextEditingController();
  final TextEditingController _confirmpin = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 152, 218, 5),
        title: const Text('Profile',style: TextStyle(fontSize: 25,color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        shrinkWrap: true,
        children:[
            const SizedBox(height: 20,),
            _buildChangePassword(context),
            const SizedBox(height: 20,),
            _buildChangePin(),
            const SizedBox(height: 20,)
        ]
      ),
    );
  }

  Widget _buildChangePassword(BuildContext context) {
    final provider = Provider.of<ResetPasswordProvider>(context);

   return Center(
     child: Container(
        // height:  500.0,
        width:  MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child:Padding(
          padding: const EdgeInsets.all(20),
              child: Form(
              key: formfiled,
              child: Column(
              children: [
              const SizedBox(height: 20,),
              const Text('Change Password',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20,),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    controller: Oldpassword,
                    decoration: InputDecoration(
                      labelText: 'Enter old Password',
                      labelStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if(value!.isEmpty) {
                        return "Enter old Password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: newpassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter new password',
                      labelStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if(value!.isEmpty) {
                        return "Enter new Password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Enter Confirm Password',
                      labelStyle: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if(newpassword.text == confirmpassword.text) {
                        return 'Password do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20,),
                  Container(
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
                      color:  const Color.fromRGBO(0, 152, 218, 15),
                      borderRadius:  const BorderRadius.all(Radius.circular(30),),
                    ),
                    child: TextButton(
                      child: const Text('Submit',
                        style: TextStyle(fontSize: 20, color: Colors.white),),
                      onPressed: () {
                        if(formfiled.currentState!.validate()) {
                          provider.resetPass(
                              Oldpassword.text.toString(),
                              newpassword.text.toString(),
                              confirmpassword.text.toString(),
                              context,
                          );
                            confirmpassword.clear();
                        }
                      },
                    ),
                  ),
                 const SizedBox(height: 20,),
                ],
              ),
            ),
        ),
     ),
    );
 }

  Widget _buildChangePin() {
   final provider = Provider.of<ResetPinProvider>(context);
   final defaultPinTheme = PinTheme(
       width: 56,
       height: 60,
       textStyle: const TextStyle(
         fontSize: 22,
         color: Colors.black,
       ),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(8),
         border: Border.all(color: Colors.white54),
         boxShadow: const [
           BoxShadow(
             color: Colors.black,
             spreadRadius: 1,
             blurRadius: 1,
             offset: Offset(0, 1), // changes position of shadow
           ),
         ],
       ),
   );

   return Center(child: Container(
     padding: const EdgeInsets.all(10),
     // height: 550.0,
     width:  MediaQuery.of(context).size.width * 0.9,
     decoration: BoxDecoration(
       color: Colors.white,
       borderRadius: BorderRadius.circular(20),
       boxShadow: [
         BoxShadow(
           color: Colors.grey.withOpacity(0.5),
           spreadRadius: 5,
           blurRadius: 7,
           offset: const Offset(0, 3), // changes position of shadow
         ),
       ],
     ),
     child: Form(
         key: _formfiled,
         child:Padding(
           padding: const EdgeInsets.all(20),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const SizedBox(height: 10,),
               const Center(child: Text('Change Pin',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),),
               const SizedBox(height: 10,),
               const Text('Enter old Pin',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
               const SizedBox(height: 10,),
               Pinput(
                 textInputAction: TextInputAction.done,
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 length: 4,
                 defaultPinTheme: defaultPinTheme,
                 focusedPinTheme: defaultPinTheme.copyWith(
                   decoration: defaultPinTheme.decoration?.copyWith(
                     border: Border.all(color: Colors.green),
                   ),
                 ),
                 validator: (value) {
                   if(value!.isEmpty) {
                     return "Enter old Password";
                   }
                   return null;
                 },
                 controller: _Oldpin,
                 obscureText: true,
                 onCompleted: (pin) => debugPrint(pin),
               ),
               const SizedBox(height: 10,),
               const Text('Enter new Pin',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
               const SizedBox(height: 10,),
               Pinput(
                 textInputAction: TextInputAction.done,
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 length: 4,
                 defaultPinTheme: defaultPinTheme,
                 focusedPinTheme: defaultPinTheme.copyWith(
                   decoration: defaultPinTheme.decoration?.copyWith(
                     border: Border.all(color: Colors.green),
                   ),
                 ),
                 validator: (value) {
                   if(value!.isEmpty) {
                     return "Enter new Password";
                   }
                   return null;
                 },
                 controller: _newpin,
                 obscureText: true,
                 onCompleted: (pin) => debugPrint(pin),
               ),
               const SizedBox(height: 10,),
               const Text('Enter Confirm Pin',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
               const SizedBox(height: 10,),
               Pinput(
                 textInputAction: TextInputAction.done,
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 length: 4,
                 defaultPinTheme: defaultPinTheme,
                 focusedPinTheme: defaultPinTheme.copyWith(
                   decoration: defaultPinTheme.decoration?.copyWith(
                     border: Border.all(color: Colors.green),
                   ),
                 ),
                 validator: (value) {
                   if(_newpin.text != _confirmpin.text) {
                     return 'Password do not match';
                   }
                   return null;
                 },
                 controller: _confirmpin,
                 obscureText: true,
                 onCompleted: (pin) => debugPrint(pin),
               ),
               const SizedBox(height: 20,),
               Center(
                 child: Container(
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
                     color:  const Color.fromRGBO(0, 152, 218, 15),
                     borderRadius:  const BorderRadius.all(Radius.circular(30),),
                   ),
                   child: TextButton(
                     child: const Text('Submit',
                       style: TextStyle(fontSize: 20, color: Colors.white),),
                     onPressed: () {
                       if(_formfiled.currentState!.validate()) {
                         setState(() {
                           provider.resetPin(
                               _Oldpin.text.toString(),
                               _newpin.text.toString(),
                               _confirmpin.text.toString(),
                               context,
                           );
                         },
                        );
                       }
                     },
                   ),
                 ),
               ),
               const SizedBox(height: 10,),
             ],
           ),
         ),
       ),
     ),
   );
  }
}