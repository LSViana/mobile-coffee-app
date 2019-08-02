import 'dart:io';

import 'package:coffee_app/business/bloc/user/user_bloc.dart';
import 'package:coffee_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
    if(await _userBloc.isAuthenticated()) {
      final authenticated = await _userBloc.getAuthenticated();
      token = authenticated.fcmToken;
    }
    else {
      token = await _firebaseMessaging.getToken();
    }
    //
    _firebaseMessaging.configure(
      onResume: (json) => _printMessageFirebase('resume', json),
      onLaunch: (json) => _printMessageFirebase('launch', json),
      onMessage: (json) => _printMessageFirebase('message', json),
    );
    //
    return token;
  }

  void _requestiOSPermissions() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  Future<void> _printMessageFirebase(String mode, Map<String, dynamic> message) async {
    print('Message received ($mode): $message');
  }
}
