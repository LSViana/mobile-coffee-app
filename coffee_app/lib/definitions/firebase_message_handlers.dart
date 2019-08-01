import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessageHandler {
  FirebaseMessaging _firebaseMessaging;

  FirebaseMessageHandler() {
    _firebaseMessaging = FirebaseMessaging();
  }

  Future<void> setupHandlers() async {
    if (Platform.isIOS) {
      // TODO Add notifications for iOS
      _requestiOSPermissions();
    }
    final token = await _firebaseMessaging.getToken();
    print('Token acquired: $token');
    //
    _firebaseMessaging.configure(
      onResume: (json) => _printMessageFirebase('resume', json),
      onLaunch: (json) => _printMessageFirebase('launch', json),
      onMessage: (json) => _printMessageFirebase('message', json),
    );
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
