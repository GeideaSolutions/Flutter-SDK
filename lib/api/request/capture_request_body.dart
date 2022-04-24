import 'dart:async';

import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/common/card_utils.dart';
import 'package:geideapay/api/request/base/post_pay_operation_request_body.dart';


class CaptureRequestBody extends PostPayOperationRequestBody {
  CaptureRequestBody(String orderId, String? callbackUrl,
      String? paymentIntentId)
      :super(orderId, callbackUrl: callbackUrl, paymentIntentId: paymentIntentId);
}
