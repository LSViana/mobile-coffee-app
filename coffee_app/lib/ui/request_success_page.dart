import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class RequestSuccessPage extends StatefulWidget {
  RequestSuccessPage({Key key}) : super(key: key);

  _RequestSuccessPageState createState() => _RequestSuccessPageState();
}

class _RequestSuccessPageState extends State<RequestSuccessPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, 'cart.requestSent'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(FlutterI18n.translate(context, 'stores.title').toUpperCase()),
        icon: Icon(Icons.home),
        backgroundColor: theme.primaryColor,
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.check),
            SizedBox(width: 8),
            Text(FlutterI18n.translate(context, 'names.success'))
          ],
        ),
      ),
    );
  }
}
