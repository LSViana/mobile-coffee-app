import 'package:coffee_app/widgets/coffee_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key}) : super(key: key);

  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, 'orders.title'),
        ),
      ),
      drawer: CoffeeDrawer(pageIndex: 1),
      body: Container(
        child: Center(
          child: Text('Orders'),
        ),
      ),
    );
  }
}