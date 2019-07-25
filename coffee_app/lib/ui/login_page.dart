import 'package:coffee_app/business/exceptions/not_found_exception.dart';
import 'package:coffee_app/business/transfer/authentication.dart';
import 'package:coffee_app/business/bloc/user/user_bloc.dart';
import 'package:coffee_app/main.dart';
import 'package:coffee_app/ui/stores_page.dart';
import 'package:coffee_app/widgets/error_dialog.dart';
import 'package:coffee_app/widgets/general_error_dialog.dart';
import 'package:coffee_app/widgets/title_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKey;
  Authentication _authentication;
  UserBloc _userBloc;
  bool _authenticating;

  Future<void> _formSubmit() async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      try {
        _authenticating = true;
        final authenticated = await _userBloc.authenticate(_authentication);
        await _userBloc.saveAuthenticated(authenticated);
        await Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StoresPage()
        ));
      } on NotFoundException {
        showDialog(
          context: context,
          builder: (context) => ErrorDialog(
            errorText: FlutterI18n.translate(context, 'signIn.invalidCredentials'),
            errorDescription: Text(
              FlutterI18n.translate(context, 'signIn.invalidCredentialsDescription'),
            ),
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => GeneralErrorDialog(),
        );
      } finally {
        _authenticating = false;
      }
    }
  }

  Future<void> _openSignUp() async {
    // TODO Open sign up
    print('Open sign up');
  }

  @override
  void initState() {
    super.initState();
    //
    _userBloc = coffeeGetIt<UserBloc>();
    _authentication = Authentication();
    _formKey = GlobalKey<FormState>();
    _authenticating = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(FlutterI18n.translate(context, 'signIn.title')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: <Widget>[
          TitleIcon(
            icon: Icons.shopping_basket,
          ),
          SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    cursorColor: theme.primaryColor,
                    initialValue: 'coffee.drinker@email.com',
                    decoration: InputDecoration(
                      labelText: FlutterI18n.translate(context, 'signIn.email'),
                    ),
                    validator: (value) {
                      if (value.length == 0)
                        return FlutterI18n.translate(
                            context, 'errors.validEmail');
                      return null;
                    },
                    onSaved: (value) => _authentication.email = value,
                  ),
                  TextFormField(
                    cursorColor: theme.primaryColor,
                    initialValue: 'Asdf1234',
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText:
                          FlutterI18n.translate(context, 'signIn.password'),
                    ),
                    validator: (value) {
                      if (value.length < 8)
                        return FlutterI18n.translate(
                            context, 'errors.validPassword');
                      return null;
                    },
                    onSaved: (value) => _authentication.password = value,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  FlutterI18n.translate(context, 'signUp.title').toUpperCase(),
                ),
                textColor: theme.primaryColor,
                onPressed: _authenticating ? null : _openSignUp,
              ),
              SizedBox(width: 8),
              RaisedButton(
                child: Text(
                  FlutterI18n.translate(context, 'signIn.title').toUpperCase(),
                ),
                color: theme.primaryColor,
                onPressed: _authenticating ? null : _formSubmit,
              ),
            ],
          )
        ],
      ),
    );
  }
}
