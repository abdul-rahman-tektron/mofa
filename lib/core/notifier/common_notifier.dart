import 'dart:convert';

import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/login/login_response.dart';
import 'package:mofa/utils/common/secure_storage.dart';

class CommonNotifier extends BaseChangeNotifier{
  UserModel? _user;

  UserModel? get user => _user;

  CommonNotifier() {
    loadUserFromStorage();
  }

  // Initialize user from local storage
  Future<void> loadUserFromStorage() async {
    final userString = await SecureStorageHelper.getUser();
    if (userString != null) {
      _user = UserModel.fromJson(jsonDecode(userString));
      notifyListeners();
    }
  }

  // Optional: update user from API or any source
  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}