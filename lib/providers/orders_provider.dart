import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app_seller/models/orders_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrderModel> _orders = [];
  List<OrderModel> get getOrders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('orders')
        .where('sellerId', isEqualTo: user!.uid)
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      _orders = [];
      // ordersList.clear();
      ordersSnapshot.docs.forEach((element) {
        _orders.insert(
            0,
            OrderModel(
              orderId: element.get('orderId'),
              userId: element.get('userId'),
              sellerId: element.get('sellerId'),
              sellerName: element.get('sellerName'),
              status: element.get('status'),
              title: element.get('title'),
               pengambilan: element.get('pengambilan'),
              pembayaran : element.get('pembayaran'),
              productId: element.get('productId'),
              userName: element.get('userName'),
              price: element.get('price').toString(),
              imageUrl: element.get('imageUrl'),
              quantity: element.get('quantity').toString(),
              alamatUser: element.get('alamatUser'),
              alamatSeller: element.get('alamatSeller'),
              orderDate: element.get('orderDate'),
            ));
      });
    });
    notifyListeners();
  }
}
