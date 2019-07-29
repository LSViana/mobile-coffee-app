import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, 'cart.title')
        ),
      ),
      body: Container(
       child: Text(
         'Cart'
       ),
    ),
    );
  }
}