import 'dart:async';

import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/api/request/base/post_pay_operation_request_body.dart';
import 'package:geideapay/common/card_utils.dart';

class RefundRequestBody extends PostPayOperationRequestBody {
  String? callbackUrl1, reason1;
  RefundRequestBody(String orderId, {this.callbackUrl1, this.reason1}):
        super(orderId, callbackUrl: callbackUrl1, reason: reason1);
}
