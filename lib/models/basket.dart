import 'package:flutter/cupertino.dart';

class Basket{
  int basketId;
  int productId;
  String title;
  int price;
  String image;
  String guarantee;

  //اینجا باید مقادیر رو به این پاس دهیم
  Basket(this.basketId,this.productId,this.title,this.price,this.image,
      this.guarantee);

  getBasketId(){
    return basketId;
  }
  getProductId(){
    return productId;
  }
  getTitle(){
    return title;
  }
  getPrice(){
    return price;
  }
  getImage(){
    return image;
  }

  getGuarantee(){
    return guarantee;
  }

}