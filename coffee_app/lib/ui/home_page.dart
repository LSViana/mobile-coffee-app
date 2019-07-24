import 'package:coffee_app/business/user/user_bloc.dart';
import 'package:coffee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    //
    _userBloc = coffeeGetIt<UserBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, 'names.app')
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          _userBloc.getText()
        ),
      ),
    );
  }
}