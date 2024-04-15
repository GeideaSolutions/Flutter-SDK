import 'package:geideapay/api/request/base/base_request_body.dart';

class PayTokenRequestBody extends BaseRequestBody {

  final String _amount;
  final String? _currency;
  final String _tokenId;
  final String? _initiatedBy;
  final String? _agreementId;
  final String? callbackUrl;

  PayTokenRequestBody(this._amount, this._currency, this._tokenId,
      this._initiatedBy, this._agreementId,
      {this.callbackUrl});

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldTokenId] = _tokenId;
    params[BaseRequestBody.fieldAmount] = _amount;
    params[BaseRequestBody.fieldCurrency] = _currency;
    params[BaseRequestBody.fieldInitiatedBy] = _initiatedBy;
    params[BaseRequestBody.fieldAgreementId] = _agreementId;

    params[BaseRequestBody.fieldCallbackUrl] = callbackUrl;

    return params..removeWhere((key, value) => value == null || (value is String && value.isEmpty));
  }
  toString() {
    return 'PayTokenRequestBody{_amount: $_amount, _currency: $_currency, _tokenId: $_tokenId, _initiatedBy: $_initiatedBy, _agreementId: $_agreementId, callbackUrl: $callbackUrl}';
  }
  
}
