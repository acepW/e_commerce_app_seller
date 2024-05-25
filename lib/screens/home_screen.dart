import 'package:card_swiper/card_swiper.dart';
import 'package:e_commerce_app_seller/inner_screens/feeds_screen.dart';
import 'package:e_commerce_app_seller/inner_screens/on_sale_screen.dart';
import 'package:e_commerce_app_seller/screens/crud_produk/add_prod.dart';
import 'package:e_commerce_app_seller/services/global_methods.dart';
import 'package:e_commerce_app_seller/services/utils.dart';
import 'package:e_commerce_app_seller/widgets/feed_items.dart';
import 'package:e_commerce_app_seller/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../consts/contss.dart';
import '../models/products_model.dart';
import '../providers/products_provider.dart';
import '../widgets/on_sale_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    Size size = utils.getScreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.33,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    Constss.offerImages[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: Constss.offerImages.length,
                pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.white, activeColor: Colors.red)),
                //control: const SwiperControl(color: Colors.amber),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            // TextButton(
            //     onPressed: () {
            //       GlobalMethods.navigateTo(
            //           ctx: context, routeName: OnSaleScreen.routeName);
            //     },
            //     child: TextWidget(
            //       text: 'View all',
            //       maxLines: 1,
            //       color: Colors.blue,
            //       textSize: 20,
            //     )),
            // const SizedBox(
            //   height: 6,
            // ),
            // Row(
            //   children: [
            //     RotatedBox(
            //       quarterTurns: -1,
            //       child: Row(
            //         children: [
            //           TextWidget(
            //             text: 'On Sale'.toUpperCase(),
            //             color: Colors.red,
            //             textSize: 22,
            //             isTitle: true,
            //           ),
            //           const SizedBox(
            //             width: 5,
            //           ),
            //           const Icon(
            //             IconlyLight.discount,
            //             color: Colors.red,
            //           )
            //         ],
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 8,
            //     ),
            //     // Flexible(
            //     //   child: SizedBox(
            //     //     height: size.height * 0.24,
            //     //     child: ListView.builder(
            //     //       itemCount: productsOnSale.length < 10
            //     //           ? productsOnSale.length
            //     //           : 10,
            //     //       scrollDirection: Axis.horizontal,
            //     //       itemBuilder: (ctx, index) {
            //     //         return ChangeNotifierProvider.value(
            //     //             value: productsOnSale[index],
            //     //             child: const OnSaleWidget());
            //     //       },
            //     //     ),
            //     //   ),
            //     // ),
            //   ],
            // ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'My Products',
                    color: color,
                    textSize: 22,
                    isTitle: true,
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: FeedsScreen.routeName);
                      },
                      child: TextWidget(
                        text: 'Browse all',
                        maxLines: 1,
                        color: Colors.blue,
                        textSize: 20,
                      )),
                ],
              ),
            ),

            FutureBuilder(
                future: productProviders.fetchProducts(),
                builder: (context, snapshot) {
                  return GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    padding: EdgeInsets.zero,
                    //crossAxisSpacing: 10,
                    childAspectRatio: size.width / (size.height * 0.61),
                    children: List.generate(allProducts.length, (index) {
                      return ChangeNotifierProvider.value(
                        value: allProducts[index],
                        child: const FeedsWidget(),
                      );
                    }),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: IconButton(
          color: Colors.blue,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UploadProductForm()));
          },
          icon: Icon(Icons.add)),
    );
  }
}
