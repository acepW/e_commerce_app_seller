import 'package:e_commerce_app_seller/models/user_model.dart';
import 'package:e_commerce_app_seller/screens/chat_screen/halaman_chat.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class PesanBaruScreen extends StatefulWidget {
  UserModel userModel;
  PesanBaruScreen(this.userModel);

  @override
  State<PesanBaruScreen> createState() => _PesanBaruScreenState();
}

class _PesanBaruScreenState extends State<PesanBaruScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  int? _value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.purple.withOpacity(0.10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 5),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: searchController,
                        onFieldSubmitted: (String _) {
                          setState(() {
                            isShowUsers = true;
                          });
                          print(_);
                        },
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: const Icon(
                            Icons.search,
                            size: 15,
                          ),
                          hintText: 'Cari',
                          hintStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              if (isShowUsers)
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .where(
                        'username',
                        isGreaterThanOrEqualTo: searchController.text,
                      )
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HalamanChat(
                                        // myImage: widget.userModel.photoUrl,
                                        myName: (snapshot.data! as dynamic)
                                            .docs[index]['name'],
                                        // fcmtoken: (snapshot.data! as dynamic).docs[index]
                                        //     ['fcmtoken'],
                                        currentUser: widget.userModel.id,
                                        friendId: (snapshot.data! as dynamic)
                                            .docs[index]['uid'],
                                        friendName: (snapshot.data! as dynamic)
                                            .docs[index]['name'],
                                        // friendImage: (snapshot.data! as dynamic)
                                        //         .docs[index]['photoUrl']
                                        //         .toString()
                                        //         .isEmpty
                                        //     ? 'https://i.stack.imgur.com/l60Hf.png'
                                        //     : (snapshot.data! as dynamic)
                                        //         .docs[index]['photoUrl'],
                                        // friendUsername:
                                        //     (snapshot.data! as dynamic)
                                        //         .docs[index]['username']
                                      ))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24),
                            child: Container(
                              height: 72,
                              child: Row(
                                children: [
                                  (snapshot.data! as dynamic)
                                          .docs[index]['photoUrl']
                                          .toString()
                                          .isEmpty
                                      ? CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(
                                              'https://i.stack.imgur.com/l60Hf.png'),
                                        )
                                      : CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(
                                            (snapshot.data! as dynamic)
                                                .docs[index]['photoUrl'],
                                          )),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 21,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (snapshot.data! as dynamic)
                                                      .docs[index]['name'],
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 18,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (snapshot.data! as dynamic)
                                                      .docs[index]['username'],
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              else
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class PesanBaruWidget extends StatelessWidget {
  const PesanBaruWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Container(
          height: 72,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              ClipOval(
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/profil_dika.png'))),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 21,
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Surya Husain",
                              style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 18,
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "@suryahusain",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
