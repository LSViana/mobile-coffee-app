import 'dart:ui';

import 'package:coffee_app/business/model/user.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class UserHeaderInformation extends StatelessWidget {
  const UserHeaderInformation({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            // TODO Update user model to have picture
            image:
                'https://thoughtcatalog.files.wordpress.com/2015/03/shutterstock_221306548.jpg?w=786&h=523',
            fadeInDuration: Duration(milliseconds: 300),
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(.25)),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Material(
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: Container(
                  width: 96,
                  height: 96,
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    // TODO Update user model to have picture
                    image:
                        'https://thoughtcatalog.files.wordpress.com/2015/03/shutterstock_221306548.jpg?w=786&h=523',
                    fadeInDuration: Duration(milliseconds: 300),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                user.name,
                style: theme.textTheme.title.copyWith(color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                user.deliveryAddress,
                style: theme.textTheme.caption
                    .copyWith(color: Colors.white.withOpacity(.75)),
              )
            ],
          ),
        ),
      ],
    );
  }
}
