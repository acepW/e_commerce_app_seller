import 'package:flutter/cupertino.dart';

class ProductModel with ChangeNotifier {
  final String id,
      sellerId,
      sellerName,
      alamatSeller,
      title,
      deskripsi,
      imageUrl,
      productCategoryName;
  final int price, salePrice;
  final bool isOnSale, isPiece, stock;

  ProductModel(
      {required this.id,
      required this.sellerId,
      required this.sellerName,
      required this.alamatSeller,
      required this.title,
      required this.imageUrl,
      required this.deskripsi,
      required this.productCategoryName,
      required this.price,
      required this.salePrice,
      required this.isOnSale,
      required this.isPiece,
      required this.stock});
}
