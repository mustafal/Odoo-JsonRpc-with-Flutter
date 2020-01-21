class User {
  Result result;

  User({this.result});

  User.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String sessionId;
  int uid;
  bool isAdmin;
  UserContext userContext;
  String db;
  String serverVersion;
  String name;
  String username;
  String partnerDisplayName;
  int companyId;
  int partnerId;
  bool userCompanies;
  String webBaseUrl;
  bool odoobotInitialized;

  Result({
    this.sessionId,
    this.uid,
    this.isAdmin,
    this.userContext,
    this.db,
    this.serverVersion,
    this.name,
    this.username,
    this.partnerDisplayName,
    this.companyId,
    this.partnerId,
    this.userCompanies,
    this.webBaseUrl,
    this.odoobotInitialized,
  });

  Result.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
    uid = json['uid'];
    isAdmin = json['is_admin'];
    userContext = json['user_context'] != null
        ? new UserContext.fromJson(json['user_context'])
        : null;
    db = json['db'] is! bool ? json['db'] : "N/A";
    serverVersion =
        json['server_version'] is! bool ? json['server_version'] : "N/A";
    name = json['name'] is! bool ? json['name'] : "N/A";
    username = json['username'] is! bool ? json['username'] : "N/A";
    partnerDisplayName = json['partner_display_name'] is! bool
        ? json['partner_display_name']
        : "N/A";
    companyId = json['company_id'];
    partnerId = json['partner_id'];
    userCompanies = json['user_companies'];
    webBaseUrl = json['web.base.url'] is! bool ? json['web.base.url'] : "N/A";
    odoobotInitialized = json['odoobot_initialized'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['session_id'] = this.sessionId;
    data['uid'] = this.uid;
    data['is_admin'] = this.isAdmin;
    if (this.userContext != null) {
      data['user_context'] = this.userContext.toJson();
    }
    data['db'] = this.db;
    data['server_version'] = this.serverVersion;
    data['name'] = this.name;
    data['username'] = this.username;
    data['partner_display_name'] = this.partnerDisplayName;
    data['company_id'] = this.companyId;
    data['partner_id'] = this.partnerId;
    data['user_companies'] = this.userCompanies;
    data['web.base.url'] = this.webBaseUrl;
    data['odoobot_initialized'] = this.odoobotInitialized;
    return data;
  }
}

class UserContext {
  String lang;
  String tz;
  int uid;

  UserContext({this.lang, this.tz, this.uid});

  UserContext.fromJson(Map<String, dynamic> json) {
    lang = json['lang'] is! bool ? json['lang'] : "N/A";
    tz = json['tz'] is! bool ? json['tz'] : "N/A";
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lang'] = this.lang;
    data['tz'] = this.tz;
    data['uid'] = this.uid;
    return data;
  }
}
