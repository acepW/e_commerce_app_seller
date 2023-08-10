import 'package:e_commerce_app_seller/models/user_model.dart';
import 'package:e_commerce_app_seller/providers/dark_theme_provider.dart';
import 'package:e_commerce_app_seller/screens/chat_screen/item_widget.dart';
import 'package:e_commerce_app_seller/services/global_methods.dart';
import 'package:e_commerce_app_seller/screens/chat_screen/message_text_fild.dart';
import 'package:e_commerce_app_seller/screens/chat_screen/single_img.dart';
import 'package:e_commerce_app_seller/screens/chat_screen/single_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_seller/widgets/text_widget.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../consts/firebase_consts.dart';
import '../../firestore_methods.dart';

class HalamanChat extends StatefulWidget {
  final String currentUser;
  final String friendId;
  // final String friendUsername;
  final String friendName;

  // final String fcmtoken;
  final String myName;

  HalamanChat({
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    // required this.friendUsername,
    // required this.fcmtoken,
    required this.myName,
  });

  @override
  State<HalamanChat> createState() => _HalamanChatState();
}

class _HalamanChatState extends State<HalamanChat> {
  final ScrollController messageController = ScrollController();
  final _quantityTextController = TextEditingController(text: '1');
  final TextEditingController _addressTextController =
      TextEditingController(text: "");


      

  bool isLoading = false;
  @override
  void dispose() {
    messageController.dispose();
    _quantityTextController.dispose();
    _addressTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Container(
            height: 72,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
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
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.friendName,
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   height: 18,
                          //   width: MediaQuery.of(context).size.width,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         widget.friendUsername,
                          //         style: GoogleFonts.poppins(
                          //             textStyle: TextStyle(
                          //                 color: Colors.white.withOpacity(0.5),
                          //                 fontSize: 10,
                          //                 fontWeight: FontWeight.w500)),
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                  context: context,
                  subtitle:
                      "Yakin menghapus percakapan dengan ${widget.friendName}?",
                  title: "Hapus Percakapan",
                  fct: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.currentUser)
                        .collection('messages')
                        .doc(widget.friendId)
                        .delete();

                    final collection = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.currentUser)
                        .collection('messages')
                        .doc(widget.friendId)
                        .collection('chats')
                        .get();

                    final batch = FirebaseFirestore.instance.batch();

                    for (final doc in collection.docs) {
                      batch.delete(doc.reference);
                    }

                    return batch.commit();
                  },
                );
              },
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ))
        ],
      ),
      body: isLoading
          ? Container(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.currentUser)
                            .collection('messages')
                            .doc(widget.friendId)
                            .collection('nego')
                            .orderBy("createdAt", descending: true)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            var snap = snapshot.data;
                            return ListView.builder(
                                controller: messageController,
                                itemCount: 1,
                                reverse: false,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  String alamatSeller =  snapshot.data.docs[index]['alamatSeller'];
                                  String deskripsi =snapshot.data.docs[index]['deskripsi'];
                                  String imageUrl = snapshot.data.docs[index]['imageUrl'];
                                  String category = snapshot.data.docs[index]['productCategoryName'];
                                  String sellerId = snapshot.data.docs[index]['sellerId'];
                                  String SellerName = snapshot.data.docs[index]['sellerName'];
                                  String title = snapshot.data.docs[index]['title'];
                                  
                                  String price =
                                      snapshot.data.docs[index]['price'];
                                  int prices = int.parse(
                                      snapshot.data.docs[index]['price']);
                
                                  int totalPrice = prices *
                                      int.parse(_quantityTextController.text);
                                  String prodId =
                                      snapshot.data.docs[index]['id'];


                                      User? user = authInstance.currentUser;

                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            snapshot.data
                                                                    .docs[index]
                                                                ['imageUrl']),fit: BoxFit.fill)),
                                              ),
                                              Expanded(
                                                  child: Column(
                                                children: [
                                                  Text(snapshot.data.docs[index]
                                                      ['title']),
                                                  Text(snapshot.data.docs[index]
                                                      ['price']),
                                                  Text(totalPrice
                                                      .toStringAsFixed(2))
                                                ],
                                              )),
                                              
                                            
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: InkWell(
                                          onTap: () async{
                                            showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'Update'),
                                                                content:
                                                                    TextField(
                                                                      
                                                                  // onChanged: (value) {
                                                                  //   print(
                                                                  //       '_addressTextController.text ${_addressTextController.text}');
                                                                  // },
                                                                  controller:
                                                                      _addressTextController,
                                                                  maxLines: 5,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                          hintText:
                                                                              "Product Price"),
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      
                                                                      try {
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('users')
                                                                            .doc(widget.currentUser)
                                                                            .collection('messages')
                                                                            .doc(widget.friendId)
                                                                            .collection('nego')
                                                                            .doc(prodId)
                                                                            .update({
                                                                          'price':
                                                                              _addressTextController.text,
                                                                        });
                
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('users')
                                                                            .doc(widget.friendId)
                                                                            .collection('messages')
                                                                            .doc(widget.currentUser)
                                                                            .collection('nego')
                                                                            .doc(prodId)
                                                                            .update({
                                                                          'price':
                                                                              _addressTextController.text,
                                                                        });
                                                                        Navigator.pop(context);
                                                                        setState(
                                                                            () {
                                                                          price =
                                                                              _addressTextController.text;
                                                                        });
                                                                      } catch (err) {
                                                                        GlobalMethods.errorDialog(
                                                                            subtitle:
                                                                                err.toString(),
                                                                            context: context);
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        'Update'),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                 
                   
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.green,
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            child: Center(
                                              child: TextWidget(
                                                text: "Update Harga Produk",
                                                color: Colors.white,
                                                textSize: 18,
                                                isTitle: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                     
                                    ],
                                  );
                                  // ItemProductNego(
                                  //   imageUrl: snapshot.data.docs[index]
                                  //       ['imageUrl'],
                                  //   salePrice: snapshot.data.docs[index]
                                  //       ['salePrice'],
                                  //   title: snapshot.data.docs[index]['title'],
                                  //   price: snapshot.data.docs[index]['price'],
                                  //   isOnSale: snapshot.data.docs[index]
                                  //       ['isOnSale'],
                                  //   displayName: widget.myName,
                                  //   productId: snapshot.data.docs[index]
                                  //       ['id'],
                                  //   sellerId: widget.friendId,
                                  //   sellerName: widget.friendName,
                                  //   totalPrice: snapshot.data.docs[index]
                                  //       ['price'].toString(),
                                  //   uid: widget.currentUser,
                                  // );
                                });
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ),
                Expanded(
                    child: Container(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.currentUser)
                          .collection('messages')
                          .doc(widget.friendId)
                          .collection('chats')
                          .orderBy("date", descending: false)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                         
                          FireStoreMethods.updateSend(
                              widget.currentUser, widget.friendId);
                          //    SchedulerBinding.instance.addPostFrameCallback((_) {
                          //   messageController.jumpTo(
                          //       messageController.position.maxScrollExtent);
                          // });

                          return isLoading
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sedang memuat data',
                                      style: TextStyle(color: Colors.purple),
                                    ),
                                    CircularProgressIndicator(
                                      color: Colors.purple,
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  controller: messageController,
                                  itemCount: snapshot.data.docs.length,
                                  reverse: false,
                                  shrinkWrap: true,
                                 physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                 
                                    bool isMe = snapshot.data.docs[index]
                                            ['senderId'] ==
                                        widget.currentUser;
                                    String messageType =
                                        snapshot.data.docs[index]['type'];
                                    Widget messageWidget = Container();

                                    switch (messageType) {
                                      case 'text':
                                        messageWidget = SingleMessage(
                                          message: snapshot.data.docs[index]
                                              ['message'],
                                          isMe: isMe,
                                          date: snapshot
                                              .data.docs[index]['date']
                                              .toDate(),
                                        );
                                        break;

                                      case 'img':
                                        // messageWidget = SingleImage(
                                        //     message: snapshot.data.docs[index]
                                        //         ['message'],
                                        //     isMe: isMe,
                                        //     date: snapshot
                                        //         .data.docs[index]['date']
                                        //         .toDate());
                                        break;
                                    }

                                    return messageWidget;
                                  });
                        }
                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.purple,
                        ));
                      }),
                )),
                MessageTextField(
                  widget.currentUser,
                  widget.friendId,
                  // widget.fcmtoken,

                  widget.friendName,
                  widget.myName,
                )
              ],
            ),
    );
  }
}

class ChatBoxPeople extends StatefulWidget {
  final String message;
  const ChatBoxPeople({Key? key, required this.message}) : super(key: key);

  @override
  State<ChatBoxPeople> createState() => _ChatBoxPeopleState();
}

class _ChatBoxPeopleState extends State<ChatBoxPeople> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 9),
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
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.50),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.withOpacity(0.3),
              ),
              child: Text(
                widget.message,
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBoxMe extends StatelessWidget {
  final String message;
  const ChatBoxMe({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 9),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.50),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.withOpacity(0.3),
            ),
            child: Text(
              message,
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
    );
  }
}

Widget quantityControl(
    {required Function fct, required IconData icon, required Color color}) {
  return Flexible(
    flex: 2,
    child: Material(
      borderRadius: BorderRadius.circular(12),
      color: color,
      child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            fct();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          )),
    ),
  );
}
