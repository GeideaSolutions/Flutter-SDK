import 'dart:async';

import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/api/request/base/post_pay_operation_request_body.dart';
import 'package:geideapay/common/card_utils.dart';

class CancelRequestBody extends PostPayOperationRequestBody {
  String? callbackUrl_, reason_;
  CancelRequestBody(String orderId, this.reason_, {this.callbackUrl_}):
        super(orderId, callbackUrl: callbackUrl_, reason: reason_);

}
