import 'package:catalog_app/cartModel.dart';
import 'package:catalog_app/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier{
  DBhelper db = DBhelper();
  int _counter = 0;
  int get counter => _counter;
  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;
  late Future<List<Cart>> _cart;
  Future<List<Cart>> getData() async{
    _cart = db.getCartList();
    return _cart;
  }

  void _setPrefItems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }
  void _getPrefItem() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item')??0;
    _totalPrice = prefs.getDouble('total_price')??0;
    notifyListeners();
  }
  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }
  void removeCounter(){
    _counter--;
    _setPrefItems();
    notifyListeners();
  }
  int getCounter(){
    _getPrefItem();
    return _counter;
  }
  void addTotalPrice(double productPrice){
    _totalPrice = _totalPrice + productPrice;
    _setPrefItems();
    notifyListeners();
  }
  void removeTotalPrice(double productPrice){
    _totalPrice = _totalPrice - productPrice;
    _setPrefItems();
    notifyListeners();
  }
  double getTotalPrice(){
    _getPrefItem();
    return _totalPrice;
  }
}