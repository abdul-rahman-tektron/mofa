import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/utils/common/enum_values.dart';

class StepperScreenArgs {
  final ApplyPassCategory category;
  final bool isUpdate;
  final int? id;

  StepperScreenArgs({required this.category, this.isUpdate = false, this.id});
}