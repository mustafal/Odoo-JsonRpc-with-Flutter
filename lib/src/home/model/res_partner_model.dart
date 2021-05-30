class ResPartnerModel {
  List<Records>? records;

  ResPartnerModel({this.records});

  ResPartnerModel.fromJson(dynamic json) {
    if (json["records"] != null) {
      records = [];
      json["records"].forEach((v) {
        records?.add(Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (records != null) {
      map["records"] = records?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Records {
  int? id;
  String? name;
  String? email;
  String? image512;

  Records({this.id, this.name, this.email, this.image512});

  Records.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    email = json["email"] is! bool ? json["email"] : "";
    image512 = json["image_512"] is! bool ? json["image_512"] : "";
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["email"] = email;
    map["image_512"] = image512;
    return map;
  }
}
