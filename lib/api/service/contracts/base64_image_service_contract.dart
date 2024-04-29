import 'package:geideapay/api/response/base64_image_api_response.dart';

abstract class Base64ImageServiceContract {
  Future<Base64ImageApiResponse> generateImage(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl);
}
