import 'dart:convert';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/pdoduct.dart';
import 'Cart_Screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  //لیتسی از پرداکت ها که اسمشو میزاریم پروداکت لیست
  List<Product> productList = [];
 var scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getAmazingProduct();
_checkLogin();
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
          accentColor: Colors.grey,
        ),

        //برای از بین بردن تصویر بالای برناممون
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            key: scaffoldKey,
              //میخواییک منوی کشویی درست کنیم
              drawer: myDrawerLayout(context),
              appBar: _myAppbaar(),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _imageSlider(),

                    _explanationTextForAmazingProduct(),

                    //روی لیست ویو میزنیم و یک وجت ازش درست میکنیم
                    // اکسپندت یعنی تا جایی که راه داره کش بده
                    SizedBox(
                      height: 200,
                      child: ListView.builder(

                          //یعنی قرار گرفتن افقی یا راست به چپ شدن
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(8),
                          //یعنی جهت حرکت
                          //که میشه افقی
                          //شینک رپ برای اینکه که بهمون ارور مگیره
                          shrinkWrap: true,
                          itemCount: productList.length,
                          itemBuilder: (context, index) {
                            //اگر پروداکت لیست من ایسکتی بود یا پروداکت لیست من مساوی نال بود ویتینگ ویو رو بهمون نشون بده
                            return productList.isEmpty || productList == null
                                ? wiatingView()
                                :

                                //میگیم هر کدوم از محصولات من داخل کارد باشه
                                //میگیم روی محصولاتمون کلیک کردیم مارو به صفحه جزِئیات ببر
                                //وقتی روی این کلیلک میکنیم نیاز بو ایدی پروداکتمون داریم
                                //جون میخواییم ایدی هر محصول رو بگیریم و بفرستین به صفحه ی datail
                                //توی صفحه ی دیتل باتوجه به اون ایدی که داره درخواست میزنیم به سرور
                                GestureDetector(
                                    onTap: () {
                                      //    میگه شمارو بفرستم به کجا میگیم صفحه ی دیتل اسکرین
                                      //    میگیم این گیت ایدی رو بفرست برای اون صفحه
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DatailScreen(
                                                      productList[index]
                                                          .getId())));
                                    },
                                    child: Card(
                                      child: Container(
                                        width: 250,
                                        height: 100,
                                        child: Column(
                                          children: <Widget>[
                                            //  اول تز همه یک عکس میخواییم نشون بدیم
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                  image: NetworkImage(
                                                    //  از این پروداکت  که اینجا وجود داره از پروداکت لیست خونه  ی این دیکس رو بگیر و ایمجش رو صدا بزن
                                                    productList[index]
                                                        .getImage(),
                                                  ),
                                                )),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8, left: 8, top: 8),
                                              child: Center(
                                                child: Text(productList[index]
                                                    .getTitle()),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                productList[index]
                                                    .getPrice()
                                                    //اینجا برای اینکه خطا نده تو استرینگ اضافه میگنیم یعنی مقدار(اینیجر رو تبدیل به استریگ میکنیم)
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                          }),
                    ),
                    // اینجا صداش میزنیم
                    _explanationTextForNewestProduct(),

                    // از اکسپندمون یک کپی میکنیم
                    SizedBox(
                      height: 200,
                      child: ListView.builder(

                          //یعنی قرار گرفتن افقی یا راست به چپ شدن
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(8),
                          //یعنی جهت حرکت
                          //که میشه افقی

                          //شینک رپ برای اینکه که بهمون ارور مگیره
                          shrinkWrap: true,
                          itemCount: productList.length,
                          itemBuilder: (context, index) {
                            //اگر پروداکت لیست من ایسکتی بود یا پروداکت لیست من مساوی نال بود ویتینگ ویو رو بهمون نشون بده
                            return productList.isEmpty || productList == null
                                ? wiatingView()
                                :

                                //میگیم هر کدوم از محصولات من داخل کارد باشه
                                Card(
                                    child: Container(
                                      width: 250,
                                      height: 100,
                                      child: Column(
                                        children: <Widget>[
                                          //  اول تز همه یک عکس میخواییم نشون بدیم
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                image: NetworkImage(
                                                  //  از این پروداکت  که اینجا وجود داره از پروداکت لیست خونه  ی این دیکس رو بگیر و ایمجش رو صدا بزن
                                                  productList[index].getImage(),
                                                ),
                                              )),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8, left: 8, top: 8),
                                            child: Center(
                                              child: Text(productList[index]
                                                  .getTitle()),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              productList[index]
                                                  .getPrice()
                                                  //اینجا برای اینکه خطا نده تو استرینگ اضافه میگنیم یعنی مقدار(اینیجر رو تبدیل به استریگ میکنیم)
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                          }),
                    )
                  ],
                ),
              )),
        ));
  }

  Drawer myDrawerLayout(BuildContext context) {
    //  چه مقادیری  داخل خودش داره این درایور
    return Drawer(
//    بخایر اینکه از لیست ویو استفاده میکنیم چون دایور یک لیست است
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              //    اینجا یک پدینگ میگره که ما نمی خواییم و برای اینکه پدینگو حذف کنیم
              //اینو اگه بنویسیم پدینگ صفر میشه از بین میره مقدارش
              padding: EdgeInsets.zero,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.purple[400],
                      Colors.purple[900],
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32, right: 15),
                        //گذاشتن تصویر بعنوان پروفایل
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              // شاپ برای گرد کردن عکس هست
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage("assets/images/profail.png"))),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16, left: 8),
                        child: Text(
                          "به اپلیکیشن فروشگاهی کلیک سایت خوش امدید",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )),
          //  حالا لیست تامونو ایجا میکنیم
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("حساب کاربری"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed("/login");
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("سبد خرید"),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("خروج"),
       onTap: (){},
            
          )
        ],
      ),
    );
  }

  AppBar _myAppbaar() {
    return AppBar(
      actions: <Widget>[
        IconButton(onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                    CartScreen()));
        },
          icon: Icon(Icons.shopping_cart),
        ),
      ],
      title: Text(
        "فروشگاه",
        style: TextStyle(fontFamily: "Vazir"),
      ),
    );
  }

  SizedBox _imageSlider() {
    return SizedBox(
      //چون میخواییم کل صفحه رو بگیره از این استفائه مکینم
      width: double.infinity,
      height: 250,
      child: Carousel(
        boxFit: BoxFit.cover,
        //یعنی با چه انیمیشنی اجرا بشه
        animationCurve: Curves.ease,
        //دات کالر رنگ نقطه اسلایدمون رو تغییر میده
        dotColor: Colors.white,
        //این وقتی رو هر اسلاید باشیم رنگ اون نقطه  اسلایدر رو تغییر میده
        dotIncreasedColor: Colors.red,
        //(طولبار اسلایدرمون)اندازه اون قسمتی که نقطه ی اسلایدرمون داخلش هست رو تغییر میده
        indicatorBgPadding: 12,
        //جای نقطه ی اسلایدر هامونو عوض میکینم
        dotPosition: DotPosition.bottomCenter,
        //دات سایز اندازه نقطه ی اسلایدرهامون است
        dotSize: 4,
        //  مقادیر کرسیل
        // توی ایمج تصاویر رو قرار میدیم
        images: [
          NetworkImage(
              "https://dkstatics-public.digikala.com/digikala-adservice-banners/ba5367186a6f67244618eb06a1cde309f88e8748_1666181491.jpg?x-oss-process=image/quality,q_95"),
          NetworkImage(
              "https://dkstatics-public.digikala.com/digikala-adservice-banners/4f02fdf755121071679570f650c62cdbcc2e1ec3_1666185411.jpg?x-oss-process=image/quality,q_95"),
          NetworkImage(
              "https://dkstatics-public.digikala.com/digikala-adservice-banners/7e592f32cca12c7fbe6b1659e0a23794ffda77d2_1666165678.jpg?x-oss-process=image/quality,q_95"),
          NetworkImage(
              "https://dkstatics-public.digikala.com/digikala-adservice-banners/455ba01d2843b76232c018ddcc5167cd5a546957_1666515091.jpg?x-oss-process=image/quality,q_95"),
          NetworkImage(
              "https://dkstatics-public.digikala.com/digikala-adservice-banners/fda0f320e0afe56c5ccdf53b6ec02cde50ec6d2f_1665302891.jpg?x-oss-process=image/quality,q_95"),
        ],
        //میگیم وقتی روی این تصاویر کلیک بکینم
        onImageTap: _onImageClick,
      ),
    );
  }

  // از این ویجتمون کپی میکنیم منها نامشو عوض میکنیم
  Widget _explanationTextForAmazingProduct() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      //رو را داخل پدینگ میزاریم
      child: Row(
        //اسپاس بتن یعنی فضای بین
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "محصولات شگفت انگیز",
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[500],
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget wiatingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  // یک ویجت ایجاد میکنیم برای اینکه کد هامون مرتب باشند
//  یک توضیح برای  جدید ترین محصولات
  Widget _explanationTextForNewestProduct() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      //رو را داخل پدینگ میزاریم
      child: Row(
        //اسپاس بتن یعنی فضای بین
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "جدیدترین محصولات",
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[500],
            size: 16,
          ),
        ],
      ),
    );
  }

  void _onImageClick(int index) {
    //  میگیم اگه روش کلیک کردیم پرینت کن یرامون ایندکسو که بفهمیم روی عکس چندم کلیلک کردیم
    print(index);
  }
  //میخواییم دیتا رو از سمت سرور بگیریم
  //میخواییم محصولات شگفت انگیز اضافه کنیم
  //این وجتمون رو کپی میکنیم و توی دیل مینوسیم
  getAmazingProduct() async {
    //میخواییم درخواست بزنیم به یو ار ال و دیتا رو بگیریم
    var response =
    await Dio().get("http://192.168.1.112/digikala/readamazing.php");
    var productArray = json.decode(response.data);
    //این پرودایکت اسمشو خودمون نوشتیم و میتونه هر اسمی باشه
//    میگیم به ازای هر پروداکتی که داخل پروداکت اری هست
    for (var productArray in productArray) {
      //باید جیسون ها رو تبدیل کنیم به پرداکت
      //میگیم پرداکت اروی خونه ی ایدیش میشه ایدی
      //پروداکت اری خونه ی تایتل میشه تایتل و تا خونه اخر
      Product product = Product(productArray["id"], productArray["title"],
          productArray["price"], productArray["pPrice"], productArray["image"]);
      //چون میخوتییم تغییرات انجام بدهیم ست استیت رو صدا میزنیم
      setState(() {
        //  بعد میگیم پروداکت لیستی که ایجاد کردیم اد کن با این پروداکت ها
        //پرودایکت رو مقدار دهی میکنیم
        productList.add(product);
      });
    }
  }

  void _checkLogin() async{
SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
String email=sharedPreferences.getString("email");
//اگه نال نبود
if(email!=null){
  showMessage("کاربر $emailخوش آمدید ");
}
  }
  showMessage(String message){
    ScaffoldMessenger.of(scaffoldKey.currentContext).showSnackBar(SnackBar(
      content: Text(message,style: TextStyle(fontFamily: "Vazir"),),
    ));
  }
}
