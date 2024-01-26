// ignore_for_file: unused_field, avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';
import 'package:flewac_technician/jobs/job_review.dart';
import 'package:flewac_technician/provider/Job_punchoutprovider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import '../Drawer/app_drawer.dart';
import '../screen/job_screen.dart';


class SubmitForm extends StatefulWidget {
  final String? _imageBase64;
   const SubmitForm(this._imageBase64,{super.key,});

  @override
  State<SubmitForm> createState() => _SubmitFormState();
}

class _SubmitFormState extends State<SubmitForm> {
  bool isLoading = false;
  final TextEditingController _resolution = TextEditingController();
  final TextEditingController _Creview = TextEditingController();
  final _signaturePadKey = GlobalKey<FormState>();

  SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );
  Uint8List? SignatureImage;
  var imageEncoded;

    @override
    Widget build(BuildContext context) {
      final provider = Provider.of<JobPunchOutProvider>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 152, 218, 5),
        title: const Text('SubmitForm',style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            minLines: 4,
            maxLines: 5,
            controller: _resolution,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: 'Resolution',
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10),),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          TextFormField(
            minLines: 5,
            maxLines: 5,
            controller: _Creview,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: 'Client Review',
              hintStyle: TextStyle(
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10),),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Signature(
            key: _signaturePadKey ,
            backgroundColor: Colors.grey.shade300,
            controller: signatureController,
            height: MediaQuery.of(context).size.height * 0.3,
            width:  MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
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
                 color:  Colors.red,
                 borderRadius:  const BorderRadius.all(Radius.circular(30),),
               ),
               child: TextButton(
                 child: const Text('Remove',
                   style: TextStyle(fontSize: 20, color: Colors.white),),
                 onPressed: () {
                   signatureController.clear();
                 },
               ),
             ),
             Container(
               height: 50,
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
                 child: isLoading ? const Row(mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Center(child: CircularProgressIndicator(color: Colors.white,),),
                   ],) : const Text('Submit',
                   style: TextStyle(fontSize: 20, color: Colors.white),),
                 onPressed: () async {
                   if(isLoading) return;
                   setState(() => isLoading = false);
                   final imageData = await signatureController.toPngBytes(); // must be called in async method
                   imageEncoded = base64.encode(imageData!);
                   signatureController.toPngBytes().then((data) {
                     imageEncoded = base64.encode(data!);
                   });
                   provider.base642String(context,
                       _resolution.text.toString(),
                       _Creview.text.toString(),
                       widget._imageBase64,
                       imageEncoded,
                   );
                 },
               ),
             ),
           ],
          ),
          const SizedBox(height: 20,),
           // if(SignatureImage != null) Image.memory(SignatureImage!),
         ],
        ),
      ),
     ),
    );
  }
}
