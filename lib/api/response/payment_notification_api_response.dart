class PaymentNotificationApiResponse {
  String? type;
  String? title;
  int? status;
  String? traceId;
  String? errors;

  PaymentNotificationApiResponse(
      {this.type, this.title, this.status, this.traceId, this.errors});

  PaymentNotificationApiResponse.unknownServerResponse() {
    status = 100;
    title = 'Unknown server response';
  }

  PaymentNotificationApiResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    status = json['status'];
    traceId = json['traceId'];
    errors = json['errors'].toString();
  }

  @override
  String toString() {
    return 'PaymentNotificationApiResponse${toJson()}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['title'] = title;
    data['status'] = status;
    data['traceId'] = traceId;
    data['errors'] = errors;
    return data;
  }
}
