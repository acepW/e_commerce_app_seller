// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_seller/login_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce_app_seller/consts/firebase_consts.dart';
import 'package:e_commerce_app_seller/screens/auth/forget_pass.dart';

import 'package:e_commerce_app_seller/screens/loading_manager.dart';
import 'package:e_commerce_app_seller/screens/orders/orders_screen.dart';
import 'package:e_commerce_app_seller/screens/viewed_recently/viewed_recently.dart';
import 'package:e_commerce_app_seller/screens/wishlist/wishlist_screen.dart';
import 'package:e_commerce_app_seller/services/global_methods.dart';
import 'package:e_commerce_app_seller/widgets/text_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");
  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  String? _email;
  String? _name;
  String? address;
  num? _saldo = 0;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('alamat');
        _addressTextController.text = userDoc.get('alamat');
        _saldo = userDoc.get('saldo');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Hi,  ',
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: _name == null ? 'user' : _name,
                            style: TextStyle(
                              color: color,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Tombol diklik');
                              })
                      ]),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextWidget(
                  text: _email == null ? 'Email' : _email!,
                  color: color,
                  textSize: 18,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextWidget(
                  text: "Saldo : Rp." + _saldo!.toStringAsFixed(2),
                  color: color,
                  textSize: 18,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                _listTiles(
                    title: 'Address',
                    subtitle: address,
                    icon: IconlyLight.profile,
                    onPressed: () async {
                      await _showAddressDialog();
                    },
                    color: color),
                // _listTiles(
                //     title: 'Orders',
                //     icon: IconlyLight.bag,
                //     onPressed: () {
                //       GlobalMethods.navigateTo(
                //           ctx: context, routeName: OrdersScreen.routeName);
                //     },
                //     color: color),
                // _listTiles(
                //     title: 'Wishlist',
                //     icon: IconlyLight.heart,
                //     onPressed: () {
                //       GlobalMethods.navigateTo(
                //           ctx: context, routeName: WishlistScreen.routeName);
                //     },
                //     color: color),
                _listTiles(
                    title: 'Viewed',
                    icon: IconlyLight.show,
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context,
                          routeName: ViewedRecentlyScreen.routeName);
                    },
                    color: color),
                _listTiles(
                    title: 'Forget Password',
                    icon: IconlyLight.unlock,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordScreen(),
                        ),
                      );
                    },
                    color: color),
                SwitchListTile(
                  title: TextWidget(
                    text: themeState.getDarkTheme ? 'Dark Mode' : 'Light Mode',
                    color: color,
                    textSize: 18,
                  ),
                  secondary: Icon(themeState.getDarkTheme
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined),
                  onChanged: (bool value) {
                    setState(() {
                      themeState.setDarkTheme = value;
                    });
                  },
                  value: themeState.getDarkTheme,
                ),
                _listTiles(
                    title: user == null ? 'Login' : 'Logout',
                    icon: user == null ? IconlyLight.login : IconlyLight.logout,
                    onPressed: () {
                      if (user == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreens(),
                          ),
                        );
                        return;
                      }
                      GlobalMethods.warningDialog(
                          title: 'Sign out',
                          subtitle: 'Do you wanna sign out?',
                          fct: () async {
                            await authInstance.signOut();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreens(),
                              ),
                            );
                          },
                          context: context);
                    },
                    color: color),
              ],
            ),
          )),
        ),
      ),
    );
  }

  // Future<void> _showLogoutDialog() async {
  //   await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Row(
  //             children: [
  //               Image.asset(
  //                 'assets/images/warning-sign.png',
  //                 height: 20,
  //                 width: 20,
  //                 fit: BoxFit.fill,
  //               ),
  //               const SizedBox(
  //                 width: 8,
  //               ),
  //               const Text('Sign out'),
  //             ],
  //           ),
  //           content: const Text('Do you wanna sign out?'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 if (Navigator.canPop(context)) {
  //                   Navigator.pop(context);
  //                 }
  //               },
  //               child: TextWidget(
  //                 color: Colors.cyan,
  //                 text: 'Cancel',
  //                 textSize: 18,
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 GlobalMethods.warningDialog(
  //                     title: 'Sign Out',
  //                     subtitle: 'Do you wanna Sign Out?',
  //                     fct: () {},
  //                     context: context);
  //               },
  //               child: TextWidget(
  //                 color: Colors.red,
  //                 text: 'OK',
  //                 textSize: 18,
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              // onChanged: (value) {
              //   print(
              //       '_addressTextController.text ${_addressTextController.text}');
              // },
              controller: _addressTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Your Address"),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String _uid = user!.uid;
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_uid)
                        .update({
                      'alamat': _addressTextController.text,
                    });

                    Navigator.pop(context);
                    setState(() {
                      address = _addressTextController.text;
                    });
                  } catch (err) {
                    GlobalMethods.errorDialog(
                        subtitle: err.toString(), context: context);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 22,
        //isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle ?? "",
        color: color,
        textSize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
