class DeviceIdentification {
  final String? providerDeviceId;
  final String? language;
  final String? userAgent;

  DeviceIdentification(
      {this.providerDeviceId, this.language, this.userAgent = "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36"});

  Map<String, dynamic>? toMap() {
    Map<String, Object?> params = {};
    params["providerDeviceId"] = providerDeviceId;
    params["language"] = language;
    params["userAgent"] = userAgent;
    return params;
  }
}
