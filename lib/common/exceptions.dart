import 'package:geideapay/common/my_strings.dart';

class GeideaException implements Exception {
  String? message;

  GeideaException(this.message);

  @override
  String toString() {
    if (message == null) return Strings.unKnownError;
    return message!;
  }
}

class PayException extends GeideaException {
  PayException(String message) : super(message);
}

class AuthenticationException extends GeideaException {
  AuthenticationException(String message) : super(message);
}

class CardException extends GeideaException {
  CardException(String message) : super(message);
}

class ChargeException extends GeideaException {
  ChargeException(String? message) : super(message);
}

class InvalidAmountException extends GeideaException {
  int amount = 0;

  InvalidAmountException(this.amount)
      : super('$amount is not a valid '
            'amount. only positive non-zero values are allowed.');
}

class InvalidEmailException extends GeideaException {
  String? email;

  InvalidEmailException(this.email) : super('$email  is not a valid email');
}

class GeideaSdkNotInitializedException extends GeideaException {
  GeideaSdkNotInitializedException(String message) : super(message);
}

class ProcessingException extends ChargeException {
  ProcessingException()
      : super(
            'A transaction is currently processing, please wait till it concludes before attempting a new charge.');
}
