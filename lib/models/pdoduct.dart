import 'package:flutter/cupertino.dart';

class Product{
  int id;
  String title;
  String price;
  String pPrice;
  String image;
  String color;
  String guarantee;
  String introduction;
  //اینجا باید مقادیر رو به این پاس دهیم
  Product(this.id,this.title,this.price,this.pPrice,this.image,
      {this.color, this.guarantee, this.introduction});

  getId(){
    return id;
  }
  getTitle(){
    return title;
  }
  getPrice(){
    return price;
  }
  getPPrice(){
    return pPrice;
  }
  getImage(){
    return image;
  }
  getColor(){
    return color;
  }
  getGuarantee(){
    return guarantee;
  }
  getIntroduction(){
    return introduction;
  }
}