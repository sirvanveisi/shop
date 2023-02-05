import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/pdoduct.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
//  ما بصورت پیش فرض تو لاگیم مود هستیم و این به صورت پیش فرض ترو هست
  bool LoginMode = true;
  SharedPreferences sharedPreferences;

  //
  //دوتا کنترلر میخواییم و دو تا کی
  //ابتدا باید دیتا هارا بگیریم
  var emailKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  //اینم کنترلرمان
  var emailController = TextEditingController();
  var passController = TextEditingController();

//  متتدی ایجاد میکنیم به اسم لاگین
  _Login(BuildContext buildContext, String email, String pass) async {
    //میگیم دیتا رو چگونه میفرستیم اول یک فرم دیتا صدا میزنیم
    FormData loginForm = FormData.fromMap({
      "email": email,
      "pass": pass,
    });

//    میخواییم یک درخواستی سمت سرور بزنیم و یک دیتایی رو بگیریم
//  میگه به کدوم ایدی میخوای درخواست بزنی
    var response = await Dio()
        .post("http://192.168.176.2/digikala/login.php", data: loginForm);
    var jsonData = json.decode(response.data);
    print(jsonData["status"] + "/" + jsonData["message"]);
    if (jsonData["status"] == "success") {
// کلاس شیریدپروفرمنس
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      //با این کار دیتا رو روی شیریدپروفرمش ذخیره میکنیم
      sharedPreferences.setString("email", jsonData["message"]);
      showMessage("ورود با موفقیت انجام شد");
    } else {
      showMessage("نام کاربری یا کلمه عبور اشتباه است");
    }
  }

  //متدد شو مسیج
  showMessage(String message) {
    ScaffoldMessenger.of(scaffoldKey.currentContext).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  AppBar _myAppbaar() {
    return AppBar(
      title: Text(
        //اینجا تکست رو تغییر میدیم
        "ورود به حساب کاربری",
        style: TextStyle(fontFamily: "Vazir"),
      ),
    );
  }

  Widget wiatingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  //(بعد از اینکه کد هارو مرتب کردیم کم یا زیاد کردیم این میشه
  //یک ویجت ایجاد میکنیم
  Widget LoginForm(BuildContext buildContext) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 250,
        child: Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: TextFormField(
                  key: emailKey,
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "ایمیل",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[200],
                            width: 2,
                          ))),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: TextFormField(
                  //کی میشه پس کی
                  key: passKey,
                  //کنترلر میشه پس کنترلر
                  controller: passController,
                  decoration: InputDecoration(
                      hintText: "رمز عبور",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[200],
                            width: 2,
                          ))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              //اینجا میگیم .قتی ان پرسد صدا زده شد یه متدی صدا بشه
                              _Login(buildContext, emailController.text,
                                  passController.text);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.pink),
                              overlayColor:
                              MaterialStateProperty.resolveWith((states) {
                                return states.contains(MaterialState.pressed)
                                    ? Colors.pink[800]
                                    : null;
                              }),
                            ),
                            child: Text("ورود"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _changeLoginMode();
                              },
                              child: Text(
                                "ثبت نام",
                                style: TextStyle(color: Colors.pink),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget SignupForm() {
    return Center(
      child: Container(
        width: double.infinity,
        height: 250,
        child: Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: TextFormField(
                  //(مرحله 1 )
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "ایمیل",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[200],
                            width: 2,
                          ))),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: TextFormField(
                  //(مرحله 2)
                  controller: passController,
                  decoration: InputDecoration(
                      hintText: "رمز عبور",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[200],
                            width: 2,
                          ))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              //  (مرحله3)
                              //  متدی قرار دیم
                              _signup(
                                  emailController.text, passController.text);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.pink),
                              overlayColor:
                              MaterialStateProperty.resolveWith((states) {
                                return states.contains(MaterialState.pressed)
                                    ? Colors.pink[800]
                                    : null;
                              }),
                            ),
                            child: Text("ثبت نام"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _changeLoginMode();
                              },
                              child: Text(
                                "ورود به حساب کاربری",
                                style: TextStyle(color: Colors.pink),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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
          accentColor: Colors.grey,
        ),

        //برای از بین بردن تصویر بالای برناممون
        debugShowCheckedModeBanner: false,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.grey[200],
              appBar: _myAppbaar(),
              //اینجا شرط میزاریم
              //اگه لاگین مود درست هست بیا  لاگین فرم رو قرار بده در غیر اینصورت سایناپ فرم رو نشون بده
              body: LoginMode ? LoginForm(context) : SignupForm()),
        ));
  }

  void _changeLoginMode() {
    //  میگیم وقتی روی این کلیک کردیم ست استیت رو صدا بزن
    setState(() {
      //اگر لاگین مودمون هرچی بود
      //  لاگین مود بشه فالص
      if (LoginMode) {
        LoginMode = false;
        //  درغیر اینصورت لاگین مود بشه ترو
      } else {
        LoginMode = true;
      }
    });

  }
  //(مرحله 4)
//متدد اسناپ رو میسازیم
  void _signup(String email, String pass)async {
    FormData signupForm = FormData.fromMap({
      "email": email,
      "pass": pass,
    });

    //دیتا رو میفرستیم سمت سرور
    var response =
    await Dio().post(
        "http://192.168.176.2/digikala/signup.php", data: signupForm);
    var jsonData = jsonDecode(response.data);
    print(jsonData["massage"]);
//میگیم یک نمونه رو بگیر
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//بعد میگیم
    sharedPreferences.setString("email", jsonData["message"]);
    showMessage("ثبت نام با موفقیت انجام شد");
  }

}



