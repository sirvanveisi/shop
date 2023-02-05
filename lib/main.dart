import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:payement/pages/home.dart';
import 'package:payement/pages/login.dart';

import 'models/pdoduct.dart';

// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }

void main() {
  // HttpOverrides.global = new MyHttpOverrides();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainStatefull(),
    );
  }
}

class MainStatefull extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MainStatefull> {


//یک وجیت ایجاد میکینم


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      //تیم یعنی موضوع
      theme: ThemeData(
        primarySwatch: Colors.red,
        //برای اینکه تو کل برانممون این فونت رو ست کنیم
        fontFamily: "Vazir",
        backgroundColor: Colors.red,
        primaryColor: Colors.red,
        accentColor: Colors.green,
      ),
      routes: {
        "/login": (context) => LoginScreen(),
        "/": (context) => HomeScreen(),
      },
      //برای از بین بردن تصویر بالای برناممون
      debugShowCheckedModeBanner: false,
    );
  }

}
