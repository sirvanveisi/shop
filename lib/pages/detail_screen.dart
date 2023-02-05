import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../models/pdoduct.dart';
import 'login.dart';
class DatailScreen extends StatefulWidget {
  int _id;

  //یک سازنده یک کانتراسکور میسازیم
  //بعد ای دی رو صدا میزنیم
  DatailScreen(this._id) : super();

  @override
  DatailScreenState createState() => new DatailScreenState();
}

class DatailScreenState extends State<DatailScreen> {
  //لیتسی از پرداکت ها که اسمشو میزاریم پروداکت لیست
  List<Product> productList = [];
  var scaffoldKey=GlobalKey<ScaffoldState>();

  AppBar _myAppbaar() {
    return AppBar(
      title: Text(
        //اینجا تکست رو تغییر میدیم
        "جزئیات محصول",
        style: TextStyle(fontFamily: "Vazir"),
      ),
    );
  }

  //پروداکت اینجا مقدار دهی میشه
  //جزیات رو بگیر
  getDetails() async {
    print(
        "https://192.168.1.112/digikala/getdetail.php?id=${widget._id}&user=1");

    //میخواییم درخواست بزنیم به یو ار ال و دیتا رو بگیریم
    var response = await Dio().get(
        "http://192.168.1.112/digikala/getdetail.php?id=${widget._id}&user=1");
    var details = json.decode(response.data);
    for (var productDetail in details) {
      //باید جیسون ها رو تبدیل کنیم به پرداکت
      //میگیم پرداکت اروی خونه ی ایدیش میشه ایدی
      //پروداکت اری خونه ی تایتل میشه تایتل و تا خونه اخر
      Product product = Product(
          productDetail["id"],
          productDetail["title"],
          productDetail["price"],
          productDetail["pprice"],
          productDetail["image"],
          color: productDetail["colors"],
          guarantee: productDetail["garantee"],
          introduction: productDetail["introduction"]);

      print("AAAA" + productDetail.toString());
      //چون میخوتییم تغییرات انجام بدهیم ست استیت رو صدا میزنیم
      setState(() {
        //  بعد میگیم پروداکت لیستی که ایجاد کردیم اد کن با این پروداکت ها
        //پرودایکت رو مقدار دهی میکنیم
        productList.add(product);
      });
    }
  }

  Widget wiatingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  Widget productDetailList(BuildContext context) {
    return ListView(
      children: <Widget>[
        CachedNetworkImage(
          width: double.infinity,
          height: 250,
          imageUrl: productList[0].getImage(),
        ),

        //ابتدا تکستمون رو داخل یک پدینگ قرار میدیم
        Padding(
          padding: const EdgeInsets.only(
            right: 16,
            top: 8,
          ),
          //به تکستمون استایل میدیم
          child: Text(
            productList[0].getTitle(),
            style: TextStyle(fontSize: 20),
          ),
        ),
        Card(
          margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),

          //پدینگمون رو داخل کالمن میزاریم
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    right: 16, left: 16, bottom: 4, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "رنگ ها :",
                      style: TextStyle(fontSize: 16),
                    ),
                    //میگییم کالر رو اینجا قرار بده
                    Text(
                      productList[0].getColor(),
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "گارانتی :",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      productList[0].getGuarantee(),
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                //(مرحله 1)
                //با استفاده از اچ تی ام ال اوضیحات و نوشته های ویژگی های محصولاتمون رو زیبا میکنیم
                child: Html(
                  data: productList[0].getIntroduction(),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ElevatedButton(
              onPressed: () {
               _checkLogin();
              },
              style: ButtonStyle(

                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.green),
                overlayColor: MaterialStateProperty.resolveWith(
                  (states) {
                    return states.contains(MaterialState.pressed)
                        ? Colors.green[800]
                        : null;
                  },
                ),
              ),
              child: Text(
                "افزودن به سبد خرید",
                style: TextStyle(color: Colors.white),
              )),
        )
      ],
    );
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

        //برای از بین بردن تصویر بالای برناممون
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            key: scaffoldKey,
              //جزیات محصول رو مینوسیم
              appBar: _myAppbaar(),
              body: productList == null || productList.isEmpty
                  ? wiatingView()
                  : productDetailList(context)),
        ));
  }

  void _checkLogin() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    String email=sharedPreferences.getString("email");
    //اگر ایمیلمون نال بود
    if(email==null){
showMessage("برای خرید وارد حساب کاربری خود شوید");
    }else{
_addToBasket(productList[0].getId(), email);
    }
  }
  showMessage(String content){
    ScaffoldMessenger.of(scaffoldKey.currentContext).showSnackBar(SnackBar(
      content: Text(content),
    ));
  }

  void _addToBasket(int productId,  String email)async {
    var response=await Dio().get("http://192.168.1.112/digikala/addbasket.php?product_id=$productId&email=$email");
print("http://192.168.1.112/digikala/addbasket.php?product_id=$productId&email=$email");
showMessage("محصول با موفقیت به سبد خرید شما افزوده شد");
  }
}
//tamam
