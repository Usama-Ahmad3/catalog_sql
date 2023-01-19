
import 'dart:core';
import 'package:catalog_app/cartModel.dart';
import 'package:catalog_app/cart_provider.dart';
import 'package:catalog_app/cart_screen.dart';
import 'package:catalog_app/database.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  DBhelper? dbHelper = DBhelper();
  List<String> productName = ['Mango','Orange', 'Grapes','Banana', 'Chery','Peach', 'Mixed Fruit Basket','Apple','Guava','Strawberry'];
  List<String> productUnit = ['Kg','Dozen','Kg','Dozen','Kg','Kg','Kg','Kg','Kg','Kg'];
  List<int> productPrice = [10,20,30,40,50,60,70,80,90,15];
  List<String> productImage = [
    'https://images.pexels.com/photos/2294471/pexels-photo-2294471.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/327098/pexels-photo-327098.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/7214926/pexels-photo-7214926.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/61127/pexels-photo-61127.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/371043/pexels-photo-371043.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/4397790/pexels-photo-4397790.jpeg?auto=compress&cs=tinysrgb&w=400',
    'https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg?auto=compress&cs=tinysrgb&w=400',
    'https://images.pexels.com/photos/209439/pexels-photo-209439.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/5945797/pexels-photo-5945797.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/6944172/pexels-photo-6944172.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ];
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(),));
            },
            child: Badge(
              animationDuration: Duration(seconds: 3),
              position: BadgePosition.bottomEnd(bottom: 30),
                badgeContent: Consumer<CartProvider>(
                    builder: (context, value, child) {
                      return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white),);
                    },),
                child: Icon(Icons.shopping_cart_checkout),),
          ),
          SizedBox(width: 25,)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                  child: ListTile(
                  leading: Image.network(productImage[index].toString(),width: 90,fit: BoxFit.fill),
                  title: Text(productName[index] ),
                  subtitle: SizedBox(
                      child: Text('${productUnit[index]}  \$${productPrice[index]}')),
                  trailing:InkWell(
                        onTap: (){
                      dbHelper!.insert(
                          Cart(productPrice: productPrice[index], productName: productName[index].toString(),
                              id: index.toInt(), image: productImage[index].toString(),
                              initialPrice: productPrice[index].toInt(), productId: index.toString(),
                              quantity: 1, unitTag: productUnit[index])
                      ).then((value){
                        print('Product Is Added To Cart');
                      }).onError((error, stackTrace) {
                        print(error.toString());
                        cart.addTotalPrice(double.parse(productPrice[index].toString()));
                        cart.addCounter();
                      });
                    },
                        child: Container(
                            width: 90,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Center(child: Text('Add to cart')))),
                  ),
            ),
                ),
              ),),
        ],
      ),
    );
  }
}