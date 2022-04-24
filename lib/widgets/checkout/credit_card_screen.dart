import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geideapay/common/card_utils.dart';
import 'package:geideapay/geideapay.dart';
import 'package:geideapay/widgets/checkout/checkout_options.dart';

import 'package:geideapay/widgets/checkout/flutter_credit_card.dart';
import 'package:geideapay/widgets/checkout/credit_card_brand.dart';
import 'package:geideapay/widgets/checkout/credit_card_form.dart';
import 'package:geideapay/widgets/checkout/credit_card_model.dart';
import 'package:geideapay/widgets/checkout/credit_card_widget.dart' as credit_card_widget;

class CreditCardScreen extends StatefulWidget {

  late PaymentCard paymentCard = PaymentCard.empty();
  late bool saveCard = false;
  CheckoutOptions checkoutOptions;
  CreditCardScreen({Key? key, required this.checkoutOptions}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreditCardScreenState();
  }
}

class CreditCardScreenState extends State<CreditCardScreen> {

  bool isCvvFocused = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: widget.checkoutOptions.backgroundColor,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              CreditCardWidget(
                glassmorphismConfig: null,
                cardNumber: widget.paymentCard.number,
                expiryYear: widget.paymentCard.expiryYear,
                expiryMonth: widget.paymentCard.expiryMonth,
                cardHolderName: widget.paymentCard.name,
                cvvCode: widget.paymentCard.cvc,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                cardBgColor: widget.checkoutOptions.cardColor!,
                backgroundImage:
                useBackgroundImage ? 'assets/card_bg.png' : null,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                customCardTypeIcons: <CustomCardTypeIcon>[
                  CustomCardTypeIcon(
                    cardType: credit_card_widget.CardType.mastercard,
                    cardImage: Image.asset(
                      'assets/mastercard.png',
                      height: 48,
                      width: 48,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: widget.paymentCard.number,
                        cvvCode: widget.paymentCard.cvc,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: widget.paymentCard.name,
                        expiryYear: widget.paymentCard.expiryYear,
                        expiryMonth: widget.paymentCard.expiryMonth,
                        themeColor: Colors.blue,
                        textColor: Colors.white,
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                          hintStyle: TextStyle(color: widget.checkoutOptions.textColor),
                          labelStyle: TextStyle(color: widget.checkoutOptions.textColor),
                          focusedBorder: border,
                          enabledBorder: border,
                        ),
                        expiryDateDecoration: InputDecoration(
                          hintStyle: TextStyle(color: widget.checkoutOptions.textColor),
                          labelStyle: TextStyle(color: widget.checkoutOptions.textColor),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          hintStyle: TextStyle(color: widget.checkoutOptions.textColor),
                          labelStyle: TextStyle(color: widget.checkoutOptions.textColor),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          hintStyle: TextStyle(color: widget.checkoutOptions.textColor),
                          labelStyle: TextStyle(color: widget.checkoutOptions.textColor),
                          focusedBorder: border,
                          enabledBorder: border,
                          labelText: 'Card Holder',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Save card?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Switch(
                            value: widget.saveCard,
                            inactiveTrackColor: Colors.grey,
                            activeColor: Colors.white,
                            activeTrackColor: Colors.green,
                            onChanged: (bool value) => setState(() {
                              widget.saveCard = value;
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                primary: widget.checkoutOptions.payButtonColor,
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(12),
                                child: Text(
                                  'Pay ' + widget.checkoutOptions.amount
                                      + ' '
                                      + (widget.checkoutOptions.currency != null ? widget.checkoutOptions.currency!: ''),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  print('valid!');
                                  Navigator.pop(context, 'OK');
                                } else {
                                  print('invalid!');
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                primary: widget.checkoutOptions.cancelButtonColor,
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(12),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context, 'CANCEL');
                              },
                            ),
                          ),
                        ],
                      ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          image: AssetImage('assets/logo.png', package: 'geideapay'),
                        width: 30,
                        fit: BoxFit.fill),
                      Text(
                        'Powered by Geidea',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      widget.paymentCard.number = creditCardModel!.cardNumber;
      List<int> expiryDate = CardUtils.getExpiryDate(creditCardModel.expiryDate);
      widget.paymentCard.expiryMonth = expiryDate[0];
      widget.paymentCard.expiryYear = expiryDate[1];
      widget.paymentCard.name = creditCardModel.cardHolderName;
      widget.paymentCard.cvc = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}