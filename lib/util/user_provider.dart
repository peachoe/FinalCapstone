import 'package:flutter/material.dart';
import 'user.dart';


class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 6dd3187e6e1fd40e53308601cc44db93ff4c0322
