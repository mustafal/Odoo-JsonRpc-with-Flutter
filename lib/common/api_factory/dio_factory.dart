import 'dart:developer' show log;
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:odoo_common_code_latest/common/api_factory/api.dart';
import 'package:odoo_common_code_latest/common/config/config.dart';

typedef void OnError(String error, Map<String, dynamic> data);
typedef void OnResponse<T>(T response);

class DioFactory {
  static final _singleton = DioFactory._instance();

  static Dio? get dio => _singleton._dio;
  static var _deviceName = 'Generic Device';
  static var _authorization = '';

  static Future<bool> computeDeviceInfo() async {
    if (Platform.isAndroid || Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _deviceName = '${androidInfo.brand} ${androidInfo.model}';
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _deviceName = iosInfo.utsname.machine;
      }
    } else if (Platform.isFuchsia) {
      _deviceName = 'Generic Fuchsia Device';
    } else if (Platform.isLinux) {
      _deviceName = 'Generic Linux Device';
    } else if (Platform.isMacOS) {
      _deviceName = 'Generic Macintosh Device';
    } else if (Platform.isWindows) {
      _deviceName = 'Generic Windows Device';
    }

    return true;
  }

  static void initialiseHeaders(String token) {
    _authorization = token;
    _singleton._dio!.options.headers[HttpHeaders.cookieHeader] = _authorization;
  }

  static void initFCMToken(String token) {
    var _token = token;
    _singleton._dio!.options.headers["device_id"] = _token;
  }

  Dio? _dio;

  DioFactory._instance() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEnvironment.Dev.endpoint,
        headers: {
          HttpHeaders.userAgentHeader: _deviceName,
          HttpHeaders.authorizationHeader: _authorization,
          'Keep-Alive': Config.timeout,
        },
        connectTimeout: Config.timeout,
        receiveTimeout: Config.timeout,
        sendTimeout: Config.timeout,
        contentType: Headers.jsonContentType,
      ),
    );
    if (!kReleaseMode) {
      _dio!.interceptors.add(LogInterceptor(
        request: Config.logNetworkRequest,
        requestHeader: Config.logNetworkRequestHeader,
        requestBody: Config.logNetworkRequestBody,
        responseHeader: Config.logNetworkResponseHeader,
        responseBody: Config.logNetworkResponseBody,
        error: Config.logNetworkError,
        logPrint: (Object object) {
          log(object.toString(), name: 'dio');
        },
      ));
    }
    if (Config.selfSignedCert) {
      final httpClientAdapter =
          _dio!.httpClientAdapter as DefaultHttpClientAdapter;
      httpClientAdapter.onHttpClientCreate = _onHttpClientCreate;
    }
  }

  dynamic _onHttpClientCreate(HttpClient client) {
    client.badCertificateCallback = _badCertificateCallback;
  }

  bool _badCertificateCallback(X509Certificate cert, String host, int port) {
    return true;
  }
}
