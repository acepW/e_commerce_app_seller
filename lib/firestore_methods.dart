import 'package:e_commerce_app_seller/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? myDocument;

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
//

  // Delete Comment
  Future<String> deleteComment(String postId, String commentId) async {
    String res = "Some error occurred";
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static updateSend(String myId, String friendId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myId)
          .collection('messages')
          .doc(friendId)
          .update({"isSeen": true});
    } catch (e) {
      print("error is $e");
    }
  }

  static deleteMessage(String myId, String friendId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(myId)
          .collection('messages')
          .doc(friendId)
          .delete();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .collection('messages')
          .doc(myId)
          .delete();
    } catch (e) {
      print("error is $e");
    }
  }

  createNotificationChat(
    String recUid,
    String friendImage,
    String myName,
  ) {
    FirebaseFirestore.instance
        .collection("notification")
        .doc(recUid)
        .collection("myNotification")
        .add({
      'message': "Mengirim sebuah pesan",
      'image': friendImage,
      'name': myName,
      'judul': "chat",
      'type': "chat",
      'time': DateTime.now()
    });
  }

  createNotificationFollow(
    String recUid,
    String friendImage,
    String myName,
  ) {
    FirebaseFirestore.instance
        .collection("notification")
        .doc(recUid)
        .collection("myNotification")
        .add({
      'message': "Mulai mengikuti anda",
      'image': friendImage,
      'name': myName,
      'judul': "follow",
      'type': "follow",
      'time': DateTime.now()
    });
  }

  createNotificationLike(
    String recUid,
    String friendImage,
    String myName,
  ) {
    FirebaseFirestore.instance
        .collection("notification")
        .doc(recUid)
        .collection("myNotification")
        .add({
      'message': "menyukai postingan anda",
      'image': friendImage,
      'name': myName,
      'judul': "like",
      'type': "like",
      'time': DateTime.now()
    });
  }

  createNotificationComent(
    String recUid,
    String friendImage,
    String myName,
    String judul,
  ) {
    FirebaseFirestore.instance
        .collection("notification")
        .doc(recUid)
        .collection("myNotification")
        .add({
      'message': "mengomentari postingan anda",
      'image': friendImage,
      'name': myName,
      'judul': judul,
      'type': "coment",
      'time': DateTime.now()
    });
  }

  void setMessageSeen(
    BuildContext context,
    String reciverUserId,
    String messageId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages')
          .doc(reciverUserId)
          .collection('chats')
          .doc(messageId)
          .update({
        "isSeen": true,
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(reciverUserId)
          .collection('messages')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("chats")
          .doc(messageId)
          .update({
        "isSeen": true,
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
