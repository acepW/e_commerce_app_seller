import 'package:e_commerce_app_seller/login_screens.dart';
import 'package:e_commerce_app_seller/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_commerce_app_seller/consts/theme_data.dart';
import 'package:e_commerce_app_seller/fetch_screen.dart';
import 'package:e_commerce_app_seller/inner_screens/cat_screen.dart';
import 'package:e_commerce_app_seller/inner_screens/feeds_screen.dart';
import 'package:e_commerce_app_seller/inner_screens/on_sale_screen.dart';
import 'package:e_commerce_app_seller/providers/dark_theme_provider.dart';
import 'package:e_commerce_app_seller/providers/cart_provider.dart';
import 'package:e_commerce_app_seller/providers/orders_provider.dart';
import 'package:e_commerce_app_seller/providers/products_provider.dart';
import 'package:e_commerce_app_seller/providers/viewed_prod_provider.dart';
import 'package:e_commerce_app_seller/providers/wishlist_provider.dart';
import 'package:e_commerce_app_seller/screens/auth/forget_pass.dart';
import 'package:e_commerce_app_seller/screens/auth/login.dart';
import 'package:e_commerce_app_seller/screens/auth/register.dart';
import 'package:e_commerce_app_seller/screens/btm_bar.dart';
import 'package:e_commerce_app_seller/screens/categories.dart';
import 'package:e_commerce_app_seller/screens/home_screen.dart';
import 'package:e_commerce_app_seller/screens/orders/orders_screen.dart';
import 'package:e_commerce_app_seller/screens/viewed_recently/viewed_recently.dart';
import 'package:e_commerce_app_seller/screens/wishlist/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inner_screens/product_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('An error occured'),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(
                create: (_) => ProductsProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WishlistProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ViewedProdProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => OrdersProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => UserProvider(),
              ),
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      // Checking if the snapshot has any data or not
                      if (snapshot.hasData) {
                        // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                        return const FetchScreen();
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('${snapshot.error}'),
                        );
                      }
                    }

                    // means connection to future hasnt been made yet
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return const LoginScreens();
                  },
                ),
                routes: {
                  OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                  FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                  ProductDetails.routeName: (ctx) => const ProductDetails(),
                  WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                  OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                  ViewedRecentlyScreen.routeName: (ctx) =>
                      const ViewedRecentlyScreen(),
                  RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                  LoginScreen.routeName: (ctx) => const LoginScreen(),
                  ForgetPasswordScreen.routeName: (ctx) =>
                      const ForgetPasswordScreen(),
                  CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                },
              );
            }),
          );
        });
  }
}
