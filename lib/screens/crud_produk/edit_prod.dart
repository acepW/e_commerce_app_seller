// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_seller/screens/crud_produk/buttons.dart';
import 'package:e_commerce_app_seller/screens/loading_manager.dart';
import 'package:e_commerce_app_seller/services/global_methods.dart';
import 'package:e_commerce_app_seller/services/utils.dart';
import 'package:e_commerce_app_seller/storage_method.dart';
import 'package:e_commerce_app_seller/widgets/text_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen(
      {Key? key,
      required this.id,
      required this.title,
      required this.price,
      required this.salePrice,
      required this.productCat,
      required this.imageUrl,
      required this.isOnSale,
      required this.isPiece,
      required this.stock,
      required this.deskripsi})
      : super(key: key);

  final String id, title, price, productCat, imageUrl, deskripsi;
  final bool isPiece, isOnSale, stock;
  final String salePrice;
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  // Title and price controllers
  late final TextEditingController _titleController,
      _priceController,
      _deskripsiController;
  // Category
  late String _catValue;
  late String _stockValue;
  // Sale
  String? _salePercent;
  late String percToShow;
  late String _salePrice;
  late bool _isOnSale;
  late bool _stock;
  // Image
  Uint8List? _pickedImage;
  Uint8List webImage = Uint8List(10);
  late String _imageUrl;
  // kg or Piece,
  late int val;
  late bool _isPiece;
  // while loading
  bool _isLoading = false;
  @override
  void initState() {
    // set the price and title initial values and initialize the controllers
    _priceController = TextEditingController(text: widget.price);
    _titleController = TextEditingController(text: widget.title);
    _deskripsiController = TextEditingController(text: widget.deskripsi);
    // Set the variables
    _salePrice = widget.salePrice;
    _catValue = widget.productCat;
    _isOnSale = widget.isOnSale;
    _isPiece = widget.isPiece;
    _stock = widget.stock;
    val = _isPiece ? 1 : 1;
    _imageUrl = widget.imageUrl;
    // Calculate the percentage
    // percToShow = (100 -
    //             (_salePrice * 100) /
    //                 int.parse(
    //                     widget.price)) // WIll be the price instead of 1.88
    //         .round()
    //         .toStringAsFixed(1) +
    //     '%';
    // super.initState();
  }

  @override
  void dispose() {
    // Dispose the controllers
    _priceController.dispose();
    _titleController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _updateProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        String? imageUri;
        setState(() {
          _isLoading = true;
        });
        if (_pickedImage == null) {
          imageUri = _imageUrl;
        } else {
          imageUri = await StorageMethods()
              .uploadImageProdukToStorage("productsImages", _pickedImage!);
        }
        await FirebaseFirestore.instance
            .collection('products')
            .doc(widget.id)
            .update({
          'title': _titleController.text,
          'deskripsi': _deskripsiController.text,
          'price': _priceController.text,
          'salePrice': _priceController.text,
          'imageUrl': imageUri,
          'productCategoryName': _catValue,
          'isOnSale': _isOnSale,
          'isPiece': _isPiece,
          'stock': _stock,
        });
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
            child: Container(
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
                    TextWidget(
                      text: 'Product title*',
                      color: color,
                      isTitle: true,
                      textSize: 15,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _titleController,
                      key: const ValueKey('Title'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Title';
                        }
                        return null;
                      },
                      decoration: inputDecoration,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextWidget(
                      text: 'Product deskripsi*',
                      color: color,
                      isTitle: true,
                      textSize: 15,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _deskripsiController,
                      key: const ValueKey('deskripsi'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a Title';
                        }
                        return null;
                      },
                      maxLines: 25,
                      minLines: 1,
                      decoration: inputDecoration,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        decoration: inputDecoration,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextWidget(
                      text: 'Porduct category*',
                      color: color,
                      isTitle: true,
                      textSize: 15,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      color: _scaffoldColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: catDropDownWidget(color),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextWidget(
                      text: 'Measure unit*',
                      color: color,
                      isTitle: true,
                      textSize: 15,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   mainAxisAlignment:
                    //       MainAxisAlignment.start,
                    //   children: [
                    //     TextWidget(text: 'Pcs', color: color),
                    //     Radio(
                    //       value: 1,
                    //       groupValue: val,
                    //       onChanged: (value) {
                    //         setState(() {
                    //           val = 1;
                    //           _isPiece = true;
                    //         });
                    //       },
                    //       activeColor: Colors.green,
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Checkbox(
                            value: _stock,
                            onChanged: (newValuee) {
                              setState(() {
                                _stock = newValuee!;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          TextWidget(
                            text: 'Stock',
                            color: color,
                            isTitle: true,
                            textSize: 15,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Checkbox(
                            value: _isOnSale,
                            onChanged: (newValue) {
                              setState(() {
                                _isOnSale = newValue!;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          TextWidget(
                            text: 'Sale',
                            color: color,
                            isTitle: true,
                            textSize: 15,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: size.width > 650 ? 350 : size.width * 0.45,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          child: _pickedImage == null
                              ? Image.network(
                                  _imageUrl,
                                  fit: BoxFit.fill,
                                )
                              : Container(
                                  height: 200,
                                  width: 500,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: MemoryImage(_pickedImage!),
                                      )),
                                ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        FittedBox(
                          child: TextButton(
                            onPressed: () async {
                              try {
                                Uint8List file =
                                    await pickImage(ImageSource.gallery);
                                if (file != null) {
                                  setState(() {
                                    _pickedImage = file;
                                  });
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: TextWidget(
                              text: 'Update image',
                              color: Colors.blue,
                              textSize: 15,
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
                            onPressed: () async {
                              GlobalMethods.warningDialog(
                                  title: 'Delete?',
                                  subtitle: 'Press okay to confirm',
                                  fct: () async {
                                    await FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(widget.id)
                                        .delete();
                                    await Fluttertoast.showToast(
                                      msg: "Product has been deleted",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                    );
                                    while (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  context: context);
                            },
                            text: 'Delete',
                            icon: Icons.dangerous,
                            backgroundColor: Colors.red.shade700,
                          ),
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

  DropdownButtonHideUnderline stockCheck(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        items: const [
          DropdownMenuItem<String>(
            child: Text('Kosong'),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _stockValue = value!;
          });
        },
      ),
    );
  }

  DropdownButtonHideUnderline catDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: TextStyle(color: color),
        items: const [
          DropdownMenuItem<String>(
            child: Text('Elektronik'),
            value: 'Elektronik',
          ),
          DropdownMenuItem<String>(
            child: Text('Sparepart'),
            value: 'Sparepart',
          ),
          DropdownMenuItem<String>(
            child: Text('House'),
            value: 'House',
          ),
          DropdownMenuItem<String>(
            child: Text('Clothes'),
            value: 'Clothes',
          ),
          DropdownMenuItem<String>(
            child: Text('Kitchen'),
            value: 'Kitchen',
          ),
          DropdownMenuItem<String>(
            child: Text('Others'),
            value: 'Others',
          ),
        ],
        onChanged: (value) {
          setState(() {
            _catValue = value!;
          });
        },
        hint: const Text('Select a Category'),
        value: _catValue,
      ),
    );
  }

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
