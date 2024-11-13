import 'dart:convert';
import 'dart:io';

mixin BaseApiService {

  Map<String, String> headers = {};

  Map<String, String> genHeaders(String publicKey, String apiPassword)
  {
    headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      'authorization': 'Basic ${base64Encode(utf8.encode('$publicKey:$apiPassword'))}'
    };
    return headers;
  }
}
