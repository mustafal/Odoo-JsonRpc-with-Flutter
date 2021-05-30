import 'package:get/get.dart';
import 'package:odoo_common_code_latest/src/authentication/controllers/signin_controller.dart';

class Dependencies {
  Dependencies._();

  static void injectDependencies() {
    Get.put(SignInController());
  }
}
