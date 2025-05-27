import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/screens/delete_account/delete_account_notifier.dart';
import 'package:mofa/utils/common/widgets/common_app_bar.dart';
import 'package:mofa/utils/common/widgets/common_drawer.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeleteAccountNotifier(),
      child: Consumer<DeleteAccountNotifier>(
        builder: (context, deleteAccountNotifier, child) {
          return buildBody(context, deleteAccountNotifier);
        },
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
    DeleteAccountNotifier deleteAccountNotifier,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(),
      drawer: CommonDrawer(),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(25.w),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            ],
          ),
        ),
        ),
      ),
    );
  }
}
