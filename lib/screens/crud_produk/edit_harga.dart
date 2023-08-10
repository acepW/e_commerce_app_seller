// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_seller/screens/crud_produk/buttons.dart';
import 'package:e_commerce_app_seller/screens/loading_manager.dart';
import 'package:e_commerce_app_seller/services/global_methods.dart';
import 'package:e_commerce_app_seller/services/utils.dart';
import 'package:e_commerce_app_seller/widgets/text_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProductNegoScreen extends StatefulWidget {
  const EditProductNegoScreen({
    Key? key,
    required this.id,
    required this.price,
    required this.userId,
    required this.sellerId,
  }) : super(key: key);

  final String id, userId, sellerId;

  final String price;
  @override
  _EditProductNegoScreenState createState() => _EditProductNegoScreenState();
}

class _EditProductNegoScreenState extends State<EditProductNegoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _priceController;

  bool _isLoading = false;
  @override
  void initState() {
    // set the price and title initial values and initialize the controllers
    _priceController = TextEditingController(text: widget.price);
    // Set the variables
  }

  void _updateProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        Uri? imageUri;
        setState(() {
          _isLoading = true;
        });

        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .collection('messages')
              .doc(widget.sellerId)
              .update({"price": _priceController});

          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.sellerId)
              .collection('messages')
              .doc(widget.userId)
              .update({"price": _priceController});
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              subtitle: '${error.message}', context: context);
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '$error', context: context);
        } finally {}

        await Fluttertoast.showToast(
          msg: "Product has been updated",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
      // key: context.read<MenuController>().getEditProductscaffoldKey,
      // drawer: const SideMenu(),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // Header(
                //   showTexField: false,
                //   fct: () {
                //     context
                //         .read<MenuController>()
                //         .controlEditProductsMenu();
                //   },
                //   title: 'Edit this product',
                // ),
                Container(
                  width: size.width,
                  color: Theme.of(context).cardColor,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: FittedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: 'Price in Rp*',
                                      color: color,
                                      isTitle: true,
                                      textSize: 15,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: TextFormField(
                                        controller: _priceController,
                                        key: const ValueKey('Price Rp'),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Price is missed';
                                          }
                                          return null;
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[0-9.]')),
                                        ],
                                        decoration: inputDecoration,
                                      ),
                                    ),

                                    // AnimatedSwitcher(
                                    //   duration: const Duration(seconds: 1),
                                    //   child: !_isOnSale
                                    //       ? Container()
                                    //       : Row(
                                    //           children: [
                                    //             TextWidget(
                                    //                 text: "Rp" +
                                    //                     _salePrice
                                    //                         .toStringAsFixed(2),
                                    //                 color: color,
                                    //                 textSize: 15),
                                    //             const SizedBox(
                                    //               width: 10,
                                    //             ),
                                    //             salePourcentageDropDownWidget(
                                    //                 color),
                                    //           ],
                                    //         ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ButtonsWidget(
                                onPressed: () {
                                  _updateProduct();
                                },
                                text: 'Update',
                                icon: Icons.update,
                                backgroundColor: Colors.blue,
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
      ),
    );
  }

  // DropdownButtonHideUnderline salePourcentageDropDownWidget(Color color) {
  //   return DropdownButtonHideUnderline(
  //     child: DropdownButton<String>(
  //       style: TextStyle(color: color),
  //       items: const [
  //         DropdownMenuItem<String>(
  //           child: Text('10%'),
  //           value: '10',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('15%'),
  //           value: '15',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('25%'),
  //           value: '25',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('50%'),
  //           value: '50',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('75%'),
  //           value: '75',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('0%'),
  //           value: '0',
  //         ),
  //       ],
  //       onChanged: (value) {
  //         if (value == '0') {
  //           return;
  //         } else {
  //           setState(() {
  //             _salePercent = value;
  //             _salePrice = double.parse(widget.price) -
  //                 (double.parse(value!) * double.parse(widget.price) / 100);
  //           });
  //         }
  //       },
  //       hint: Text(_salePercent ?? percToShow),
  //       value: _salePercent,
  //     ),
  //   );
  // }

  // DropdownButtonHideUnderline stockCheck(Color color) {
  //   return DropdownButtonHideUnderline(
  //     child: DropdownButton<String>(
  //       items: const [
  //         DropdownMenuItem<String>(
  //           child: Text('Kosong'),
  //         ),
  //       ],
  //       onChanged: (value) {
  //         setState(() {
  //           _stockValue = value!;
  //         });
  //       },
  //     ),
  //   );
  // }

  // DropdownButtonHideUnderline catDropDownWidget(Color color) {
  //   return DropdownButtonHideUnderline(
  //     child: DropdownButton<String>(
  //       style: TextStyle(color: color),
  //       items: const [
  //         DropdownMenuItem<String>(
  //           child: Text('Coffee'),
  //           value: 'Coffee',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('Main Course'),
  //           value: 'Main Course',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('Powder Drink'),
  //           value: 'Powder Drink',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('Fresh Drink'),
  //           value: 'Fresh Drink',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('Snack'),
  //           value: 'Snack',
  //         ),
  //         DropdownMenuItem<String>(
  //           child: Text('Others'),
  //           value: 'Others',
  //         ),
  //       ],
  //       onChanged: (value) {
  //         setState(() {
  //           _catValue = value!;
  //         });
  //       },
  //       hint: const Text('Select a Category'),
  //       value: _catValue,
  //     ),
  //   );
  // }

  // Future<void> _pickImage() async {
  //   // MOBILE
  //   if (!kIsWeb) {
  //     final ImagePicker _picker = ImagePicker();
  //     XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  //     if (image != null) {
  //       var selected = File(image.path);

  //       setState(() {
  //         _pickedImage = selected;
  //       });
  //     } else {
  //       log('No file selected');
  //       // showToast("No file selected");
  //     }
  //   }
  //   // WEB
  //   else if (kIsWeb) {
  //     final ImagePicker _picker = ImagePicker();
  //     XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //     if (image != null) {
  //       var f = await image.readAsBytes();
  //       setState(() {
  //         _pickedImage = File("a");
  //         webImage = f;
  //       });
  //     } else {
  //       log('No file selected');
  //     }
  //   } else {
  //     log('Perm not granted');
  //   }
  // }
}
