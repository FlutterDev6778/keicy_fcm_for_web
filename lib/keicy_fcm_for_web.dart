library keicy_fcm_for_web;

import 'dart:async';
import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter/material.dart';

class KeicyFCMForWeb {
  static final KeicyFCMForWeb _instance = KeicyFCMForWeb();
  static KeicyFCMForWeb get instance => _instance;

  final firebase.Messaging _fcm = firebase.messaging();
  String _token;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void close() {
    _controller?.close();
  }

  Future<void> init({@required String key}) async {
    _fcm.usePublicVapidKey(key);
    _fcm.onMessage.listen((firebase.Payload event) {
      print("event.collapseKey:   ${event.collapseKey}");
      print("event.data:  ${event.data}");
      print("event.from:  ${event.from}");
      print("event.notification.title:   ${event.notification.title}");
      print("event.notification.body:   ${event.notification.body}");
      print("event.notification.icon:   ${event.notification.icon}");
      print("event.notification.clickAction:   ${event.notification.clickAction}");
      _controller.add({"title": event.notification.title, "body": "event.notification.body"});
    });
  }

  Future requestPermission() {
    return _fcm.requestPermission();
  }

  Future<String> getToken([bool force = false]) async {
    if (force || _token == null) {
      _token = await _fcm.getToken();
    }
    return _token;
  }
}
