class BaseResponse {
  dynamic result;
  List? error;
  int? success;

  BaseResponse({this.result, this.error, this.success});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      result: json['result'] != null ? json['result'] : null,
      error: json['error'] != null
          ? (json['error'] as List).map((i) => i).toList()
          : null,
      success: json['success'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = new Map<String, dynamic>();
    result['success'] = this.success;
    if (this.result != null) {
      result['result'] = this.result.toJson();
    }

    if (this.error != null) {
      result['error'] = this.error!.map((v) => v).toList();
    }
    return result;
  }
}
