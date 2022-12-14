import 'package:geideapay/api/request/base/base_request_body.dart';

class Address {

  String? countryCode, street, city, postCode;

  Address({this.countryCode, this.street, this.city, this.postCode});

  Address.fromMap(Map<String, dynamic> map) {
    countryCode = map['countryCode'];
    street = map['street'];
    city = map['city'];
    postCode = map['postCode'];
  }

  @override
  String toString() {
    return 'BillingAddress{countryCode: $countryCode, street: $street, city: $city, postCode: $postCode}';
  }

  bool isempty()
  {
    return countryCode == null || (countryCode!).isEmpty || street == null || (street!).isEmpty || city == null || (city!).isEmpty;
  }

  Map<String, dynamic>? toMap() {
    Map<String, Object?> addressParams = {};
    addressParams[BaseRequestBody.fieldCountryCode] = countryCode;
    addressParams[BaseRequestBody.fieldStreet] = street;
    addressParams[BaseRequestBody.fieldCity] = city;
    addressParams[BaseRequestBody.fieldPostCode] = postCode;

    return addressParams;
  }
}