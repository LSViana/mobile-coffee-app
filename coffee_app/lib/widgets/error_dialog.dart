import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ErrorDialog extends StatelessWidget {
  final String errorText;
  final Widget errorDescription;

  const ErrorDialog({
    Key key,
    @required this.errorText,
    @required this.errorDescription,
  }) :
    assert(errorText != null),
    assert(errorDescription != null),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return AlertDialog(
      title: Text(
        errorText
      ),
      content: errorDescription,
      actions: <Widget>[
        FlatButton(
          textColor: theme.primaryColor,
          child: Text(
            FlutterI18n.translate(context, 'actions.close').toUpperCase(),
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        )
      ],
    );
  }
}