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
      runWithLoadingVoid(() => apiChangePassword(context));
    }
  }

  Future<void> apiChangePassword(BuildContext context) async {
    try {
      await AuthRepository().apiUpdatePassword(
        UpdatePasswordRequest(
          sEmail: emailAddressController.text,
          sOldPassword: currentPasswordController.text,
          sPassword: newPasswordController.text,
        ),
        context,
      );
      // Optionally notify success here, or handle response
    } catch (e) {
      // Handle errors here, e.g., show Toast or dialog
      debugPrint('Error changing password: $e');
    }
  }

  @override
  void dispose() {
    emailAddressController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
