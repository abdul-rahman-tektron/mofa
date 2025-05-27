import 'dart:convert';

import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/login/login_response.dart';
import 'package:mofa/model/token_user_response.dart';
import 'package:mofa/utils/common/secure_storage.dart';

class CommonNotifier extends BaseChangeNotifier{
  LoginTokenUserResponse? _user;

  LoginTokenUserResponse? get user => _user;

  set user(LoginTokenUserResponse? value) {
    if(_user == value) return;
    _user = value;
    notifyListeners();
  }

  CommonNotifier() {
    loadUserFromStorage();
  }

  // Initialize user from local storage
  Future<void> loadUserFromStorage() async {
    final userString = await SecureStorageHelper.getUser();
    if (userString != null) {
      user = LoginTokenUserResponse.fromJson(jsonDecode(userString));
      notifyListeners();
    }
  }

  // Optional: update user from API or any source
  void updateUser(LoginTokenUserResponse user) {
    this.user = user;
    notifyListeners();
  }

  void clearUser() {
    user = null;
    notifyListeners();
  }
}