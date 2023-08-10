import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final DateTime date;
  final bool isMe;
  SingleMessage({
    required this.message,
    required this.isMe,
    required this.date,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: isMe ? Alignment.topRight : Alignment.topLeft,
            child: Padding(
              padding: isMe
                  ? const EdgeInsets.only(right: 9)
                  : const EdgeInsets.only(left: 9),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.50),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15),
                    topRight: const Radius.circular(15),
                    bottomLeft: isMe
                        ? const Radius.circular(15)
                        : const Radius.circular(0),
                    bottomRight: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(15),
                  ),
                  color: isMe ? Colors.purple : Colors.grey.withOpacity(0.3),
                ),
                child: Text(
                  message,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 13,
                          color: isMe ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ),
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: isMe
                  ? const EdgeInsets.only(right: 9)
                  : const EdgeInsets.only(left: 9),
              child: Text(
                DateFormat.jm().format(date),
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
