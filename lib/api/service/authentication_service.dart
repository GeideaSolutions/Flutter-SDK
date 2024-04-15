import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:geideapay/api/response/authentication_api_response.dart';
import 'package:geideapay/api/service/base_service.dart';
import 'package:geideapay/api/service/contracts/authentication_service_contract.dart';
import 'package:geideapay/common/exceptions.dart';
import 'package:geideapay/common/my_strings.dart';
import 'package:geideapay/common/extensions.dart';
import 'package:http/http.dart' as http;

class AuthenticationService
    with BaseApiService
    implements AuthenticationServiceContract {
  @override
  Future<AuthenticationApiResponse> initiateAuthentication(
      Map<String, Object?>? fields,
      String publicKey,
      String apiPassword,
      String baseUrl) async {
    genHeaders(publicKey, apiPassword);
    var url = '$baseUrl/pgw/api/v6/direct/authenticate/initiate';

    http.Response response = await http.post(url.toUri(),
        body: jsonEncode(fields), headers: headers);
    var body = response.body;

    var statusCode = response.statusCode;

    switch (statusCode) {
      case HttpStatus.ok:
        Map<String, dynamic> responseBody = json.decode(body);
        return AuthenticationApiResponse.fromMap(responseBody);
      case HttpStatus.gatewayTimeout:
        throw AuthenticationException('Gateway timeout error');
      default:
        throw AuthenticationException(Strings.unKnownResponse);
    }
  }

  @override
  Future<AuthenticationApiResponse> authenticatePayer(
      Map<String, Object?>? fields,
      String publicKey,
      String apiPassword,
      String baseUrl) async {
    genHeaders(publicKey, apiPassword);
    var url = '$baseUrl/pgw/api/v6/direct/authenticate/payer';

    http.Response response = await http.post(url.toUri(),
        body: jsonEncode(fields), headers: headers);
    var body = response.body;

    var statusCode = response.statusCode;

    switch (statusCode) {
      case HttpStatus.ok:
        Map<String, dynamic> responseBody = json.decode(body);
        return AuthenticationApiResponse.fromMap(responseBody);
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
