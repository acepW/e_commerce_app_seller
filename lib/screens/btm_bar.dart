import 'package:badges/badges.dart';
import 'package:e_commerce_app_seller/providers/dark_theme_provider.dart';
import 'package:e_commerce_app_seller/providers/user_provider.dart';
import 'package:e_commerce_app_seller/screens/categories.dart';
import 'package:e_commerce_app_seller/screens/chat_screen/chat_page.dart';
import 'package:e_commerce_app_seller/screens/home_screen.dart';
import 'package:e_commerce_app_seller/screens/orders/orders_screen.dart';
import 'package:e_commerce_app_seller/screens/user.dart';
import 'package:e_commerce_app_seller/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'cart/cart_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': const HomeScreen(), 'title': 'Home Screen'},
    {'page': const HalamanChatPage(), 'title': 'Chat Screen'},
    {'page': const OrdersScreen(), 'title': 'Order Screen'},
    {'page': const UserScreen(), 'title': 'User Screen'},
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    Provider.of<UserProvider>(context).refreshUser();

    bool isDark = themeState.getDarkTheme;
    return Scaffold(
      /* appBar: AppBar(
        title: Text(_pages[_selectedIndex]['title']),
      ), */
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? Theme.of(context).cardColor : Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        unselectedItemColor: isDark ? Colors.white10 : Colors.black12,
        selectedItemColor: isDark ? Colors.lightBlue.shade200 : Colors.black87,
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 1 ? IconlyBold.message : IconlyLight.message),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2 ? IconlyBold.bag : IconlyLight.bag),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2),
            label: "User",
          ),
        ],
      ),
    );
  }
}
