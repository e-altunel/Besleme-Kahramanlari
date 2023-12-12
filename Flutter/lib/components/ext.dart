import 'package:flutter/material.dart';

/*Bu dosyada page'lerde kullandığım operasyonları kısaltmak için eklediğim fonksiyonlar bulunmaktadır.*/
bottom_message(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.black, fontSize: 18),
      textAlign: TextAlign.center,
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.red,
  ));
}
