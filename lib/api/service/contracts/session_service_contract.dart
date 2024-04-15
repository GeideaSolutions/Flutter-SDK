import 'package:geideapay/api/response/direct_session_api_response.dart';

abstract class SessionServiceContract {
  Future<DirectSessionApiResponse> createSession(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl);
}
