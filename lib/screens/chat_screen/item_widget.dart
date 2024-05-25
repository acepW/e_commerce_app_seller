import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_seller/screens/crud_produk/edit_harga.dart';
import 'package:e_commerce_app_seller/services/global_methods.dart';
import 'package:e_commerce_app_seller/services/utils.dart';
import 'package:e_commerce_app_seller/widgets/price_widget.dart';
import 'package:e_commerce_app_seller/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class ItemProductNego extends StatefulWidget {
  final String imageUrl;
  final int salePrice;
  final String title;
  final int price;
  final bool isOnSale;
  final String uid;
  final String productId;
  final String customerId;
  final String sellerName;
  final String totalPrice;
  final String displayName;
  const ItemProductNego(
      {super.key,
      required this.imageUrl,
      required this.salePrice,
      required this.title,
      required this.price,
      required this.isOnSale,
      required this.uid,
      required this.productId,
      required this.customerId,
      required this.sellerName,
      required this.totalPrice,
      required this.displayName});

  @override
  State<ItemProductNego> createState() => _ItemProductNegoState();
}

class _ItemProductNegoState extends State<ItemProductNego> {
  late int _salePriceController;

  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _salePriceController = widget.salePrice;
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: Column(children: [
          Image.network(
            widget.imageUrl,
            height: size.width * 0.21,
            width: size.width * 0.2,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: TextWidget(
                    text: widget.title,
                    color: color,
                    maxLines: 1,
                    textSize: 18,
                    isTitle: true,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 4,
                  child: PriceWidget(
                    salePrice: widget.salePrice,
                    price: widget.price,
                    textPrice: _quantityTextController.text,
                    isOnSale: widget.isOnSale,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                          flex: 2,
                          // TextField can be used also instead of the textFormField
                          child: TextFormField(
                            controller: _quantityTextController,
                            key: const ValueKey('10'),
                            style: TextStyle(color: color, fontSize: 18),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            enabled: true,
                            onChanged: (valueee) {
                              setState(() {
                                if (valueee.isEmpty) {
                                  _quantityTextController.text = '1';
                                } else {}
                              });
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp('[0-9.]'),
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProductNegoScreen(
                            id: widget.productId,
                            price: widget.price.toString(),
                            userId: widget.uid,
                            sellerId: widget.customerId)));
              },
              child: TextWidget(text: "Edit Harga", color: color, textSize: 20),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).cardColor),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      ),
                    ),
                  )),
            ),
          )
          // SizedBox(
          //   width: double.infinity,
          //   child: TextButton(
          //     onPressed: _isInCart
          //         ? null
          //         : () async {
          //             // if (_isInCart) {
          //             //   return ;
          //             // }
          //             final User? user = authInstance.currentUser;
          //             if (user == null) {
          //               GlobalMethods.errorDialog(
          //                   subtitle: 'No user found, Please login first',
          //                   context: context);
          //               return;
          //             }
          //             await GlobalMethods.addToCart(
          //               productId: productModel.id,
          //               quantity: int.parse(_quantityTextController.text),
          //               context: context,
          //             );
          //             await cartProvider.fetchCart();
          //             // cartProvider.addProductsToCart(
          //             //     productId: productModel.id,
          //             //     quantity: int.parse(
          //             //       _quantityTextController.text,
          //             //     ));
          //           },
          //     child: productModel.stock == true
          //         ? TextWidget(
          //             text: _isInCart ? 'In Cart' : 'Add to cart',
          //             maxLines: 1,
          //             color: color,
          //             textSize: 20,
          //           )
          //         : TextWidget(
          //             text: 'Stock Habis',
          //             maxLines: 1,
          //             color: color,
          //             textSize: 20,
          //           ),
          //     style: ButtonStyle(
          //         backgroundColor:
          //             MaterialStateProperty.all(Theme.of(context).cardColor),
          //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //           const RoundedRectangleBorder(
          //             borderRadius: BorderRadius.only(
          //               bottomLeft: Radius.circular(12.0),
          //               bottomRight: Radius.circular(12.0),
          //             ),
          //           ),
          //         )),
          //   ),
          // )
        ]),
      ),
    );
  }
}
