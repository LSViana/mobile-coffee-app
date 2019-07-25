import 'package:coffee_app/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class GeneralErrorDialog extends StatelessWidget {
  const GeneralErrorDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorDialog(
      key: key,
      errorText: FlutterI18n.translate(context, 'errors.general'),
      errorDescription: Text(
        FlutterI18n.translate(context, 'errors.generalDescription'),
      ),
    );
  }
}