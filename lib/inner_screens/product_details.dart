import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_seller/models/user_model.dart';
import 'package:e_commerce_app_seller/screens/chat_screen/halaman_chat.dart';
import 'package:e_commerce_app_seller/services/firebase_const.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce_app_seller/providers/products_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../models/products_model.dart';
import '../providers/cart_provider.dart';
import '../providers/viewed_prod_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/heart_btn.dart';
import '../widgets/text_widget.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productProviders = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProviders.findProdById(productId);

    int usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    int totalPrice = usedPrice * int.parse(_quantityTextController.text);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        viewedProdProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            leading: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () =>
                  Navigator.canPop(context) ? Navigator.pop(context) : null,
              child: Icon(
                IconlyLight.arrowLeft2,
                color: color,
                size: 24,
              ),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        body: Column(children: [
          Flexible(
            flex: 2,
            child: FancyShimmerImage(
              imageUrl: getCurrentProduct.imageUrl,
              boxFit: BoxFit.scaleDown,
              width: size.width,
              // height: screenHeight * .4,
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: getCurrentProduct.title,
                            color: color,
                            textSize: 25,
                            isTitle: true,
                          ),
                        ),
                        HeartBTN(
                          productId: getCurrentProduct.id,
                          isInWishlist: _isInWishlist,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: 'Rp',
                          color: Colors.green,
                          textSize: 22,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: usedPrice.toStringAsFixed(2),
                          color: Colors.green,
                          textSize: 22,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: '/Pcs',
                          color: color,
                          textSize: 12,
                          isTitle: false,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: getCurrentProduct.isOnSale ? true : false,
                          child: Text(
                            getCurrentProduct.price.toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 15,
                                color: color,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(63, 200, 101, 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextWidget(
                            text: 'Free delivery',
                            color: Colors.white,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextWidget(
                            text: "Penjual : ${getCurrentProduct.sellerName}",
                            color: color,
                            textSize: 22),
                        InkWell(
                          onTap: () async {
                            User? user = FirebaseAuth.instance.currentUser;

                            DocumentSnapshot userData = await FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(user!.uid)
                                .get();
                            UserModel userModel = UserModel.fromSnap(userData);
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userModel.id)
                                  .collection('messages')
                                  .doc(getCurrentProduct.sellerId)
                                  .collection('nego')
                                  .add({
                                'id': getCurrentProduct.id,
                                'title': getCurrentProduct.title,
                                'price': getCurrentProduct.price,
                                'sellerId': getCurrentProduct.sellerId,
                                'sellerName': getCurrentProduct.sellerName,
                                'deskripsi': getCurrentProduct.deskripsi,
                                'salePrice': getCurrentProduct.salePrice,
                                'imageUrl': getCurrentProduct.imageUrl,
                                'productCategoryName':
                                    getCurrentProduct.productCategoryName,
                                'isOnSale': getCurrentProduct.isOnSale,
                                'isPiece': getCurrentProduct.isPiece,
                                'createdAt': Timestamp.now(),
                                'stock': getCurrentProduct.stock,
                              }).then((value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userModel.id)
                                    .collection('messages')
                                    .doc(getCurrentProduct.sellerId)
                                    .set({
                                  'id': getCurrentProduct.id,
                                  'title': getCurrentProduct.title,
                                  'price': getCurrentProduct.price,
                                  'sellerId': getCurrentProduct.sellerId,
                                  'sellerName': getCurrentProduct.sellerName,
                                  'deskripsi': getCurrentProduct.deskripsi,
                                  'salePrice': getCurrentProduct.salePrice,
                                  'imageUrl': getCurrentProduct.imageUrl,
                                  'productCategoryName':
                                      getCurrentProduct.productCategoryName,
                                  'isOnSale': getCurrentProduct.isOnSale,
                                  'isPiece': getCurrentProduct.isPiece,
                                  'createdAt': Timestamp.now(),
                                  'stock': getCurrentProduct.stock,
                                });
                              });

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(getCurrentProduct.sellerId)
                                  .collection('messages')
                                  .doc(userModel.id)
                                  .collection("nego")
                                  .add({
                                'id': getCurrentProduct.id,
                                'title': getCurrentProduct.title,
                                'price': getCurrentProduct.price,
                                'sellerId': getCurrentProduct.sellerId,
                                'sellerName': getCurrentProduct.sellerName,
                                'deskripsi': getCurrentProduct.deskripsi,
                                'salePrice': getCurrentProduct.salePrice,
                                'imageUrl': getCurrentProduct.imageUrl,
                                'productCategoryName':
                                    getCurrentProduct.productCategoryName,
                                'isOnSale': getCurrentProduct.isOnSale,
                                'isPiece': getCurrentProduct.isPiece,
                                'createdAt': Timestamp.now(),
                                'stock': getCurrentProduct.stock,
                              }).then((value) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(getCurrentProduct.sellerId)
                                    .collection('messages')
                                    .doc(userModel.id)
                                    .set({
                                  'id': getCurrentProduct.id,
                                  'title': getCurrentProduct.title,
                                  'price': getCurrentProduct.price,
                                  'sellerId': getCurrentProduct.sellerId,
                                  'sellerName': getCurrentProduct.sellerName,
                                  'deskripsi': getCurrentProduct.deskripsi,
                                  'salePrice': getCurrentProduct.salePrice,
                                  'imageUrl': getCurrentProduct.imageUrl,
                                  'productCategoryName':
                                      getCurrentProduct.productCategoryName,
                                  'isOnSale': getCurrentProduct.isOnSale,
                                  'isPiece': getCurrentProduct.isPiece,
                                  'createdAt': Timestamp.now(),
                                  'stock': getCurrentProduct.stock,
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

                            } on FirebaseException catch (error) {
                              GlobalMethods.errorDialog(
                                  subtitle: '${error.message}',
                                  context: context);
                            } catch (error) {
                              GlobalMethods.errorDialog(
                                  subtitle: '$error', context: context);
                            }

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HalamanChat(
                                        currentUser: userModel.id,
                                        friendId: getCurrentProduct.sellerId,
                                        friendName:
                                            getCurrentProduct.sellerName,
                                        myName: userModel.name)));
                          },
                          child: Container(
                            child: Row(
                              children: [
                                TextWidget(
                                    text: "Nego", color: color, textSize: 22),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(IconlyLight.message)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  TextWidget(
                      text: getCurrentProduct.deskripsi,
                      color: color,
                      textSize: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      quantityControl(
                        fct: () {
                          if (_quantityTextController.text == '1') {
                            return;
                          } else {
                            setState(() {
                              _quantityTextController.text =
                                  (int.parse(_quantityTextController.text) - 1)
                                      .toString();
                            });
                          }
                        },
                        icon: CupertinoIcons.minus,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: _quantityTextController,
                          key: const ValueKey('quantity'),
                          keyboardType: TextInputType.number,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                          textAlign: TextAlign.center,
                          cursorColor: Colors.green,
                          enabled: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                _quantityTextController.text = '1';
                              } else {}
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      quantityControl(
                        fct: () {
                          setState(() {
                            _quantityTextController.text =
                                (int.parse(_quantityTextController.text) + 1)
                                    .toString();
                          });
                        },
                        icon: CupertinoIcons.plus,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'Total',
                                color: Colors.red.shade300,
                                textSize: 20,
                                isTitle: true,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    TextWidget(
                                      text: 'Rp',
                                      color: color,
                                      textSize: 20,
                                      isTitle: true,
                                    ),
                                    TextWidget(
                                      text: '${totalPrice.toStringAsFixed(2)}/',
                                      color: color,
                                      textSize: 20,
                                      isTitle: true,
                                    ),
                                    TextWidget(
                                      text:
                                          '${_quantityTextController.text}Pcs',
                                      color: color,
                                      textSize: 16,
                                      isTitle: false,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Material(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: _isInCart
                                  ? null
                                  : () async {
                                      // if (_isInCart) {
                                      //   return ;
                                      // }
                                      var authInstance;
                                      final User? user =
                                          authInstance.currentUser;
                                      if (user == null) {
                                        GlobalMethods.errorDialog(
                                            subtitle:
                                                'No user found, Please login first',
                                            context: context);
                                        return;
                                      }
                                      await GlobalMethods.addToCart(
                                        productId: getCurrentProduct.id,
                                        quantity: int.parse(
                                            _quantityTextController.text),
                                        context: context,
                                      );
                                      await cartProvider.fetchCart();
                                      // cartProvider.addProductsToCart(
                                      //     productId: getCurrentProduct.id,
                                      //     quantity: int.parse(
                                      //       _quantityTextController.text,
                                      //     ));
                                    },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: TextWidget(
                                      text:
                                          _isInCart ? 'In Cart' : 'Add to cart',
                                      color: Colors.white,
                                      textSize: 18)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
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
}
