import 'package:e_commerce_app_seller/services/utils.dart';
import 'package:e_commerce_app_seller/widgets/categories_widget.dart';
import 'package:e_commerce_app_seller/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  List<Color> gridColor = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];
  List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'assets/images/cat/fruits.png',
      'catText': 'Elektronik',
    },
    {
      'imgPath': 'assets/images/cat/veg.png',
      'catText': 'Sparepart',
    },
    {
      'imgPath': 'assets/images/cat/nuts.png',
      'catText': 'House',
    },
    {
      'imgPath': 'assets/images/cat/spices.png',
      'catText': 'Clothes',
    },
    {
      'imgPath': 'assets/images/cat/grains.png',
      'catText': 'Kitchen',
    },
    {
      'imgPath': 'assets/images/cat/Spinach.png',
      'catText': 'Others',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Categories',
          color: color,
          textSize: 24,
          isTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 240 / 250,
          crossAxisSpacing: 10, //vertical
          mainAxisSpacing: 10, //horizontal
          children: List.generate(6, (index) {
            return CategoriesWidget(
              catText: catInfo[index]['catText'],
              imgPath: catInfo[index]['imgPath'],
              passedColor: gridColor[index],
            );
          }),
        ),
      ),
    );
  }
}
