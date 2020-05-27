import 'odoo_response.dart';

class OdooVersion {
  var _version, _server_serie, _protocol_version;
  var _major, _minor, _micro, _release_level, _serial;
  bool _isEnterprise = false;

  String getVersionInfo() {
    return _version;
  }

  int getServerSerie() {
    return _server_serie;
  }

  int getProtocolVersion() {
    return _protocol_version;
  }

  dynamic getMajorVersion() {
    return _major;
  }

  int getMinorVersion() {
    return _minor;
  }

  int getMicroVersion() {
    return _micro;
  }

  String getReleaseLevel() {
    return _release_level;
  }

  String getSerial() {
    return _serial;
  }

  bool isEnterprise() {
    return _isEnterprise;
  }

  OdooVersion parse(OdooResponse response) {
    Map result = response.getResult();
    _version = result['server_version'];
    _server_serie = result['server_serie'];
    _protocol_version = result['protocol_version'];
    List<dynamic> version_info = result['server_version_info'];
    if (version_info.length == 6) {
      _isEnterprise = version_info.last == "e";
    }
    _major = version_info[0];
    _minor = version_info[1];
    _micro = version_info[2];
    _release_level = version_info[3];
    _serial = version_info[4];
    return this;
  }

  @override
  String toString() {
    if (_version != null) {
      return "${_version} (${_isEnterprise ? 'Enterprise' : 'Community'})";
    }
    return "Not Connected: Please call connect() or getVersionInfo() with callback.";
  }
}
