import 'dart:typed_data';

import 'package:e_commerce_app_seller/models/user_model.dart';
import 'package:e_commerce_app_seller/services/global_methods.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/user_provider.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;
  // final String fcmtoken;

  final String friendName;
  final String myName;

  MessageTextField(
    this.currentId,
    this.friendId,
    // this.fcmtoken,

    this.friendName,
    this.myName,
  );

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  Uint8List? _file;
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isSeen = false;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.withOpacity(0.1)),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Center(
        child: Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)),
                          child: TextFormField(
                            maxLines: 5,
                            minLines: 1,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "";
                              } else {
                                return null;
                              }
                            },
                            controller: _controller,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(15, 1, 9, 5.0),
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black.withOpacity(0.5),
                                    fontWeight: FontWeight.w500),
                                hintText: "Tulis Pesan..."),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // InkWell(
                      //   onTap: () {
                      //     // Pilih Gambar
                      //     showModalBottomSheet(
                      //         isScrollControlled: true,
                      //         context: context,
                      //         shape: const RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.vertical(
                      //           top: Radius.circular(20),
                      //         )),
                      //         builder: (context) => Container(
                      //               height: 170,
                      //               child: Padding(
                      //                 padding: const EdgeInsets.all(20),
                      //                 child: Column(
                      //                   children: [
                      //                     Container(
                      //                       child: Row(
                      //                         mainAxisAlignment:
                      //                             MainAxisAlignment.start,
                      //                         children: [
                      //                           Text(
                      //                             'Pilih Tindakan',
                      //                             style: GoogleFonts.poppins(
                      //                                 textStyle: TextStyle(
                      //                               fontSize: 15,
                      //                               color: Colors.black,
                      //                               fontWeight: FontWeight.w600,
                      //                             )),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      //                     Padding(
                      //                       padding:
                      //                           const EdgeInsets.only(top: 15),
                      //                       child: Container(
                      //                         child: Row(
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment.center,
                      //                           children: [
                      //                             InkWell(
                      //                               onTap: () async {
                      //                                 try {
                      //                                   Uint8List file =
                      //                                       await pickImage(
                      //                                           ImageSource
                      //                                               .gallery);
                      //                                   if (file != null) {
                      //                                     setState(() {
                      //                                       _file = file;
                      //                                       Navigator.pop(
                      //                                           context);
                      //                                     });
                      //                                   }
                      //                                 } catch (e) {
                      //                                   print(e);
                      //                                 }
                      //                               },
                      //                               child: Container(
                      //                                   child: Column(
                      //                                 children: [
                      //                                   Icon(
                      //                                     CupertinoIcons
                      //                                         .folder_circle_fill,
                      //                                     color: Colors.purple,
                      //                                     size: 60,
                      //                                   ),
                      //                                   Text(
                      //                                     'File',
                      //                                     style: GoogleFonts
                      //                                         .poppins(
                      //                                             textStyle:
                      //                                                 TextStyle(
                      //                                       fontSize: 12,
                      //                                       color: Colors.black,
                      //                                       fontWeight:
                      //                                           FontWeight.w500,
                      //                                     )),
                      //                                   )
                      //                                 ],
                      //                               )),
                      //                             ),
                      //                             SizedBox(
                      //                               width: 20,
                      //                             ),

                      //                             // Camera
                      //                             InkWell(
                      //                               onTap: () async {
                      //                                 try {
                      //                                   Uint8List file =
                      //                                       await pickImage(
                      //                                           ImageSource
                      //                                               .camera);
                      //                                   if (file != null) {
                      //                                     setState(() {
                      //                                       _file = file;

                      //                                       Navigator.pop(
                      //                                           context);
                      //                                     });
                      //                                   }
                      //                                 } catch (e) {
                      //                                   print(e);
                      //                                 }
                      //                               },
                      //                               child: Container(
                      //                                   child: Column(
                      //                                 children: [
                      //                                   Icon(
                      //                                     CupertinoIcons
                      //                                         .camera_circle_fill,
                      //                                     color: Colors.purple,
                      //                                     size: 60,
                      //                                   ),
                      //                                   Text(
                      //                                     'Kamera',
                      //                                     style: GoogleFonts
                      //                                         .poppins(
                      //                                             textStyle:
                      //                                                 TextStyle(
                      //                                       fontSize: 12,
                      //                                       color: Colors.black,
                      //                                       fontWeight:
                      //                                           FontWeight.w500,
                      //                                     )),
                      //                                   )
                      //                                 ],
                      //                               )),
                      //                             )
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             ));
                      //   },
                      //   child: Container(
                      //       child: Icon(
                      //     CupertinoIcons.camera_circle_fill,
                      //     color: Colors.purple,
                      //     size: 35,
                      //   )),
                      // ),
                      const SizedBox(
                        width: 10,
                      ),
                      Transform.rotate(
                        angle: -150,
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            final isValid = _formKey.currentState!.validate();
                            FocusScope.of(context).unfocus();
                            if (isValid) {
                              _formKey.currentState!.save();

                              try {
                                String message = _controller.text;

                                _controller.clear();
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.currentId)
                                    .collection('messages')
                                    .doc(widget.friendId)
                                    .collection('chats')
                                    .add({
                                  "senderId": widget.currentId,
                                  "receiverId": widget.friendId,
                                  "message": message,
                                  "isSeen": isSeen,
                                  "type": "text",
                                  "date": DateTime.now(),
                                }).then((value) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.currentId)
                                      .collection('messages')
                                      .doc(widget.friendId)
                                      .set({
                                    "last_date": DateTime.now(),
                                    "sender_id": widget.currentId,
                                    "friend_id": widget.friendId,
                                    "last_msg": message,
                                    "isSeen": isSeen,
                                    "type": "text"
                                  });
                                });

                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.friendId)
                                    .collection('messages')
                                    .doc(widget.currentId)
                                    .collection("chats")
                                    .add({
                                  "senderId": widget.currentId,
                                  "receiverId": widget.friendId,
                                  "message": message,
                                  "isSeen": isSeen,
                                  "type": "text",
                                  "date": DateTime.now(),
                                }).then((value) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.friendId)
                                      .collection('messages')
                                      .doc(widget.currentId)
                                      .set({
                                    "last_msg": message,
                                    "sender_id": widget.currentId,
                                    "friend_id": widget.friendId,
                                    "isSeen": isSeen,
                                    "last_date": DateTime.now(),
                                    "type": "text"
                                  });
                                });

                                // FireStoreMethods().createNotificationChat(
                                //   widget.friendId,
                                //   widget.myImage,
                                //   widget.myName,
                                // );

                                // String myNamee = widget.myName;

                                // LocalNotificationService.sendNotification(
                                //     message: message,
                                //     title:
                                //         " $myNamee mengirim anda sebuah pesan",
                                //     token: widget.fcmtoken);
                                setState(() {
                                  _isLoading = false;
                                });
                              } on FirebaseException catch (error) {
                                GlobalMethods.errorDialog(
                                    subtitle: '${error.message}',
                                    context: context);
                                setState(() {
                                  _isLoading = false;
                                });
                              } catch (error) {
                                GlobalMethods.errorDialog(
                                    subtitle: '$error', context: context);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                          child: Transform.rotate(
                            angle: 5.5,
                            child: Container(
                              child: Icon(
                                Icons.send,
                                color: Colors.purple,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 10),
                // _file == null
                //     ? Container()
                //     : Container(
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Container(
                //               height: 200,
                //               width: 270,
                //               decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(15),
                //                   image: DecorationImage(
                //                     fit: BoxFit.fill,
                //                     image: MemoryImage(_file!),
                //                   )),
                //             ),
                //             _isLoading
                //                 ? CircularProgressIndicator(
                //                     color: Colors.purple,
                //                   )
                //                 : InkWell(
                //                     onTap: () async {
                //                       setState(() {
                //                         _isLoading = true;
                //                       });
                //                       try {
                //                         String? imageUrl;
                //                         if (_file == null) {
                //                           imageUrl = '';
                //                         } else {
                //                           imageUrl = await StorageMethods()
                //                               .uploadImageChatToStorage(
                //                                   "chat_image", _file!);
                //                         }
                //                         await FirebaseFirestore.instance
                //                             .collection('users')
                //                             .doc(widget.currentId)
                //                             .collection('messages')
                //                             .doc(widget.friendId)
                //                             .collection('chats')
                //                             .add({
                //                           "senderId": widget.currentId,
                //                           "receiverId": widget.friendId,
                //                           "message": imageUrl,
                //                           "isSeen": isSeen,
                //                           "type": "img",
                //                           "date": DateTime.now(),
                //                         }).then((value) {
                //                           FirebaseFirestore.instance
                //                               .collection('users')
                //                               .doc(widget.currentId)
                //                               .collection('messages')
                //                               .doc(widget.friendId)
                //                               .set({
                //                             "last_date": DateTime.now(),
                //                             "sender_id": widget.currentId,
                //                             "friend_id": widget.friendId,
                //                             "last_msg": imageUrl,
                //                             "isSeen": isSeen,
                //                             "type": "img",
                //                           });
                //                         });

                //                         await FirebaseFirestore.instance
                //                             .collection('users')
                //                             .doc(widget.friendId)
                //                             .collection('messages')
                //                             .doc(widget.currentId)
                //                             .collection("chats")
                //                             .add({
                //                           "senderId": widget.currentId,
                //                           "receiverId": widget.friendId,
                //                           "message": imageUrl,
                //                           "isSeen": isSeen,
                //                           "type": "img",
                //                           "date": DateTime.now(),
                //                         }).then((value) {
                //                           FirebaseFirestore.instance
                //                               .collection('users')
                //                               .doc(widget.friendId)
                //                               .collection('messages')
                //                               .doc(widget.currentId)
                //                               .set({
                //                             "last_msg": imageUrl,
                //                             "sender_id": widget.currentId,
                //                             "friend_id": widget.friendId,
                //                             "isSeen": isSeen,
                //                             "last_date": DateTime.now(),
                //                             "type": "img"
                //                           });
                //                         });
                //                         _file = null;
                //                         // FireStoreMethods()
                //                         //     .createNotificationChat(
                //                         //   widget.friendId,
                //                         //   widget.myImage,
                //                         //   widget.myName,
                //                         // );

                //                         // String myNamee = widget.myName;

                //                         // LocalNotificationService.sendNotification(
                //                         //     message: "Foto",
                //                         //     title:
                //                         //         " $myNamee mengirim anda sebuah pesan",
                //                         //     token: widget.fcmtoken);
                //                       } catch (err) {
                //                         GlobalMethods.errorDialog(
                //                             subtitle: err.toString(),
                //                             context: context);
                //                       }
                //                       setState(() {
                //                         _isLoading = false;
                //                       });
                //                       Navigator.canPop(context);
                //                     },
                //                     child: Padding(
                //                       padding: const EdgeInsets.all(15.0),
                //                       child: Container(
                //                           height: 40,
                //                           decoration: BoxDecoration(
                //                               color: Colors.purple,
                //                               borderRadius:
                //                                   BorderRadius.circular(10)),
                //                           child: Center(
                //                               child: Text(
                //                             'Kirim Foto',
                //                             style: GoogleFonts.poppins(
                //                                 textStyle: TextStyle(
                //                               fontSize: 15,
                //                               color: Colors.white,
                //                               fontWeight: FontWeight.w500,
                //                             )),
                //                           ))),
                //                     ))
                //           ],
                //         ),
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
