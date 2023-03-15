import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/category.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [
    // Category('Family', hexToDec((Icons.family_restroom.hashCode).toString())),
    Category('Family', 'IconData(U+0F400)'),
  ];

  final _auth = FirebaseAuth.instance;
  final _base = FirebaseFirestore.instance;

  CategoryProvider();

  //Category getCategory(String categoryId) {}

  List<Category> get categories {
    return [..._categories];
  }

  void addCategory(
      String categoryName, String iconIndex, BuildContext context) async {
    User authResult = _auth.currentUser;
    bool _isExist = true;

    QuerySnapshot query = await _base.collection(authResult.uid).get();

    query.docs.forEach((document) {
      categoryName == document.id ? _isExist = true : null;
    });

    if (_isExist == false && !categoryName.isEmpty) {
      await _base.collection(authResult.uid).doc(categoryName).set({
        "Icon": iconIndex,
        "Name": categoryName,
      });

      _categories.add(Category(categoryName, iconIndex));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Category Added',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 3),
      ));
      Navigator.of(context).pop();
    }
    _isExist == true
        ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'This category already exist',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
          ))
        : null;
    categoryName.isEmpty
        ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'No category name was entered',
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
          ))
        : null;
  }
}

// int hexToDec(String hexCode) {
//   for (int i = 0; i <= hexCode.length - 8; i += 8) {
//     final hex = hexCode.substring(i, i + 8);
//     final number = int.parse(hex, radix: 16);
//     return number;
//   }
// }
