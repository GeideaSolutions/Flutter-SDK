import 'package:geideapay/api/response/authentication_api_response.dart';

abstract class AuthenticationServiceContract {
  Future<AuthenticationApiResponse> initiateAuthentication(
      Map<String, Object?>? fields,
      String publicKey,
      String apiPassword,
      String baseUrl);

  Future<AuthenticationApiResponse> authenticatePayer(
      Map<String, Object?>? fields,
      String publicKey,
      String apiPassword,
      String baseUrl);
}
