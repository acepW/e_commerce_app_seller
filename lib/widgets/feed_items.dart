import 'package:e_commerce_app_seller/screens/crud_produk/edit_prod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce_app_seller/providers/cart_provider.dart';
import 'package:e_commerce_app_seller/services/global_methods.dart';
import 'package:e_commerce_app_seller/widgets/price_widget.dart';
import 'package:e_commerce_app_seller/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_consts.dart';
import '../inner_screens/product_details.dart';
import '../models/products_model.dart';
import '../providers/products_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/utils.dart';
import 'heart_btn.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({Key? key}) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
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
    Size size = Utils(context).getScreenSize;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProductScreen(
                        id: productModel.id,
                        title: productModel.title,
                        price: productModel.price.toString(),
                        salePrice: productModel.salePrice.toString(),
                        productCat: productModel.productCategoryName,
                        imageUrl: productModel.imageUrl,
                        isOnSale: productModel.isOnSale,
                        isPiece: productModel.isPiece,
                        stock: productModel.stock,
                        deskripsi: productModel.deskripsi)));

            /* GlobalMethods.navigateTo(
                ctx: context, routeName: ProductDetails.routeName); */
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(children: [
            Image.network(
              productModel.imageUrl,
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
                      text: productModel.title,
                      color: color,
                      maxLines: 1,
                      textSize: 18,
                      isTitle: true,
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: HeartBTN(
                        productId: productModel.id,
                        isInWishlist: _isInWishlist,
                      )),
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
                      salePrice: productModel.salePrice,
                      price: productModel.price,
                      textPrice: _quantityTextController.text,
                      isOnSale: productModel.isOnSale,
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
      ),
    );
  }
}
