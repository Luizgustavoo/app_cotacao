import 'package:flutter/material.dart';

enum InternetStatus { connected, disconnected }

class InternetStatusProvider with ChangeNotifier {
  InternetStatus _status = InternetStatus.connected;

  InternetStatus get status => _status;

  void setStatus(InternetStatus status) {
    _status = status;
    notifyListeners();
  }
}
