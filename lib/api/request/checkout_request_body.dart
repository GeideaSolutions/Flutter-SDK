import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/api/request/direct_session_request_body.dart';
import 'package:geideapay/api/request/initiate_authentication_request_body.dart';
import 'package:geideapay/api/request/pay_direct_request_body.dart';
import 'package:geideapay/api/request/payer_authentication_request_body.dart';
import 'package:geideapay/common/utils.dart';
import 'package:geideapay/geideapay.dart';
import 'package:geideapay/models/address.dart';
import 'package:geideapay/models/appearance.dart';
import 'package:geideapay/models/deviceIdentification.dart';
import 'package:geideapay/models/session.dart';
import 'package:geideapay/widgets/checkout/checkout_options.dart';
import 'package:intl/intl.dart';

class CheckoutRequestBody extends BaseRequestBody {
  CheckoutOptions checkoutOptions;

  PaymentCard? _paymentCard;
  late double amount;
  late String currency;

  String? callbackUrl;
  String? returnUrl;
  String? merchantReferenceID;
  bool? cardOnFile;
  String? paymentOperation;
  Address? billingAddress;
  Address? shippingAddress;
  String? customerEmail;
  String? paymentIntentId;

  late DirectSessionRequestBody directSessionRequestBody;
  late InitiateAuthenticationRequestBody initiateAuthenticationRequestBody;
  late PayerAuthenticationRequestBody payerAuthenticationRequestBody;
  late PayDirectRequestBody payDirectRequestBody;

  Session? session;
  String? orderId;
  String? threeDSecureId;

  CheckoutRequestBody(this.checkoutOptions, this._paymentCard) {
    amount = checkoutOptions.amount;
    currency = checkoutOptions.currency.toString();
    callbackUrl = checkoutOptions.callbackUrl;
    returnUrl = checkoutOptions.returnUrl;
    merchantReferenceID = checkoutOptions.merchantReferenceID;
    cardOnFile = checkoutOptions.cardOnFile;
    paymentOperation = checkoutOptions.paymentOperation;
    billingAddress = checkoutOptions.billingAddress;
    shippingAddress = checkoutOptions.shippingAddress;
    customerEmail = checkoutOptions.customerEmail;
    paymentIntentId = checkoutOptions.paymentIntentId;

    // initiateAuthenticationRequestBody = InitiateAuthenticationRequestBody(
    //     amount, currency, _paymentCard!.number,
    //     callbackUrl: callbackUrl,
    //     returnUrl: returnUrl,
    //     cardOnFile: cardOnFile,
    //     merchantReferenceID: merchantReferenceID,
    //     paymentOperation: paymentOperation,
    //     billingAddress: billingAddress,
    //     shippingAddress: shippingAddress,
    //     customerEmail: customerEmail,
    //     paymentIntentId: paymentIntentId);
  }

  void updateDirectSessionRequestBody(String publicKey, String apiPassword) {
    String timeStamp =
        DateFormat('MM/dd/yyyy hh:mm:ss a').format(DateTime.now());

    directSessionRequestBody = DirectSessionRequestBody(
      amount,
      currency,
      timeStamp,
      merchantReferenceID.toString(),
      Utils.generateSignature(publicKey, amount, currency, merchantReferenceID,
          apiPassword, timeStamp),
      callbackUrl: callbackUrl,
      cardOnFile: cardOnFile,
      paymentIntentId: paymentIntentId,
      paymentOperation: paymentOperation,
      language: checkoutOptions.lang,
      appearance: Appearance(
        showEmail: checkoutOptions.showEmail,
        showAddress: checkoutOptions.showAddress,
      ),
    );
  }

  void updateInitiateAuthenticationRequestBody(Session? session) {
    this.session = session;

    initiateAuthenticationRequestBody = InitiateAuthenticationRequestBody(
      session?.id,
      _paymentCard?.number,
      returnUrl,
      amount: amount,
      currency: currency,
      callbackUrl: callbackUrl,
      cardOnFile: cardOnFile,
      merchantName: session?.customer,
      paymentOperation: paymentOperation,
      deviceIdentification: DeviceIdentification(
        language: checkoutOptions.lang,
      ),
      source: "MobileApp",
    );
  }

  void updatePayerAuthenticationRequestBody(String? orderId) {
    this.orderId = orderId;

    payerAuthenticationRequestBody = PayerAuthenticationRequestBody(
      session?.id,
      orderId,
      _paymentCard,
      DeviceIdentification(
        language: checkoutOptions.lang,
      ),
      -120,
      browser: "Flutter SDK",
      ReturnUrl: returnUrl,
      callbackUrl: callbackUrl,
      cardOnFile: cardOnFile,
      merchantName: session?.customer,
      paymentOperation: paymentOperation,
    );
  }

  void updatePayDirectRequestBody(String? threeDSecureId) {
    this.threeDSecureId = threeDSecureId;
    payDirectRequestBody = PayDirectRequestBody(
      session?.id,
      orderId,
      threeDSecureId,
      _paymentCard,
      returnUrl: returnUrl,
      paymentOperation: paymentOperation,
    );
  }

  Map<String, Object?> paramsInitiateAuthenticationMap() {
    return initiateAuthenticationRequestBody.paramsMap();
  }

  Map<String, Object?> paramsPayerAuthenticationMap() {
    return payerAuthenticationRequestBody.paramsMap();
  }

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldAmount] = amount;
    params[BaseRequestBody.fieldCurrency] = currency;
    //params[BaseRequestBody.fieldCardNumber] = _cardNumber;
    params[BaseRequestBody.fieldCallbackUrl] = callbackUrl;
    params[BaseRequestBody.fieldReturnUrl] = returnUrl;
    params[BaseRequestBody.fieldCardOnFile] = cardOnFile;
    params[BaseRequestBody.fieldMerchantReferenceID] = merchantReferenceID;
    params[BaseRequestBody.fieldPaymentOperation] = paymentOperation;

    if (billingAddress != null) {
      params[BaseRequestBody.fieldBilling] = billingAddress!.toMap();
    }

    if (shippingAddress != null) {
      params[BaseRequestBody.fieldShipping] = shippingAddress!.toMap();
    }

    params[BaseRequestBody.fieldCustomerEmail] = customerEmail;
    params[BaseRequestBody.fieldPaymentIntentId] = paymentIntentId;
    return params
      ..removeWhere(
          (key, value) => value == null || (value is String && value.isEmpty));
  }

  toString() {
    return 'CheckoutRequestBody{amount: $amount, currency: $currency, callbackUrl: $callbackUrl, returnUrl: $returnUrl, merchantReferenceID: $merchantReferenceID, cardOnFile: $cardOnFile, paymentOperation: $paymentOperation, billingAddress: $billingAddress, shippingAddress: $shippingAddress, customerEmail: $customerEmail, paymentIntentId: $paymentIntentId}';
  }
}
