import 'dart:io';

import 'package:coffee_app/business/bloc/user/user_bloc.dart';
import 'package:coffee_app/coffee_app.dart';
import 'package:coffee_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class FirebaseMessageHandler {
  FirebaseMessaging _firebaseMessaging;
  UserBloc _userBloc;

  FirebaseMessageHandler() {
    _firebaseMessaging = FirebaseMessaging();
    _userBloc = coffeeGetIt<UserBloc>();
  }

  Future<String> setupHandlers() async {
    if (Platform.isIOS) {
      // TODO Add notifications for iOS
      _requestiOSPermissions();
    }
    String token;
    if (await _userBloc.isAuthenticated()) {
      final authenticated = await _userBloc.getAuthenticated();
      token = authenticated.fcmToken;
    } else {
      token = await _firebaseMessaging.getToken();
    }
    //
    _firebaseMessaging.configure(
      onResume: (json) => _printMessageFirebase('resume', json),
      onLaunch: (json) => _printMessageFirebase('launch', json),
      onMessage: (json) => _onMessageHandler(json),
    );
    //
    return token;
  }

  Future<void> _onMessageHandler(Map<String, dynamic> json) async {
    print(json);
    try {
      await showDialog(
          // The currentState.overlayState must be used to present dialogs, if you're just opening a new page, use the currentContext
          context: navigatorKey.currentState.overlay.context,
          builder: (context) {
            return AlertDialog(
              title: Text(json['notification']['title']),
              content: Text(json['notification']['body']),
              actions: <Widget>[
                FlatButton(
                  child: Text(FlutterI18n.translate(context, 'actions.ok')
                      .toUpperCase()),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          });
    } catch (e) {
      print(e);
    }
  }

  void _requestiOSPermissions() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  Future<void> _printMessageFirebase(
      String mode, Map<String, dynamic> json) async {
    print('Message received ($mode): $json');
  }
}
