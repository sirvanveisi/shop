import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import '../models/basket.dart';
import 'Cart_Screen.dart';

class PayementScreen extends StatefulWidget {
  String orderId;

  PayementScreen(this.orderId);
//zang ba watsapp
  //day
  @override
  State<StatefulWidget> createState() {
    return PayementScreenState();
  }
}

class PayementScreenState extends State<PayementScreen> {
  AppBar _myAppbar() {
    return AppBar(
      title: Text(
        "جزئیات محصول",
        style: TextStyle(fontFamily: "Vazir"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _myAppbar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 250,
            child: Card(
              child: Center(
                child: Column(
                  children: <Widget>[
                  Text("خرید شما با موفقیت انجام شد",
                  style: TextStyle(color: Colors.green, fontSize: 18),),
                    Text("کد تراکنش : ${widget.orderId}",style: TextStyle(fontSize: 22),)
                ],
              ),
            ),
          ),
        ),
      ),
    ),);
  }

  @override
  void initState() {
  }
}
