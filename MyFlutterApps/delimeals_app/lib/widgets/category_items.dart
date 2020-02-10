import 'package:flutter/material.dart';
import '../screens/category_meals_screen.dart';

class CategoryItems extends StatelessWidget {
  final String id;
  final String title;
  final String image;
  CategoryItems(this.id, this.title, this.image);
  void selectCat(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      CategoryMealsScreen.routeName,
      arguments: {
        'id': id,
        'title': title,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () => selectCat(context),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              elevation: 10,
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Image.asset(
                      image,
                      height: 125,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 60,
                    child: Container(
                      width: 230,
                      color: Colors.black54,
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Center(
                        child: Text(
                          title,
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          softWrap: true,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
//          SizedBox(
//            height: 10,
//          )
        ],
      ),
    );
  }
}
