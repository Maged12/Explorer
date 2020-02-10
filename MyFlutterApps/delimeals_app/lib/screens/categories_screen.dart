import 'package:flutter/material.dart';
import '../dummy_data.dart';
import '../widgets/category_items.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: DUMMY_CATEGORIES
          .map(
            (catData) => CategoryItems(
              catData.id,
              catData.title,
              catData.image,
            ),
          )
          .toList(),
    );
  }
}

//You can use this if you want a GridView .
//GridView(
//          padding:const EdgeInsets.all(15),
//          children: DUMMY_CATEGORIES
//              .map(
//                (catData) => CategoryItems(
//                  catData.id,
//                  catData.title,
//                  catData.color,
//                ),
//              )
//              .toList(),
//          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//            maxCrossAxisExtent: 200,
//            childAspectRatio: 3 / 2,
//            crossAxisSpacing: 20,
//            mainAxisSpacing: 20,
//          ),
//    );
