import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class Utils {
  static String getKeyErrorMsg(String keyType) {
    return 'Invalid $keyType key. You must use a valid $keyType key. Ensure that you '
        'have set a $keyType key. Check https://geideapay for more';
  }

  static String getPasswordErrorMsg(String passType) {
    return 'Invalid $passType. You must use a valid $passType. Ensure that you '
        'have set a $passType. Check https://geideapay for more';
  }

  static String getBaseUrlErrorMsg(String baseUrlType) {
    return 'Invalid $baseUrlType. You must use a valid $baseUrlType. Ensure that you '
        'have set a $baseUrlType. Check https://geideapay for more';
  }

  static NumberFormat? _currencyFormatter;

  static setCurrencyFormatter(String? currency, String? locale) =>
      _currencyFormatter =
          NumberFormat.currency(locale: locale, name: '$currency\u{0020}');

  static String formatAmount(num amountInBase) {
    if (_currencyFormatter == null) throw "Currency formatter not initialized.";
    return _currencyFormatter!.format((amountInBase / 100));
  }

  /// Add double spaces after every 4th character
  static String addSpaces(String text) {
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }
    return buffer.toString();
  }

  static String generateSignature(
    String merchantPublicKey,
    double orderAmount,
    String orderCurrency,
    String? orderMerchantReferenceId,
    String apiPassword,
    String? timestamp,
  ) {
    String amountStr = orderAmount.toStringAsFixed(2);

    String data =
        '$merchantPublicKey$amountStr$orderCurrency$orderMerchantReferenceId$timestamp';

    var hmacSha256 = Hmac(sha256, utf8.encode(apiPassword));
    var hash = hmacSha256.convert(utf8.encode(data));

    return base64.encode(hash.bytes);
  }

}
