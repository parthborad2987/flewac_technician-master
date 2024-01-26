// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, non_constant_identifier_names, use_build_context_synchronously, avoid_print, unrelated_type_equality_checks, prefer_typing_uninitialized_variables
import 'package:flewac_technician/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
   const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final _formfiled = GlobalKey<FormState>();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _userName.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);

    return Scaffold(
       backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color:  const Color.fromRGBO(0, 152, 218, 15),
          child: Center(
            child:SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 logoWidget("assets/logo.png",),
                  Container(
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(child: Padding(
                      padding: const EdgeInsets.all(20),
                      child:Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child:  Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                          child:  Form(
                            key: _formfiled,
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: MenWidget("assets/men.png",),
                                ),
                                TextFormField(
                                  controller: _userName,
                                  keyboardType: TextInputType.text,
                                  style:   const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),
                                  decoration: InputDecoration(
                                    labelText: 'Username',hintStyle: const TextStyle(color: Colors.black),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    focusColor: Colors.black,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:  BorderSide(color: Colors.grey.shade100,),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:   BorderSide(color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:  BorderSide(color: Colors.grey.shade300, width: 2.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return "Enter UserName";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                 TextFormField(
                                   obscureText: true,
                                  controller: _password,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: const TextStyle(color: Colors.black),
                                    focusColor: Colors.black,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:  BorderSide(color: Colors.grey.shade100,),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:   BorderSide(color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:  BorderSide(color: Colors.grey.shade300,
                                      width: 2.0,
                                    ),
                                   ),
                                  ),
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return "Enter Password";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 25,),
                                Container(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                    color:  const Color.fromRGBO(0, 152, 218, 15),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                    child: TextButton(
                                     child: isLoading
                                        ? const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(color: Colors.white,),
                                          SizedBox(width: 24,),
                                          Text('Please Wait...',style: TextStyle(color: Colors.white)),
                                        ],)
                                        : const Text('Sign in',
                                         style: TextStyle(fontSize: 20, color: Colors.white),) ,
                                         onPressed: () async {
                                          if(isLoading) return;
                                          if(_formfiled.currentState!.validate()) {
                                          setState(() => isLoading = true);
                                           provider.registerUser(
                                            context,
                                            _userName.text.toString(),
                                            _password.text.toString(),
                                           );
                                          }
                                        }
                                       ),
                                      ),
                                const SizedBox(height: 15,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                 ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  logoWidget(String s) {
    return Image.asset(s,
      alignment: const Alignment(0.4, 0),
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.6,
    );
  }

  MenWidget(String s) {
    return Image.asset(s,
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.7,
    );
  }
}


