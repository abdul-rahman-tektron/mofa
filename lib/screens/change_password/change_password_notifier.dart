import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/update_password/update_password_request.dart';
import 'package:mofa/core/notifier/common_notifier.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';
import 'package:mofa/model/token_user_response.dart';
import 'package:provider/provider.dart';

class ChangePasswordNotifier extends BaseChangeNotifier {
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  LoginTokenUserResponse? user;

  final formKey = GlobalKey<FormState>();

  ChangePasswordNotifier(BuildContext context) {
    newPasswordController.addListener(() {
      notifyListeners(); // Notifies UI of password change
    });

    user = Provider.of<CommonNotifier>(context, listen: false).user;

    emailAddressController.text = user?.email ?? "";
  }
  
  void saveButtonFunctionality(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      await apiChangePassword(context);
    }
  }


  Future<void> apiChangePassword(BuildContext context) async {
    AuthRepository().apiUpdatePassword(UpdatePasswordRequest(
        sEmail: emailAddressController.text,
        sOldPassword: currentPasswordController.text,
        sPassword: newPasswordController.text), context);
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    super.dispose();
  }
}
