import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:payement/pages/payement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import '../models/basket.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        //برای اینکه تو کل برانممون این فونت رو ست کنیم
        fontFamily: "Vazir",
        backgroundColor: Colors.red,
        primaryColor: Colors.red,
        accentColor: Colors.grey,
      ),
      home: CartScreenStatefull(),
    );
  }
}

class CartScreenStatefull extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartsScreenState();
  }
}

class CartsScreenState extends State<CartScreenStatefull> {
  List<Basket> basketList = [];
  int totalPrice = 0;
  AppBar _myAppbar() {
    return AppBar(
      title: Text(
        "سبد خرید",
        style: TextStyle(fontFamily: "Vazir"),
      ),
    );
  }
  Future<Null> initUniLinks() async {
    getUriLinksStream().listen((Uri uri) {
      print(uri.queryParameters["order_id"]);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder:( context)=>
                  PayementScreen(uri.queryParameters["order_id"])));
    }, onError: (err) {});
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _myAppbar(),
        body: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(" مجموع قیمت :$totalPrice تومان"),
                    GestureDetector(
                      onTap: () {
                        _onlinePay();
                      },
                      child: Text(
                        "پرداخت ",
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  ],
                ),
              ),
            ),
           Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: basketList.length,
                  itemBuilder: (context, indext) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: 8, left: 8, top: 2, bottom: 2),
                      child: basketList.isEmpty || basketList == null
                          ? wiatingView()
                          : Container(
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          basketList[indext].getImage()))),
                            ),
                            Text(basketList[indext].getTitle()),
                            Text(basketList[indext].getPrice().toString()),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _getBasketList();
    initUniLinks();
  }

  calculateTotalPrice() {
    for (int i = 0; i < basketList.length; i++) {
      setState(() {
        totalPrice += basketList[i].getPrice();
        //  totalPrice = totalPrice + int.parse(basketList[i].getPrice());
      });
    }
  }

  Widget wiatingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _getBasketList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String email = sharedPreferences.getString("email");
    var response = await Dio()
        .get("http://192.168.1.112/digikala/basketlist.php?email=$email");
    var basketArry = json.decode(response.data);
//این باسکت اسمشو خودمون نوشتیم و میتونه هر اسمی باشه
//    میگیم به ازای هر باسکت که داخل پروداکت اری هست
    for (var itme in basketArry) {
      //باید جیسون ها رو تبدیل کنیم به پرداکت
      //میگیم پرداکت اروی خونه ی ایدیش میشه ایدی
      //پروداکت اری خونه ی تایتل میشه تایتل و تا خونه اخر
      Basket basket = Basket(itme["basket_id"], itme["product_id"],
          itme["title"], itme["price"], itme["image"], itme["guarantee"]);
      //چون میخوتییم تغییرات انجام بدهیم ست استیت رو صدا میزنیم
      setState(() {
        //  بعد میگیم پروداکت لیستی که ایجاد کردیم اد کن با این پروداکت ها
        //پرودایکت رو مقدار دهی میکنیم
        basketList.add(basket);
        //میگیم کالکلویت توتال پرایس رو صدا بزن
      });
    }
    calculateTotalPrice();
  }

  void _onlinePay() async {
    var url = "https://192.168.1.112/digikala/test.php";
    if (!await canLaunch(url)) {
      await launch(url);
    } else {
      throw'Could not launch $url';
    }
  }
}
