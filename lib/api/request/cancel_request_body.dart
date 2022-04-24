import 'dart:async';

import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/api/request/base/post_pay_operation_request_body.dart';
import 'package:geideapay/common/card_utils.dart';

class CancelRequestBody extends PostPayOperationRequestBody {
  CancelRequestBody(String orderId,
      String? callbackUrl, String reason)
      :super(orderId, callbackUrl: callbackUrl, reason: reason);
}
