import 'package:coffee_app/business/transfer/authentication.dart';
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

  Future<void> _formSubmit() async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      // TODO Authenticate
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
    _authentication = Authentication();
    _formKey = GlobalKey<FormState>();
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
                onPressed: _openSignUp,
              ),
              SizedBox(width: 8),
              RaisedButton(
                child: Text(
                  FlutterI18n.translate(context, 'signIn.title').toUpperCase(),
                ),
                color: theme.primaryColor,
                onPressed: _formSubmit,
              ),
            ],
          )
        ],
      ),
    );
  }
}
