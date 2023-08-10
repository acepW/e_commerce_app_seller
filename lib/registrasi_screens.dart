import 'dart:typed_data';

import 'package:e_commerce_app_seller/auth_method.dart';
import 'package:e_commerce_app_seller/fetch_screen.dart';

import 'package:e_commerce_app_seller/login_screens.dart';
import 'package:e_commerce_app_seller/screens/loading_manager.dart';
import 'package:e_commerce_app_seller/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_seller/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrasiScreens extends StatefulWidget {
  const RegistrasiScreens({super.key});

  @override
  State<RegistrasiScreens> createState() => _RegistrasiScreensState();
}

class _RegistrasiScreensState extends State<RegistrasiScreens> {
  Uint8List? _image;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();

  final _userNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _alamatController = TextEditingController();

  final _fullNameFocusNode = FocusNode();
  final _passFocusNode = FocusNode();

  final _emailFocusNode = FocusNode();
  final _alamatFocusNode = FocusNode();
  final _userNameFocusNode = FocusNode();
  bool _obscureText = true;
  @override
  void dispose() {
    _fullNameController.dispose();

    _emailTextController.dispose();
    _userNameTextController.dispose();
    _passTextController.dispose();
    _alamatController.dispose();
    _fullNameFocusNode.dispose();
    _userNameFocusNode.dispose();
    _passFocusNode.dispose();

    super.dispose();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
      createdAt: Timestamp.now(),
      password: _passTextController.text,
      username: _userNameTextController.text,
      email: _emailTextController.text,
      name: _fullNameController.text,
      role: "seller",
      userCart: [],
      userWish: [],
      alamat: _alamatController.text,
    );
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => FetchScreen(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
            child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text("Lakukan registrasi kamu disini",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              color: Colors.purple,
                              fontSize: 30,
                              fontWeight: FontWeight.w500))),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    focusNode: _emailFocusNode,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_fullNameFocusNode),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTextController,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Please enter a valid Email adress";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.purple),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.purple),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Email",
                        icon: Icon(Icons.email),
                        hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    focusNode: _passFocusNode,
                    textInputAction: TextInputAction.next,
                    obscureText: _obscureText,
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passTextController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return "Please enter a valid password";
                      } else {
                        return null;
                      }
                    },
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_userNameFocusNode),
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.purple,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.purple),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.purple),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Password",
                        icon: Icon(
                          Icons.password,
                        ),
                        hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_passFocusNode),
                    controller: _fullNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a valid full name";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.purple),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.purple),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Nama Lengkap",
                        icon: Icon(Icons.people),
                        hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a valid  user name";
                      } else {
                        return null;
                      }
                    },
                    focusNode: _userNameFocusNode,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_fullNameFocusNode),
                    controller: _userNameTextController,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.purple),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.purple),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Username",
                        icon: Icon(Icons.people),
                        hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a valid  addreas";
                      } else {
                        return null;
                      }
                    },
                    focusNode: _alamatFocusNode,
                    textInputAction: TextInputAction.next,
                    controller: _alamatController,
                    minLines: 1,
                    maxLines: 2,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.purple),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.purple),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintText: "Alamat",
                        icon: Icon(Icons.people),
                        hintStyle: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500))),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      signUpUser();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "Registrasi",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Sudah punya akun?",
                          style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500)),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreens()));
                            },
                            child: Text("Login di sini",
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        color: Colors.purple,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500))))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
