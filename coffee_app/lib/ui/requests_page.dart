import 'package:coffee_app/widgets/coffee_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class RequestsPage extends StatefulWidget {
  RequestsPage({Key key}) : super(key: key);

  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'requests.title')),
      ),
      drawer: CoffeeDrawer(pageIndex: 3),
      body: Container(
        child: Text('Requests'),
      ),
    );
  }
}
