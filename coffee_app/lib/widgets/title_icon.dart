import 'package:flutter/material.dart';

class TitleIcon extends StatelessWidget {
  final IconData icon;

  const TitleIcon({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return Material(
      elevation: 4,
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(
          color: theme.primaryColor,
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(
          icon,
          size: 64,
        ),
      ),
    );
  }
}
