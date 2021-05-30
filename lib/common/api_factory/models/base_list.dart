class BaseListModel {
  int? id;
  String? name;
  bool isSelected = false;

  BaseListModel({this.id, this.name, this.isSelected = false});

  factory BaseListModel.fromJson(Map<String, dynamic> json) {
    return BaseListModel(
      id: json['id'],
      name: json['name'],
      isSelected: false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
