import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:odoo_common_code_latest/common/api_factory/api_end_points.dart';
import 'package:odoo_common_code_latest/common/api_factory/dio_factory.dart';
import 'package:uuid/uuid.dart';
import 'package:odoo_common_code_latest/common/config/prefs/pref_utils.dart';
import 'package:odoo_common_code_latest/common/utils/utils.dart';
import 'package:odoo_common_code_latest/common/widgets/log.dart';
import 'package:odoo_common_code_latest/src/authentication/models/user_model.dart';
import 'package:odoo_common_code_latest/common/api_factory/models/version_info_response.dart';
import 'package:odoo_common_code_latest/common/config/config.dart';

enum ApiEnvironment { UAT, Dev, Prod }

extension APIEnvi on ApiEnvironment {
  String get endpoint {
    switch (this) {
      case ApiEnvironment.UAT:
        return Config.OdooUATURL;
      case ApiEnvironment.Dev:
        return Config.OdooDevURL;
      case ApiEnvironment.Prod:
        return Config.OdooProdURL;
    }
  }
}

enum HttpMethod { delete, get, patch, post, put }

extension HttpMethods on HttpMethod {
  String get value {
    switch (this) {
      case HttpMethod.delete:
        return 'DELETE';
      case HttpMethod.get:
        return 'GET';
      case HttpMethod.patch:
        return 'PATCH';
      case HttpMethod.post:
        return 'POST';
      case HttpMethod.put:
        return 'PUT';
    }
  }
}

class Api {
  Api._();

  static final catchError = _catchError;

  static void _catchError(e, stackTrace, OnError onError) {
    if (!kReleaseMode) {
      print(e);
    }
    if (e is DioError) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.other) {
        onError('Server unreachable', {});
      } else if (e.type == DioErrorType.response) {
        final response = e.response;
        if (response != null) {
          final data = response.data;
          if (data != null && data is Map<String, dynamic>) {
            showSessionDialog();
            onError('Failed to get response: ${e.message}', data);
            return;
          }
        }
        onError('Failed to get response: ${e.message}', {});
      } else {
        onError('Request cancelled', {});
      }
    } else {
      onError(e?.toString() ?? 'Unknown error occurred', {});
    }
  }

  //General Post Request
  static Future<void> request(
      {required HttpMethod method,
      required String path,
      required Map params,
      required OnResponse onResponse,
      required OnError onError}) async {
    Future.delayed(Duration(microseconds: 1), () {
      if (path != ApiEndPoints.getVersionInfo &&
          path != ApiEndPoints.getDb &&
          path != ApiEndPoints.getDb9 &&
          path != ApiEndPoints.getDb10) showLoading();
    });

    Response response;
    switch (method) {
      case HttpMethod.post:
        response = await DioFactory.dio!
            .post(
              path,
              data: params,
            )
            .catchError((e, stackTrace) => _catchError(e, stackTrace, onError));
        break;
      case HttpMethod.delete:
        response = await DioFactory.dio!
            .delete(
              path,
              data: params,
            )
            .catchError((e, stackTrace) => _catchError(e, stackTrace, onError));
        break;
      case HttpMethod.get:
        response = await DioFactory.dio!
            .get(
              path,
            )
            .catchError((e, stackTrace) => _catchError(e, stackTrace, onError));
        break;
      case HttpMethod.patch:
        response = await DioFactory.dio!
            .patch(
              path,
              data: params,
            )
            .catchError((e, stackTrace) => _catchError(e, stackTrace, onError));
        break;
      case HttpMethod.put:
        response = await DioFactory.dio!
            .put(
              path,
              data: params,
            )
            .catchError((e, stackTrace) => _catchError(e, stackTrace, onError));
        break;
    }

    hideLoading();
    if (response.data["success"] == 0) {
      onError(response.data["error"][0], {});
    } else {
      onResponse(response.data["result"]);
    }

    if (path == ApiEndPoints.authenticate) {
      _updateCookies(response.headers);
    }
  }

  static _updateCookies(Headers headers) async {
    Log("Inside Update Cookie");
    String? rawCookie = headers.value("set-cookie");
    Log(rawCookie);
    if (rawCookie != null) {
      DioFactory.initialiseHeaders(rawCookie);
      PrefUtils.setToken(rawCookie);
    }
  }

  static getSessionInfo({
    required OnResponse onResponse,
    required OnError onError,
  }) {
    request(
      method: HttpMethod.post,
      path: ApiEndPoints.getSessionInfo,
      params: createPayload({}),
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  static destroy({
    required OnResponse onResponse,
    required OnError onError,
  }) {
    request(
      method: HttpMethod.post,
      path: ApiEndPoints.destroy,
      params: createPayload({}),
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  // Authenticate user
  static authenticate({
    required String username,
    required String password,
    required String database,
    required OnResponse<UserModel> onResponse,
    required OnError onError,
  }) {
    var params = {
      "db": database,
      "login": username,
      "password": password,
      "context": {}
    };

    request(
      method: HttpMethod.post,
      path: ApiEndPoints.authenticate,
      params: createPayload(params),
      onResponse: (response) {
        onResponse(UserModel.fromJson(response));
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  static read({
    required String model,
    required List<int> ids,
    required List<String> fields,
    dynamic kwargs,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    callKW(
        model: model,
        method: "read",
        args: [ids, fields],
        kwargs: kwargs ?? null,
        onResponse: onResponse,
        onError: onError);
  }

  static searchRead({
    required String model,
    required List domain,
    required List<String> fields,
    int offset = 0,
    int limit = 0,
    String order = "",
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    var params = {
      "context": getContext(),
      "domain": domain,
      "fields": fields,
      "limit": limit,
      "model": model,
      "offset": offset,
      "sort": order
    };
    request(
      method: HttpMethod.post,
      path: ApiEndPoints.searchRead,
      params: createPayload(params),
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  // Call any model method with arguments
  static callKW({
    required String model,
    required String method,
    required List args,
    dynamic kwargs,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    var params = {
      "model": model,
      "method": method,
      "args": args,
      "kwargs": kwargs ?? {},
      "context": getContext(),
    };
    request(
      method: HttpMethod.post,
      path: ApiEndPoints.getCallKWEndPoint(model, method),
      params: createPayload(params),
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  // Create new record for model
  static create({
    required String model,
    required Map values,
    dynamic kwargs,
    required OnResponse onResponse,
    required OnError onError,
  }) {
    callKW(
        model: model,
        method: "create",
        args: [values],
        kwargs: kwargs ?? null,
        onResponse: onResponse,
        onError: onError);
  }

  // Write record with ids and values
  static write({
    required String model,
    required List<int> ids,
    required Map values,
    required OnResponse onResponse,
    required OnError onError,
  }) {
    callKW(
        model: model,
        method: "write",
        args: [ids, values],
        onResponse: onResponse,
        onError: onError);
  }

  // Remove record from system
  static unlink({
    required String model,
    required List<int> ids,
    dynamic kwargs,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    callKW(
        model: model,
        method: "unlink",
        args: [ids],
        kwargs: kwargs ?? null,
        onResponse: onResponse,
        onError: onError);
  }

  // Call json controller
  static callController({
    required String path,
    required Map params,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    request(
      method: HttpMethod.post,
      path: path,
      params: createPayload(params),
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  // get version of odoo
  static getVersionInfo({
    required OnResponse<VersionInfoResponse> onResponse,
    required OnError onError,
  }) {
    request(
      method: HttpMethod.post,
      path: ApiEndPoints.getVersionInfo,
      params: createPayload({}),
      onResponse: (response) {
        onResponse(VersionInfoResponse.fromJson(response));
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  static getDatabases({
    required int serverVersionNumber,
    required OnResponse onResponse,
    required OnError onError,
  }) async {
    var params = {};
    var endPoint = "";
    if (serverVersionNumber == 9) {
      params["method"] = "list";
      params["service"] = "db";
      params["args"] = [];
      endPoint = ApiEndPoints.getDb9;
    } else if (serverVersionNumber >= 10) {
      endPoint = ApiEndPoints.getDb10;
      params["context"] = {};
    } else {
      endPoint = ApiEndPoints.getDb;
      params["context"] = {};
    }
    request(
      method: HttpMethod.post,
      path: endPoint,
      params: createPayload(params),
      onResponse: (response) {
        onResponse(response);
      },
      onError: (error, data) {
        onError(error, {});
      },
    );
  }

  static hasRight({
    required String model,
    required List right,
    dynamic kwargs,
    required OnResponse onResponse,
    required OnError onError,
  }) {
    callKW(
        model: model,
        method: "has_group",
        args: right,
        kwargs: kwargs ?? null,
        onResponse: onResponse,
        onError: onError);
  }

  static Map createPayload(Map params) {
    return {
      "id": new Uuid().v1(),
      "jsonrpc": "2.0",
      "method": "call",
      "params": params,
    };
  }

  static Map getContext() {
    return {"lang": "en_US", "tz": "Europe/Brussels", "uid": Uuid().v1()};
  }
}
