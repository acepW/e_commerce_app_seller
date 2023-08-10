// for picking up image from gallery

import 'package:flutter/material.dart';

// pickImage(ImageSource source) async {
//   final ImagePicker _imagePicker = ImagePicker();
//   XFile? file = await _imagePicker.pickImage(source: source);
//   if (file != null) {
//     return await file.readAsBytes();
//   }
//   print('No Image Selected');
// }

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.purple,
      content: Text(text),
    ),
  );
}
