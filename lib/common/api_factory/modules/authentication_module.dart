import 'dart:convert';
import 'package:get/get.dart';
import 'package:odoo_common_code_latest/common/api_factory/api.dart';
import 'package:odoo_common_code_latest/common/config/config.dart';
import 'package:odoo_common_code_latest/common/config/prefs/pref_utils.dart';
import 'package:odoo_common_code_latest/common/utils/utils.dart';
import 'package:odoo_common_code_latest/common/widgets/log.dart';
import 'package:odoo_common_code_latest/src/authentication/controllers/signin_controller.dart';
import 'package:odoo_common_code_latest/src/authentication/models/user_model.dart';
import 'package:odoo_common_code_latest/src/authentication/views/signin.dart';
import 'package:odoo_common_code_latest/src/home/view/home.dart';

getVersionInfoAPI() {
  Api.getVersionInfo(
    onResponse: (response) {
      Api.getDatabases(
        serverVersionNumber: response.serverVersionInfo![0],
        onResponse: (response) {
          Log(response);
          Config.DB = response[0];
        },
        onError: (error, data) {
          handleApiError(error);
        },
      );
    },
    onError: (error, data) {
      handleApiError(error);
    },
  );
}

authenticationAPI(String email, String pass) {
  Api.authenticate(
    username: email,
    password: pass,
    database: Config.DB,
    onResponse: (UserModel response) {
      currentUser.value = response;
      PrefUtils.setIsLoggedIn(true);
      PrefUtils.setUser(jsonEncode(response));
      Get.offAll(() => Home());
    },
    onError: (error, data) {
      handleApiError(error);
    },
  );
}

logoutApi() {
  Api.destroy(
    onResponse: (response) {
      PrefUtils.clearPrefs();
      Get.offAll(() => SignIn());
    },
    onError: (error, data) {
      handleApiError(error);
    },
  );
}
