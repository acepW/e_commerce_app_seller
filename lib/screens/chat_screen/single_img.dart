// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// class SingleImage extends StatelessWidget {
//   final String message;
//   final DateTime date;
//   final bool isMe;
//   SingleImage({
//     required this.message,
//     required this.isMe,
//     required this.date,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 5),
//       child: Column(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             alignment: isMe ? Alignment.topRight : Alignment.topLeft,
//             child: Padding(
//               padding: isMe
//                   ? const EdgeInsets.only(right: 9)
//                   : const EdgeInsets.only(left: 9),
//               child: Container(
//                   constraints: BoxConstraints(
//                       maxWidth: MediaQuery.of(context).size.width * 0.60),
//                   padding: const EdgeInsets.all(0),
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: const Radius.circular(0),
//                       topRight: const Radius.circular(0),
//                       bottomLeft: isMe
//                           ? const Radius.circular(0)
//                           : const Radius.circular(0),
//                       bottomRight: isMe
//                           ? const Radius.circular(0)
//                           : const Radius.circular(0),
//                     ),
//                     color: isMe ? Colors.purple : Colors.grey.withOpacity(0.3),
//                   ),
//                   child: FullScreenWidget(
//                     child: Image.network(
//                       message,
//                       loadingBuilder: (BuildContext context, Widget child,
//                           ImageChunkEvent? loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.black,
//                           ),
//                         );
//                       },
//                     ),
//                   )),
//             ),
//           ),
//           Align(
//             alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//             child: Padding(
//               padding: isMe
//                   ? const EdgeInsets.only(right: 9)
//                   : const EdgeInsets.only(left: 9),
//               child: Text(
//                 DateFormat.jm().format(date),
//                 style: GoogleFonts.poppins(
//                   textStyle: const TextStyle(
//                       fontSize: 10, fontWeight: FontWeight.w400),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
