import 'package:coffee_app/business/user/user_bloc.dart';
import 'package:coffee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    //
    _userBloc = coffeeGetIt<UserBloc>();
    handleSplashNextRoute();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.shopping_basket,
                size: 48,
                color: theme.accentColor,
              ),
              SizedBox(
                height: 16,
              ),
              Text(FlutterI18n.translate(context, 'names.app'),
                  style:
                      theme.textTheme.title.copyWith(color: theme.accentColor))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleSplashNextRoute() async {
    final isAuthenticated = await _userBloc.isAuthenticated;
    // TODO Send to another page
  }
}
