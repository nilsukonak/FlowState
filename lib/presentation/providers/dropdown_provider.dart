import 'package:flutter/material.dart';

class DropdownProvider with ChangeNotifier {
  String? _selectedvalue;
  String? _selectedPriority;

  String? get selectedvalue => _selectedvalue;
  String? get selectedPriority => _selectedPriority;

  void setCategory(String? value) {
    _selectedvalue = value;
    notifyListeners();
  }

  void setPriority(String? value) {
    _selectedPriority = value;
    notifyListeners();
  }
}
