import 'package:flutter/widgets.dart';

class Config {
  Config._();

  ///Odoo URLs
  static const String OdooDevURL = "https://7983981-14-0-all.runbot36.odoo.com/";
  static const String OdooProdURL = "https://7983981-14-0-all.runbot36.odoo.com/";
  static const String OdooUATURL = "https://7983981-14-0-all.runbot36.odoo.com/";

  /// SelfSignedCert:
  static const selfSignedCert = false;

  /// API Config
  static const timeout = 60000;
  static const logNetworkRequest = true;
  static const logNetworkRequestHeader = true;
  static const logNetworkRequestBody = true;
  static const logNetworkResponseHeader = false;
  static const logNetworkResponseBody = true;
  static const logNetworkError = true;

  /// Localization Config
  static const supportedLocales = <Locale>[Locale('en', ''), Locale('pt', '')];

  /// Common Const
  static const actionLocale = 'locale';
  static const int SIGNUP = 0;
  static const int SIGNIN = 1;
  static const String CURRENCY_SYMBOL = "€";
  static String FCM_TOKEN = "";
  static String DB = "";
}
