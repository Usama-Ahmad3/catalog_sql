
import 'dart:core';

class Cart{
  late final int? id;
  final String? productId;
  final String? productName;
  final String? unitTag;
  final String? image;
  final int? initialPrice;
  final int? productPrice;
  final int? quantity;


  Cart({required this.productPrice,required this.productName,required this.id,required this.image,
   required this.initialPrice,required this.productId,required this.quantity,required this.unitTag
  });
  Cart.fromMap(Map<dynamic,dynamic> res)
  : id = res['id'],
  productId = res['productId'],
  productName = res['productName'],
  unitTag = res['unitTag'],
  image = res['image'],
  initialPrice = res['initialPrice'],
  productPrice = res['productPrice'],
  quantity = res['quantity'];

  Map<String, Object?> toMap(){
    return {
      'id' : id,
      'productId' : productId,
      'productName' : productName,
      'unitTag' : unitTag,
      'image' : image,
      'initialPrice' : initialPrice,
      'productPrice' : productPrice,
      'quantity' : quantity,
    };
  }
}