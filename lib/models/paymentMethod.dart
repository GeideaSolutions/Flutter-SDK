import 'package:geideapay/models/expiryDate.dart';

class PaymentMethod {

  String? type, brand, cardholderName, maskedCardNumber, wallet;
  ExpiryDate? expiryDate;

  PaymentMethod(
      {this.type, this.brand, this.cardholderName, this.maskedCardNumber, this.expiryDate, this.wallet});


  PaymentMethod.fromMap(Map<String, dynamic> map) {
    type = map['type'];
    brand = map['brand'];
    cardholderName = map['cardholderName'];
    maskedCardNumber = map['maskedCardNumber'];
    expiryDate = ExpiryDate.fromMap(map['expiryDate']);
    wallet = map['wallet'];
  }

  @override
  String toString() {
    return 'PaymentMethod{type: $type, brand: $brand, cardholderName: $cardholderName, maskedCardNumber: $maskedCardNumber, expiryDate: $expiryDate, wallet: $wallet}';
  }

  @override
  Map<String, dynamic>? toMap() {
    return {
      "type": type,
      "brand": brand,
      "cardholderName": cardholderName,
      "maskedCardNumber": maskedCardNumber,
      "expiryDate": expiryDate?.toMap(),
      "wallet": wallet
    };
  }
}