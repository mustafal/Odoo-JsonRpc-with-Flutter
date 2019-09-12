import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'odoo_response.dart';
import 'odoo_version.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Odoo {
  Odoo({String url}) {
    _serverURL = url;
  }

  http.Client _client = http.Client();
  String _serverURL;
  Map<String, String> _headers = {};
  OdooVersion version = new OdooVersion();
  String _sessionId;
  int _uid;

  String createPath(String path) {
    return _serverURL + path;
  }

  setSessionId(String session_id) {
    _sessionId = session_id;
  }

  initOdoo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("UserPrefs") != null) {
      var jsonPrefs = jsonDecode(preferences.getString("UserPrefs"));
      _serverURL = jsonPrefs['url'];
      authenticate(
          jsonPrefs['username'], jsonPrefs['password'], jsonPrefs['db']);
    }
  }

  Future<OdooResponse> getSessionInfo() async {
    var url = createPath("/web/session/get_session_info");
    return await callRequest(url, createPayload({}));
  }

  Future<OdooResponse> destroy() async {
    var url = createPath("/web/session/destroy");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final res = await callRequest(url, createPayload({}));
    prefs.remove("session");
    return res;
  }

  // Authenticate user
  Future<OdooResponse> authenticate(
      String username, String password, String database) async {
    var url = createPath("/web/session/authenticate");
    var params = {
      "db": database,
      "login": username,
      "password": password,
      "context": {}
    };
    final response = await callRequest(url, createPayload(params));
    return response;
  }

  Future<OdooResponse> read(String model, List<int> ids, List<String> fields,
      {dynamic kwargs, Map context}) async {
    return await callKW(model, "read", [ids, fields],
        kwargs: kwargs, context: context);
  }

  Future<OdooResponse> searchRead(
      String model, List domain, List<String> fields,
      {int offset = 0, int limit = 0, String order = ""}) async {
    var url = createPath("/web/dataset/search_read");
    var params = {
      "context": getContext(),
      "domain": domain,
      "fields": fields,
      "limit": limit,
      "model": model,
      "offset": offset,
      "sort": order
    };
    return await callRequest(url, createPayload(params));
  }

  // Call any model method with arguments
  Future<OdooResponse> callKW(String model, String method, List args,
      {dynamic kwargs, Map context}) async {
    kwargs = kwargs == null ? {} : kwargs;
    context = context == null ? {} : context;
    var url = createPath("/web/dataset/call_kw/" + model + "/" + method);
    var params = {
      "model": model,
      "method": method,
      "args": args,
      "kwargs": kwargs,
      "context": context
    };
    return await callRequest(url, createPayload(params));
  }

  // Create new record for model
  Future<OdooResponse> create(String model, Map values) async {
    return await callKW(model, "create", [values]);
  }

  // Write record with ids and values
  Future<OdooResponse> write(String model, List<int> ids, Map values) async {
    return await callKW(model, "write", [ids, values]);
  }

  // Remove record from system
  Future<OdooResponse> unlink(String model, List<int> ids) async {
    return await callKW(model, "unlink", [ids]);
  }

  // Call json controller
  Future<OdooResponse> callController(String path, Map params) async {
    return await callRequest(createPath(path), createPayload(params));
  }

  String getSessionId() {
    return _sessionId;
  }

  // connect to odoo and set version and databases
  Future<OdooVersion> connect() async {
    OdooVersion odooVersion = await getVersionInfo();
    return odooVersion;
  }

  // get version of odoo
  Future<OdooVersion> getVersionInfo() async {
    var url = createPath("/web/webclient/version_info");
    final response = await callRequest(url, createPayload({}));
    version = OdooVersion().parse(response);
    return version;
  }

  Future<http.Response> getDatabases() async {
    var serverVersionNumber = await getVersionInfo();

    if (serverVersionNumber.getMajorVersion() == null) {
      version = await getVersionInfo();
    }
    String url = getServerURL();
    var params = {};
    if (serverVersionNumber != null) {
      if (serverVersionNumber.getMajorVersion() == 9) {
        url = createPath("/jsonrpc");
        params["method"] = "list";
        params["service"] = "db";
        params["args"] = [];
      } else if (serverVersionNumber.getMajorVersion() >= 10) {
        url = createPath("/web/database/list");
        params["context"] = {};
      } else {
        url = createPath("/web/database/get_list");
        params["context"] = {};
      }
    }
    final response = await callDbRequest(url, createPayload(params));
    return response;
  }

  String getServerURL() {
    return _serverURL;
  }

  Map createPayload(Map params) {
    return {
      "id": new Uuid().v1(),
      "jsonrpc": "2.0",
      "method": "call",
      "params": params,
    };
  }

  Map getContext() {
    return {"lang": "en_US", "tz": "Europe/Brussels", "uid": _uid};
  }

  Future<OdooResponse> callRequest(String url, Map payload) async {
    var body = json.encode(payload);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _headers["Content-type"] = "application/json; charset=UTF-8";
    _headers["Cookie"] = prefs.getString("session");
    /*print("------------------------------------------->>>");
    print("REQUEST: ${url}");
    print("PAYLOD : ${payload}");
    print("HEADERS: ${_headers}");
    print("------------------------------------------->>>");*/
    final response = await _client.post(url, body: body, headers: _headers);
    _updateCookies(response);
    /*print("<<<<============================================");
    print("STATUS_C: ${response.statusCode}");
    print("RESPONSE HEADERS : ${response.headers}");
    print("RESPONSE: ${response.body}");
    print("<<<<============================================");*/
    return new OdooResponse(json.decode(response.body), response.statusCode);
  }

  Future<http.Response> callDbRequest(String url, Map payload) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = json.encode(payload);
    _headers["Content-type"] = "application/json; charset=UTF-8";
    _headers["Cookie"] = prefs.getString("session");
/*
    print("-------callDummyRequest-----sessionId-------$_sessionId");
    print("------------------------------------------->>>>");
    print("REQUEST: $url");
    print("PAYLOD : $payload");
    print("HEADERS: $_headers");
    print("------------------------------------------->>>>");*/
    final response = await _client.post(url, body: body, headers: _headers);
    _updateCookies(response);

    /* print("<<<<============================================");
    print("STATUS_C: ${response.statusCode}");
    print("RESPONSE: ${response.body}");
    print("RESPONSE HEADERS : ${response.headers}");
    print("<<<<============================================");
*/
    return response;
  }

  _updateCookies(http.Response response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      _headers['Cookie'] = rawCookie;
      prefs.setString("session", rawCookie);
    }
  }

  Future<http.Response> check() {
    var url = createPath("/web/session/check");
    final res = callDbRequest(url, createPayload({}));
    return res;
  }

  Future<OdooResponse> hasRight(String model, List right) {
    var url = createPath("/web/dataset/call_kw");
    var params = {
      "model": model,
      "method": "has_group",
      "args": right,
      "kwargs": {},
      "context": getContext()
    };
    final res = callRequest(url, createPayload(params));
    return res;
  }
}
