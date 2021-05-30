import 'dart:convert';

VersionInfoResponse welcomeFromJson(String str) =>
    VersionInfoResponse.fromJson(json.decode(str));

String welcomeToJson(VersionInfoResponse data) => json.encode(data.toJson());

class VersionInfoResponse {
  VersionInfoResponse({
    this.serverVersion,
    this.serverVersionInfo,
    this.serverSerie,
    this.protocolVersion,
  });

  String? serverVersion;
  List<dynamic>? serverVersionInfo;
  String? serverSerie;
  int? protocolVersion;

  factory VersionInfoResponse.fromJson(Map<String, dynamic> json) =>
      VersionInfoResponse(
        serverVersion: json["server_version"] ?? '',
        serverVersionInfo:
            List<dynamic>.from(json["server_version_info"].map((x) => x)),
        serverSerie: json["server_serie"] ?? '',
        protocolVersion: json["protocol_version"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "server_version": serverVersion,
        "server_version_info":
            List<dynamic>.from(serverVersionInfo!.map((x) => x)),
        "server_serie": serverSerie,
        "protocol_version": protocolVersion,
      };
}
