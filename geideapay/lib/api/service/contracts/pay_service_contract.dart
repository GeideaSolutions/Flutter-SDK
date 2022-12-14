import 'package:geideapay/api/response/order_api_response.dart';

abstract class PayServiceContract {

  Future<OrderApiResponse> directPay(
      Map<String, Object?>? fields, String publicKey, String apiPassword);

  Future<OrderApiResponse> payWithToken(
      Map<String, Object?>? fields, String publicKey, String apiPassword);


  Future<OrderApiResponse> capture(
      Map<String, Object?>? fields, String publicKey, String apiPassword);

  Future<OrderApiResponse> refund(
      Map<String, Object?>? fields, String publicKey, String apiPassword);

  Future<OrderApiResponse> cancel(
      Map<String, Object?>? fields, String publicKey, String apiPassword);

  Future<OrderApiResponse> voidOperation(
      Map<String, Object?>? fields, String publicKey, String apiPassword);
}
