abstract class BaseRequestBody {
  BaseRequestBody();

  static const String fieldAmount = "amount";
  static const String fieldCurrency = "currency";
  static const String fieldCardNumber = "cardNumber";
  static const String fieldCallbackUrl = "callbackUrl";
  static const String fieldReturnUrl = "returnUrl";
  static const String fieldCardOnFile = "cardOnFile";

  static const String fieldOrderId = "orderId";
  static const String fieldThreeDSecureId = "threeDSecureId";
  static const String fieldBrowser = "browser";
  static const String fieldPaymentMethod = "paymentMethod";
  static const String fieldCardholderName = "cardholderName";
  static const String fieldCvv = "cvv";
  static const String fieldExpiryDate = "expiryDate";
  static const String fieldMonth = "month";
  static const String fieldYear = "year";

  static const String fieldTokenId = "tokenId";
  static const String fieldInitiatedBy = "initiatedBy";
  static const String fieldAgreementId = "agreementId";

  static const String fieldReason = "Reason";

  static const String fieldMerchantReferenceID = "merchantReferenceID";

  static const String fieldPaymentOperation = "paymentOperation";
  static const String fieldBilling = "billingAddress";
  static const String fieldShipping = "shippingAddress";
  static const String fieldCustomerEmail = "customerEmail";
  static const String fieldPaymentIntentId = "paymentIntentId";

  static const String fieldCountryCode = "countryCode";
  static const String fieldStreet = "street";
  static const String fieldCity = "city";
  static const String fieldPostCode = "postCode";

  Map<String, Object?> paramsMap();
}
