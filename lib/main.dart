import 'package:flutter/material.dart';
import 'package:odoo_common_code_latest/common/api_factory/dio_factory.dart';
import 'package:odoo_common_code_latest/common/app.dart';
import 'package:odoo_common_code_latest/common/config/dependencies.dart';
import 'package:odoo_common_code_latest/common/config/prefs/pref_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Controller dependencies which we use throughout the app
  Dependencies.injectDependencies();

  DioFactory.initialiseHeaders(await PrefUtils.getToken());

  bool isLoggedIn = await PrefUtils.getIsLoggedIn();
  runApp(App(isLoggedIn));
}
