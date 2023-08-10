// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:e_commerce_app_seller/models/user_model.dart';
import 'package:e_commerce_app_seller/screens/crud_produk/MenuController.dart';
import 'package:e_commerce_app_seller/screens/crud_produk/buttons.dart';
import 'package:e_commerce_app_seller/screens/loading_manager.dart';
import 'package:e_commerce_app_seller/services/utils.dart';
import 'package:e_commerce_app_seller/storage_method.dart';
import 'package:e_commerce_app_seller/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../services/global_methods.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const UploadProductForm({Key? key}) : super(key: key);

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _catValue = 'Elektronik';
  late final TextEditingController _titleController,
      _priceController,
      _deskripsiController;
  int _groupValue = 1;
  bool isPiece = true;
  Uint8List? _pickedImage;
  String? imageUrl;
  Uint8List webImage = Uint8List(8);
  @override
  void initState() {
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    _deskripsiController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      if (_pickedImage == null) {
        GlobalMethods.errorDialog(
            subtitle: 'Please pick up an image', context: context);
        return;
      }
      final _uuid = const Uuid().v4();
      User? user = FirebaseAuth.instance.currentUser;

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      UserModel userModel = UserModel.fromSnap(userData);
      try {
        setState(() {
          _isLoading = true;
        });
        if (_pickedImage == null) {
          imageUrl = '';
        } else {
          imageUrl = await StorageMethods()
              .uploadImageProdukToStorage("productsImages", _pickedImage!);
        }

        await FirebaseFirestore.instance.collection('products').doc(_uuid).set({
          'id': _uuid,
          'sellerId': userModel.id,
          'title': _titleController.text,
          'deskripsi': _deskripsiController.text,
          'sellerName': userModel.name,
          'alamatSeller': userModel.alamat,
          'price': _priceController.text,
          'salePrice': _priceController.text,
          'imageUrl': imageUrl,
          'productCategoryName': _catValue,
          'isOnSale': false,
          'isPiece': isPiece,
          'createdAt': Timestamp.now(),
          'stock': true,
        });
        _clearForm();
        Fluttertoast.showToast(
          msg: "Product uploaded succefully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          // backgroundColor: ,
          // textColor: ,
          // fontSize: 16.0
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

  void _clearForm() {
    isPiece = true;
    _groupValue = 1;
    _priceController.clear();
    _titleController.clear();
    _deskripsiController.clear();
    setState(() {
      _pickedImage = null;
      webImage = Uint8List(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;
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
      // appBar: AppBar(
      //   actions: [
      //     TextButton(
      //         onPressed: () {
      //           context.read<MenuController>().controlAddProductsMenu();
      //         },
      //         child: Text("Tambah"))
      //   ],
      // ),
      body: SingleChildScrollView(
        child: LoadingManager(
          isLoading: _isLoading,
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
                    text: 'Product Deskripsi*',
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
                    minLines: 1,
                    maxLines: 25,
                    decoration: inputDecoration,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Price in RP*',
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
                      key: const ValueKey('Price \$'),
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
                  // Drop down menu code here
                  _categoryDropDown(),

                  const SizedBox(
                    height: 20,
                  ),

                  // Image to be picked code is here
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: size.width > 650 ? 350 : size.width * 0.45,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: _pickedImage == null
                          ? dottedBorder(color: color)
                          : Container(
                              height: 200,
                              width: 270,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: MemoryImage(_pickedImage!),
                                  )),
                            ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _pickedImage = null;
                        webImage = Uint8List(8);
                      });
                    },
                    child: TextWidget(
                      text: 'Clear',
                      color: Colors.red,
                      textSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: TextWidget(
                      text: 'Update image',
                      color: Colors.blue,
                      textSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonsWidget(
                          onPressed: _clearForm,
                          text: 'Clear form',
                          icon: Icons.dangerous,
                          backgroundColor: Colors.red.shade300,
                        ),
                        ButtonsWidget(
                          onPressed: () {
                            _uploadForm();
                          },
                          text: 'Upload',
                          icon: Icons.upload,
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
    );
  }

  // Future<void> _pickImage() async {
  //   if (!kIsWeb) {
  //     final ImagePicker _picker = ImagePicker();
  //     XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //     if (image != null) {
  //       var selected = File(image.path);
  //       setState(() {
  //         _pickedImage = selected;
  //       });
  //     } else {
  //       print('No image has been picked');
  //     }
  //   } else if (kIsWeb) {
  //     final ImagePicker _picker = ImagePicker();
  //     XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //     if (image != null) {
  //       var f = await image.readAsBytes();
  //       setState(() {
  //         webImage = f;
  //         _pickedImage = File('a');
  //       });
  //     } else {
  //       print('No image has been picked');
  //     }
  //   } else {
  //     print('Something went wrong');
  //   }
  // }

  Widget dottedBorder({
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
          dashPattern: const [6.7],
          borderType: BorderType.RRect,
          color: color,
          radius: const Radius.circular(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: color,
                  size: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: (() async {
                      try {
                        Uint8List file = await pickImage(ImageSource.gallery);
                        if (file != null) {
                          setState(() {
                            _pickedImage = file;
                          });
                        }
                      } catch (e) {
                        print(e);
                      }
                    }),
                    child: TextWidget(
                      text: 'Choose an image',
                      color: Colors.blue,
                      textSize: 20,
                    ))
              ],
            ),
          )),
    );
  }

  Widget _categoryDropDown() {
    final color = Utils(context).color;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          value: _catValue,
          onChanged: (value) {
            setState(() {
              _catValue = value!;
            });
            print(_catValue);
          },
          hint: const Text('Select a category'),
          items: const [
            DropdownMenuItem(
              child: Text(
                'Elektronik',
              ),
              value: 'Elektronik',
            ),
            DropdownMenuItem(
              child: Text(
                'Sparepart',
              ),
              value: 'Sparepart',
            ),
            DropdownMenuItem(
              child: Text(
                'House',
              ),
              value: 'House',
            ),
            DropdownMenuItem(
              child: Text(
                'Clothes',
              ),
              value: 'Clothes',
            ),
            DropdownMenuItem(
              child: Text(
                'Kitchen',
              ),
              value: 'Kitchen',
            ),
            DropdownMenuItem(
              child: Text(
                'Others',
              ),
              value: 'Others',
            )
          ],
        )),
      ),
    );
  }
}
