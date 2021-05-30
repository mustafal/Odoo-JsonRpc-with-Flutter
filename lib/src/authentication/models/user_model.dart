class UserModel {
  UserModel({
    this.uid,
    this.isAdmin,
    this.db,
    this.serverVersion,
    this.name,
    this.username,
    this.partnerDisplayName,
    this.companyId,
    this.partnerId,
    this.webBaseUrl,
    this.showEffect,
    this.displaySwitchCompanyMenu,
    this.maxTimeBetweenKeysInMs,
    this.outOfOfficeMessage,
  });

  int? uid;
  bool? isAdmin;
  String? db;
  String? serverVersion;
  String? name;
  String? username;
  String? partnerDisplayName;
  int? companyId;
  int? partnerId;
  String? webBaseUrl;
  String? showEffect;
  bool? displaySwitchCompanyMenu;
  int? maxTimeBetweenKeysInMs;
  bool? outOfOfficeMessage;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        isAdmin: json["is_admin"],
        db: json["db"],
        serverVersion: json["server_version"],
        name: json["name"],
        username: json["username"],
        partnerDisplayName: json["partner_display_name"],
        companyId: json["company_id"],
        partnerId: json["partner_id"],
        webBaseUrl: json["web.base.url"],
        showEffect: json["show_effect"],
        displaySwitchCompanyMenu: json["display_switch_company_menu"],
        maxTimeBetweenKeysInMs: json["max_time_between_keys_in_ms"],
        outOfOfficeMessage: json["out_of_office_message"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "is_admin": isAdmin,
        "db": db,
        "server_version": serverVersion,
        "name": name,
        "username": username,
        "partner_display_name": partnerDisplayName,
        "company_id": companyId,
        "partner_id": partnerId,
        "web.base.url": webBaseUrl,
        "show_effect": showEffect,
        "display_switch_company_menu": displaySwitchCompanyMenu,
        "max_time_between_keys_in_ms": maxTimeBetweenKeysInMs,
        "out_of_office_message": outOfOfficeMessage,
      };
}

class Currency {
  Currency({
    this.symbol,
    this.position,
    this.digits,
  });

  String? symbol;
  String? position;
  List<int>? digits;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        symbol: json["symbol"],
        position: json["position"],
        digits: List<int>.from(json["digits"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "position": position,
        "digits": List<dynamic>.from(digits!.map((x) => x)),
      };
}

