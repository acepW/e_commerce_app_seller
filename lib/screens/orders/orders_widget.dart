import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:e_commerce_app_seller/models/orders_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/product_details.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateToShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
  

    Widget buttonOrders = Container();

    switch (ordersModel.status) {
      case "Di proses":
        buttonOrders = Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: InkWell(
            onTap: () {
              GlobalMethods.warningDialog(
                  title: 'Pesanan di Kirim',
                  subtitle: 'Yakin Pesananmu Akan di Kirimkan?',
                  fct: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(ordersModel.orderId)
                          .update({"status": "Di kirimkan"});
                    } on FirebaseException catch (error) {
                      GlobalMethods.errorDialog(
                          subtitle: '${error.message}', context: context);
                    } catch (error) {
                      GlobalMethods.errorDialog(
                          subtitle: '$error', context: context);
                    } finally {}
                  },
                  context: context);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.green),
              child: Center(
                child: TextWidget(
                    text: "Kirimkan", color: Colors.white, textSize: 20),
              ),
            ),
          ),
        );
        break;
      case "Di kirimkan":
        buttonOrders = Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.green),
            child: Center(
              child: TextWidget(
                  text: "Sudah di Kirimkan", color: Colors.white, textSize: 20),
            ),
          ),
        );
        break;
      case "Selesai":
        buttonOrders = Container();
    }

    return Column(
      children: [
        ListTile(
          subtitle: Text(
              'Paid: Rp${int.parse(ordersModel.price).toStringAsFixed(2)}'),
          onTap: () {
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          leading: FancyShimmerImage(
            width: size.width * 0.2,
            imageUrl: ordersModel.imageUrl,
            boxFit: BoxFit.fill,
          ),
          title: TextWidget(
              text: '${ordersModel.title} x${ordersModel.quantity}',
              color: color,
              textSize: 18),
          trailing:
              TextWidget(text: orderDateToShow, color: color, textSize: 18),
        ),
        Container(
            child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(text: "Status     :", color: color, textSize: 18),
              Flexible(child: TextWidget(text: ordersModel.status, color: color, textSize: 18)),
            ],
          ),
        )),
        Container(
            child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(text: "Nama  :", color: color, textSize: 18),
              Flexible(
                child: TextWidget(
                    text: ordersModel.userName, color: color, textSize: 18),
              ),
            ],
          ),
        )),
        Container(
            child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(text: "Alamat  :", color: color, textSize: 18),
              SizedBox(width: 10,),
              Flexible(
                child: TextWidget(
                    text: ordersModel.alamatUser, color: color, textSize: 18),
              ),
            ],
          ),
        )),
        Container(
            child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(text: "Metode Pengiriman :", color: color, textSize: 18),
              Flexible(
                child: TextWidget(
                    text: ordersModel.pengambilan, color: color, textSize: 18),
              ),
            ],
          ),
        )),
         Container(
            child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(text: "Metode pembayaran :", color: color, textSize: 18),
              Flexible(
                child: TextWidget(
                    text: ordersModel.pembayaran, color: color, textSize: 18),
              ),
            ],
          ),
        )),
        SizedBox(
          height: 10,
        ),
        buttonOrders
      ],
    );
  }
}
