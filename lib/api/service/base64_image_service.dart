import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:geideapay/api/response/base64_image_api_response.dart';
import 'package:geideapay/api/service/base_service.dart';
import 'package:geideapay/api/service/contracts/base64_image_service_contract.dart';
import 'package:geideapay/common/exceptions.dart';
import 'package:geideapay/common/my_strings.dart';
import 'package:geideapay/common/extensions.dart';
import 'package:http/http.dart' as http;

class Base64ImageService
    with BaseApiService
    implements Base64ImageServiceContract {
  @override
  Future<Base64ImageApiResponse> generateImage(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl) async {
    genHeaders(publicKey, apiPassword);
    var url = '$baseUrl/payment-intent/api/v1/direct/meezaPayment/image/base64';

    http.Response response = await http.post(url.toUri(),
        body: jsonEncode(fields), headers: headers);
    var body = response.body;

    var statusCode = response.statusCode;

    switch (statusCode) {
      case HttpStatus.ok:
        Map<String, dynamic> responseBody = json.decode(body);
        return Base64ImageApiResponse.fromMap(responseBody);
      case HttpStatus.gatewayTimeout:
        throw AuthenticationException('Gateway timeout error');
      case HttpStatus.badRequest:
        Map<String, dynamic> responseBody = json.decode(body);
        throw AuthenticationException(responseBody["title"]);

      default:
        throw AuthenticationException(Strings.unKnownResponse);
    }
  }
}
