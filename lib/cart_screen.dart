
import 'package:badges/badges.dart';
import 'package:catalog_app/cartModel.dart';
import 'package:catalog_app/cart_provider.dart';
import 'package:catalog_app/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBhelper dbHelper = DBhelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Product'),
        centerTitle: true,
        actions: [
          Badge(
            animationDuration: Duration(seconds: 3),
            position: BadgePosition.bottomEnd(bottom: 30),
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white),);
              },),
            child: Icon(Icons.shopping_cart_checkout),),
          SizedBox(width: 25,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<Cart>>snapshot) {
              if(snapshot.hasData) {
                if(snapshot.data!.isEmpty){
                  return Center(child: Column(
                    children: [
                      Image.asset('assets/images/maintenace.jfif',),
                      Text('Cart Is Empty',style: TextStyle(fontSize: 30),)
                    ],
                  ));
                }else{
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Card(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          child: ListTile(
                            leading: Image.network(snapshot.data![index].image.toString(),width: 90,fit: BoxFit.fill),
                            title: Text(snapshot.data![index].productName.toString() ),
                            subtitle: SizedBox(
                                child: Text('${snapshot.data![index].unitTag}  \$${snapshot.data![index].productPrice}')),
                            trailing: SizedBox(
                              width: 70,
                              height: double.infinity,
                              child: Column(
                                children: [
                                  InkWell(
                                      onTap:(){
                                        dbHelper.delete(snapshot.data![index].id!);
                                        cart.removeCounter();
                                        cart.removeTotalPrice(snapshot.data![index].productPrice!.toDouble());
                                      },
                                      child: Icon(Icons.delete,size: 24)),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.green,
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                            onTap:(){
                                              int quantity = snapshot.data![index].quantity!;
                                              int price = snapshot.data![index].initialPrice!;
                                              quantity--;
                                              int newPrice = price - quantity;
                                              if(quantity > 0){
                                                dbHelper.updateQuantity(Cart(productPrice: newPrice,
                                                    productName: snapshot.data![index].productName.toString(),
                                                    id: snapshot.data![index].id,
                                                    image: snapshot.data![index].image,
                                                    initialPrice: snapshot.data![index].initialPrice,
                                                    productId: snapshot.data![index].productId.toString(),
                                                    quantity: quantity,
                                                    unitTag: snapshot.data![index].unitTag)).then((value) {
                                                  newPrice = 0;
                                                  quantity = 0;
                                                  cart.removeTotalPrice(snapshot.data![index].productPrice!.toDouble());
                                                }).onError((error, stackTrace) {
                                                  print(error.toString());
                                                });
                                              }
                                            },
                                            child: Icon(Icons.remove,size: 20,)),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(snapshot.data![index].quantity.toString()),
                                        ),
                                        InkWell(
                                            onTap: (){
                                              int quantity = snapshot.data![index].quantity!;
                                              int price = snapshot.data![index].initialPrice!;
                                              quantity++;
                                              int? newprice = quantity * price;
                                              dbHelper.updateQuantity(
                                                  Cart(productPrice: newprice,
                                                      productName: snapshot.data![index].productName.toString(),
                                                      id:snapshot.data![index].id!,
                                                      image: snapshot.data![index].image,
                                                      initialPrice: snapshot.data![index].initialPrice,
                                                      productId: snapshot.data![index].productId.toString(),
                                                      quantity: quantity,
                                                      unitTag: snapshot.data![index].unitTag)
                                              ).then((value){
                                                newprice = 0;
                                                quantity =  0;
                                                cart.addTotalPrice(snapshot.data![index].initialPrice!.toDouble());
                                              }).onError((error, stackTrace){
                                                print(error.toString());
                                              });
                                            },
                                            child: Icon(Icons.add,size: 20))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),),
                  );
                }
              }
              else{
                return Text('');
              }
            },),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == '0.00' ? false:true,
                child: Column(
                  children: [
                  ReusableWidget(value: r'$'+ value!.getTotalPrice().toStringAsFixed(2), title: 'Sub Total'),
                    ReusableWidget(value: r'$' + '20', title: 'Discount 5%'),
                    ReusableWidget(value: r'$' + value.getTotalPrice().toString(), title: 'Sub Total')
                  ],
                ),
              );
            },)
          ],
        ),
      ),
    );
  }
}
class ReusableWidget extends StatelessWidget {
  final String title,value;
  ReusableWidget({Key? key,required this.value,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title,style: Theme.of(context).textTheme.subtitle2,),
          Text(value.toString(),style:Theme.of(context).textTheme.subtitle2 ,)
        ],
      ),
    );
  }
}
