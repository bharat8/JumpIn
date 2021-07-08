import 'package:flutter/material.dart';

class HomePlaceHolderProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get getCurrentIndex => _currentIndex;
  set setCurrentIndex(int val) {
    _currentIndex = val;
    notifyListeners();
  }

  bool _areContactsSynced = false;
  bool get contactsSyncedStatus => _areContactsSynced;
  set contactsSyncedStatus(bool val) {
    _areContactsSynced = val;
  }
}
