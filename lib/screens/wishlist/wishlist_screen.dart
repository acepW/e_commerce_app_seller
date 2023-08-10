import 'package:e_commerce_app_seller/screens/cart/cart_widget.dart';
import 'package:e_commerce_app_seller/screens/wishlist/wishlist_widget.dart';
import 'package:e_commerce_app_seller/widgets/back_widget.dart';
import 'package:e_commerce_app_seller/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/empty_screen.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = "/WishlistScreen";
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemList =
        wishlistProvider.getWishlistItems.values.toList().reversed.toList();
    return wishlistItemList.isEmpty
        ? const EmptyScreen(
            title: 'Your Wishlist is empty',
            subtitle: 'Explore more and shortlist some items',
            imagePath: 'assets/images/wishlist.png',
          )
        : Scaffold(
            appBar: AppBar(
                leading: const BackWidget(),
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: TextWidget(
                  text: 'Wishlist (${wishlistItemList.length})',
                  color: color,
                  textSize: 22,
                  isTitle: true,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Empty your Wishlist',
                          subtitle: 'Are you sure?',
                          fct: () async {
                            await wishlistProvider.clearOnlineWishlist();
                            wishlistProvider.clearWishlist();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ),
                  ),
                ]),
            body: MasonryGridView.count(
              itemCount: wishlistItemList.length,
              crossAxisCount: 2,
              /* mainAxisSpacing: 16,
        crossAxisSpacing: 20, */
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                    value: wishlistItemList[index],
                    child: const WishlistWidget());
              },
            ),
          );
  }
}
