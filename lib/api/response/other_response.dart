class OtherResponse {
  String? type;
  String? title;
  int? status;
  String? traceId;
  Object? errors;

  OtherResponse({
    this.type,
    this.title,
    this.status,
    this.traceId,
    this.errors,
  });

  OtherResponse.fromMap(Map<String, dynamic> map) {
    type = map['type'];
    title = map['title'];
    status = map['status'];
    traceId = map['traceId'];
    errors = map['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    data['title'] = title;
    data['status'] = status;
    data['traceId'] = traceId;
    data['errors'] = errors;
    return data;
  }
}
