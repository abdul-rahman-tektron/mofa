import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/forget_password/forget_password_request.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';

class DeleteAccountNotifier extends BaseChangeNotifier {
  final TextEditingController emailAddressController = TextEditingController();

  final formKey = GlobalKey<FormState>();


  //Delete Account Api call
  Future apiDeleteAccount(BuildContext context) async {
    await AuthRepository().apiDeleteAccount(ForgetPasswordRequest(sEmail: emailAddressController.text), context);
  }

}