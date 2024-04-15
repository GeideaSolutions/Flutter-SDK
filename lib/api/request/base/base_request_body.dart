abstract class BaseRequestBody {
  BaseRequestBody();

  static const String fieldAmount = "amount";
  static const String fieldCurrency = "currency";
  static const String fieldCardNumber = "cardNumber";
  static const String fieldCallbackUrl = "callbackUrl";
  static const String fieldReturnUrl = "returnUrl";
  static const String fieldCardOnFile = "cardOnFile";
  static const String fieldSessionId = "sessionId";

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

  static const String fieldTimestamp = "timestamp";
  static const String fieldSignature = "signature";
  static const String fieldLanguage = "language";
  static const String fieldAppearance = "appearance";

  static const String fieldShowEmail = "showEmail";
  static const String fieldShowAddress = "showAddress";
  static const String fieldShowPhone = "showPhone";
  static const String fieldReceiptPage = "receiptPage";
  static const String fieldUiMode = "uiMode";
  static const String fieldStyles = "styles";

  static const String fieldHideGeideaLogo = "hideGeideaLogo";

  static const String fieldMerchantName = "merchantName";
  static const String fieldIsSetPaymentMethodEnabled =
      "isSetPaymentMethodEnabled";
  static const String fieldIsCreateCustomerEnabled = "isCreateCustomerEnabled";
  static const String fieldRestrictPaymentMethods = "restrictPaymentMethods";
  static const String fieldSource = "source";
  static const String fieldReturnUrl2 = "ReturnUrl";
  static const String fieldDeviceIdentification = "deviceIdentification";
  static const String fieldCustomerPhoneNumber = "customerPhoneNumber";
  static const String fieldCustomerPhoneCountryCode =
      "customerPhoneCountryCode";
  static const String fieldJavaEnabled = "javaEnabled";
  static const String fieldJavaScriptEnabled = "javaScriptEnabled";
  static const String fieldTimeZone = "timeZone";

  Map<String, Object?> paramsMap();
}
