import 'package:e_commerce_app_seller/providers/dark_theme_provider.dart';
import 'package:e_commerce_app_seller/services/global_methods.dart';
import 'package:e_commerce_app_seller/models/user_model.dart';
import 'package:e_commerce_app_seller/screens/chat_screen/halaman_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../widgets/empty_screen.dart';

class HalamanPesan extends StatefulWidget {
  UserModel userModel;
  HalamanPesan(this.userModel);

  @override
  State<HalamanPesan> createState() => _HalamanPesanState();
}

class _HalamanPesanState extends State<HalamanPesan> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userModel.id)
            .collection('messages')
            .orderBy("last_date", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length < 1) {
              return EmptyScreen(
                title: 'Your message is empy',
                subtitle: 'Chat the Seller, dude',
                
                imagePath: 'assets/images/cart.png',
              );
            }
            return Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                      //   child: Container(
                      //     height: 40,
                      //     width: MediaQuery.of(context).size.width,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(5),
                      //         color: Colors.purple.withOpacity(0.10)),
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(left: 16),
                      //       child: TextField(
                      //         style: GoogleFonts.poppins(
                      //             textStyle: const TextStyle(
                      //                 fontSize: 12, fontWeight: FontWeight.w500)),
                      //         decoration: InputDecoration(
                      //           border: InputBorder.none,
                      //           icon: Icon(
                      //             Icons.search,
                      //             size: 15,
                      //           ),
                      //           hintText: 'Cari Pesan...',
                      //           hintStyle: GoogleFonts.poppins(
                      //               textStyle: const TextStyle(
                      //                   fontSize: 12,
                      //                   color: Colors.grey,
                      //                   fontWeight: FontWeight.w500)),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.userModel.id)
                                .collection('messages')
                                .orderBy("last_date", descending: true)
                                .snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      var friendId =
                                          snapshot.data.docs[index].id;
                                      var lastMsg =
                                          snapshot.data.docs[index]['last_msg'];

                                      bool isMe = snapshot.data.docs[index]
                                              ['sender_id'] ==
                                          widget.userModel.id;
                                      var last = snapshot
                                          .data.docs[index]['last_date']
                                          .toDate();

                                      String messageType =
                                          snapshot.data.docs[index]['type'];
                                      bool messageSeenMe =
                                          snapshot.data.docs[index]['isSeen'];
                                      bool messageSeenFriend =
                                          snapshot.data.docs[index]['isSeen'] ==
                                              friendId;

                                      Widget messageWidget = Container();
                                      Widget messageSeenWidgetMe = Container();
                                      Widget messageSeenWidgetfriend =
                                          Container();

                                      switch (messageSeenMe) {
                                        case false:
                                          messageSeenWidgetMe = Container(
                                            height: 20,
                                            width: 20,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.purple),
                                            child: Center(
                                                child: Text("1",
                                                    style: GoogleFonts.poppins(
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)))),
                                          );

                                          break;

                                        case true:
                                          messageSeenWidgetMe = Container();

                                          break;
                                      }

                                      switch (messageSeenFriend) {
                                        case false:
                                          messageSeenWidgetfriend = Container(
                                            height: 20,
                                            width: 20,
                                            child: Icon(
                                              Icons.done_all,
                                              color: Colors.grey,
                                            ),
                                          );

                                          break;

                                        case true:
                                          messageSeenWidgetfriend = Container(
                                            height: 20,
                                            width: 20,
                                            child: Icon(
                                              Icons.done_all,
                                              color: Colors.purple,
                                            ),
                                          );

                                          break;
                                      }

                                      switch (messageType) {
                                        case 'text':
                                          messageWidget = Container(
                                            height: 18,
                                            width: 300,
                                            child: Text(
                                              overflow: TextOverflow.ellipsis,
                                              "$lastMsg",
                                              style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black)),
                                            ),
                                          );
                                          break;

                                        case 'img':
                                          messageWidget = Container(
                                            height: 18,
                                            width: 300,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.camera_alt,
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "Foto",
                                                  style: GoogleFonts.poppins(
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                ),
                                              ],
                                            ),
                                          );
                                          break;
                                      }

                                      return FutureBuilder(
                                        future: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(friendId)
                                            .get(),
                                        builder: (context,
                                            AsyncSnapshot asyncSnapshot) {
                                          if (asyncSnapshot.hasData) {
                                            var friend = asyncSnapshot.data;

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 2),
                                              child: InkWell(
                                                onTap: () async {
                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(
                                                            widget.userModel.id)
                                                        .collection('messages')
                                                        .doc(friend['id'])
                                                        .update(
                                                            {"isSeen": true});
                                                  } on FirebaseException catch (error) {
                                                    GlobalMethods.errorDialog(
                                                        subtitle:
                                                            '${error.message}',
                                                        context: context);
                                                  } catch (error) {
                                                    GlobalMethods.errorDialog(
                                                        subtitle: '$error',
                                                        context: context);
                                                  } finally {}
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              HalamanChat(
                                                                myName: widget
                                                                    .userModel
                                                                    .name,
                                                                // fcmtoken:
                                                                //     friend['fcmtoken'],
                                                                currentUser:
                                                                    widget
                                                                        .userModel
                                                                        .id,
                                                                friendId:
                                                                    friendId,
                                                                friendName:
                                                                    friend[
                                                                        'name'],
                                                                // friendUsername: friend[
                                                                //     'username']
                                                              )));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 0.3,
                                                          color: Colors.grey)),
                                                  height: 72,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 24,
                                                            right: 24),
                                                    child: Row(
                                                      children: [
                                                        // CircleAvatar(
                                                        //   backgroundImage:
                                                        //       NetworkImage(friend[
                                                        //                   'photoUrl']
                                                        //               .toString()
                                                        //               .isEmpty
                                                        //           ? 'https://i.stack.imgur.com/l60Hf.png'
                                                        //           : friend[
                                                        //               'photoUrl']),
                                                        // ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 15),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    height: 21,
                                                                    width: 300,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          friend[
                                                                              'name'],
                                                                          style:
                                                                              GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  messageWidget
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 50,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  DateFormat
                                                                          .jm()
                                                                      .format(
                                                                          last),
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 5),
                                                                isMe
                                                                    ? messageSeenWidgetfriend
                                                                    : messageSeenWidgetMe
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          return LinearProgressIndicator();
                                        },
                                      );
                                    });
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.purple,
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        });
  }
}

class DikaPramana extends StatelessWidget {
  final notifikasi;
  const DikaPramana({
    Key? key,
    this.notifikasi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 72,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              ClipOval(
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/profil_dika.png'))),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 21,
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                overflow: TextOverflow.ellipsis,
                                "Dika Pramana",
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
                          width: 300,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            "Halo, Salam kenal ya!",
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    children: [
                      Text(
                        "17.30",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(height: 5),
                      notifikasi
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DibacaWidget extends StatelessWidget {
  const DibacaWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: const BoxDecoration(
          image:
              DecorationImage(image: AssetImage('assets/images/dibaca.png'))),
    );
  }
}

class BelumDibacaWidget extends StatelessWidget {
  const BelumDibacaWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/belum_dibaca.png'))),
    );
  }
}

class NotifWidget extends StatelessWidget {
  const NotifWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.purple),
      child: Center(
          child: Text("1",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)))),
    );
  }
}
