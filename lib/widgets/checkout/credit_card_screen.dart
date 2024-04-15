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
import 'package:geideapay/widgets/checkout/credit_card_widget.dart'
    as credit_card_widget;
import '../../common/credit_card_type_detector.dart';
import '../../models/address.dart';

const Map<CreditCardType, String?> CreditCardTypeIconAsset =
    <CreditCardType, String?>{
  CreditCardType.mada: 'icons/mada.png',
  CreditCardType.visa: 'icons/visa.png',
  CreditCardType.amex: 'icons/amex.png',
  CreditCardType.mastercard: 'icons/mastercard.png',
  CreditCardType.discover: 'icons/discover.png',
  CreditCardType.unknown: null,
};

class CreditCardScreen extends StatefulWidget {
  late PaymentCard paymentCard = PaymentCard.empty();
  late bool saveCard = false;
  CheckoutOptions checkoutOptions;
  final Function(PaymentCard)? onCardEditComplete;

  CreditCardScreen({
    Key? key,
    required this.checkoutOptions,
    this.onCardEditComplete,
  }) : super(key: key);

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
  bool _checkoutInProgress = false;

  var cardType;

  bool _shippingAddressSameAsBillingAddress = true;

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
    if (widget.checkoutOptions.lang == "en") {
      return buildCreditCardScreen_EN(context);
    } else {
      return buildCreditCardScreen_AR(context);
    }
  }

  Widget buildCreditCardScreen_EN(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              color: widget.checkoutOptions.backgroundColor,
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, top: 10),
                                child: Text("Payment",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            widget.checkoutOptions.textColor))),
                            CreditCardForm(
                              formKey: formKey,
                              obscureCvv: true,
                              obscureNumber: false,
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
                              onChange: cardNumberChange,
                              onCardEditComplete: () => widget
                                  .onCardEditComplete!(widget.paymentCard),
                              cardNumberDecoration: InputDecoration(
                                labelText: 'Number',
                                hintText: 'XXXX XXXX XXXX XXXX',
                                hintStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                labelStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                focusedBorder: border,
                                enabledBorder: border,
                                suffixIcon: (cardType != null &&
                                        CreditCardTypeIconAsset[cardType] !=
                                            null)
                                    ? Container(
                                        margin: const EdgeInsets.all(12),
                                        child: Image.asset(
                                          CreditCardTypeIconAsset[cardType]!,
                                          height: 32,
                                          width: 32,
                                          package: 'geideapay',
                                        ))
                                    : Icon(
                                        Icons.call_to_action_rounded,
                                        color: widget
                                            .checkoutOptions.backgroundColor,
                                      ),
                              ),
                              expiryDateDecoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                labelStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                focusedBorder: border,
                                enabledBorder: border,
                                labelText: 'Expired Date',
                                hintText: 'XX/XX',
                              ),
                              cvvCodeDecoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                labelStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                focusedBorder: border,
                                enabledBorder: border,
                                labelText: 'CVV',
                                hintText: 'XXX',
                              ),
                              cardHolderDecoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                labelStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                focusedBorder: border,
                                enabledBorder: border,
                                labelText: 'Card Holder',
                              ),
                              onCreditCardModelChange: onCreditCardModelChange,
                            ),
                            _customerEmailEN(),
                            const SizedBox(
                              height: 10,
                            ),
                            (widget.checkoutOptions.showSaveCard != null &&
                                    widget.checkoutOptions.showSaveCard!)
                                ? Row(
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
                                  )
                                : Container(),
                            const SizedBox(
                              height: 10,
                            ),
                            (widget.checkoutOptions.showAddress != null &&
                                    widget.checkoutOptions.showAddress!)
                                ? addressForm_EN(true)
                                : Container(),
                            (widget.checkoutOptions.showAddress != null &&
                                    widget.checkoutOptions.showAddress!)
                                ? _shippingAddressCheckBoxEN()
                                : Container(),
                            (!_shippingAddressSameAsBillingAddress)
                                ? addressForm_EN(false)
                                : Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      primary:
                                          widget.checkoutOptions.payButtonColor,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(12),
                                      child: Text(
                                        'Pay ' +
                                            widget.checkoutOptions.amount
                                                .toString() +
                                            ' ' +
                                            (widget.checkoutOptions.currency !=
                                                    null
                                                ? widget
                                                    .checkoutOptions.currency!
                                                : ''),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        print('valid!');
                                        setState(
                                            () => _checkoutInProgress = true);
                                        Future.delayed(
                                            const Duration(seconds: 8), () {
                                          if (_shippingAddressSameAsBillingAddress) {
                                            widget.checkoutOptions
                                                    .shippingAddress =
                                                widget.checkoutOptions
                                                    .billingAddress;
                                          }
                                          setState(() {
                                            _checkoutInProgress = false;
                                          });
                                          Navigator.pop(context, 'OK');
                                        });
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      primary: widget
                                          .checkoutOptions.cancelButtonColor,
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
                                    image: AssetImage('assets/logo.png',
                                        package: 'geideapay'),
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
            _checkoutInProgress
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container()
          ],
        ));
  }

  addressForm_EN(bool isBilling) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(isBilling ? "Billing address" : "Shipping address",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: widget.checkoutOptions.textColor))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                style: TextStyle(
                  color: widget.checkoutOptions.textColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Country Code',
                  labelText: 'Country Code',
                  focusedBorder: border,
                  enabledBorder: border,
                  hintStyle: TextStyle(color: widget.checkoutOptions.textColor),
                  labelStyle:
                      TextStyle(color: widget.checkoutOptions.textColor),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                initialValue: getAddressField(isBilling, "countryCode"),
                onChanged: (String? value) =>
                    setAddressField(isBilling, "countryCode", value!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                style: TextStyle(
                  color: widget.checkoutOptions.textColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Street name & number',
                  labelText: 'Street name & number',
                  focusedBorder: border,
                  enabledBorder: border,
                  hintStyle: TextStyle(color: widget.checkoutOptions.textColor),
                  labelStyle:
                      TextStyle(color: widget.checkoutOptions.textColor),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                initialValue: getAddressField(isBilling, "street"),
                onChanged: (String? value) =>
                    setAddressField(isBilling, "street", value!),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: TextFormField(
                      style: TextStyle(
                        color: widget.checkoutOptions.textColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'City',
                        labelText: 'City',
                        focusedBorder: border,
                        enabledBorder: border,
                        hintStyle:
                            TextStyle(color: widget.checkoutOptions.textColor),
                        labelStyle:
                            TextStyle(color: widget.checkoutOptions.textColor),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      initialValue: getAddressField(isBilling, "city"),
                      onChanged: (String? value) =>
                          setAddressField(isBilling, "city", value!),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: TextFormField(
                          style: TextStyle(
                            color: widget.checkoutOptions.textColor,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Postal',
                            labelText: 'Postal',
                            focusedBorder: border,
                            enabledBorder: border,
                            hintStyle: TextStyle(
                                color: widget.checkoutOptions.textColor),
                            labelStyle: TextStyle(
                                color: widget.checkoutOptions.textColor),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          initialValue: getAddressField(isBilling, "postCode"),
                          onChanged: (String? value) =>
                              setAddressField(isBilling, "postCode", value!),
                        ),
                      )),
                ],
              ),
            )
          ],
        ));
  }

  addressForm_AR(bool isBilling) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(isBilling ? "عنوان الدفع" : "عنوان الشحن",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: widget.checkoutOptions.textColor))),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    style: TextStyle(
                      color: widget.checkoutOptions.textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'الدوله',
                      labelText: 'الدوله',
                      focusedBorder: border,
                      enabledBorder: border,
                      hintStyle:
                          TextStyle(color: widget.checkoutOptions.textColor),
                      labelStyle:
                          TextStyle(color: widget.checkoutOptions.textColor),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    initialValue: getAddressField(isBilling, "countryCode"),
                    onChanged: (String? value) =>
                        setAddressField(isBilling, "countryCode", value!),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    style: TextStyle(
                      color: widget.checkoutOptions.textColor,
                    ),
                    decoration: InputDecoration(
                      hintText: 'الشارع و رقم المنزل',
                      labelText: 'الشارع و رقم المنزل',
                      focusedBorder: border,
                      enabledBorder: border,
                      hintStyle:
                          TextStyle(color: widget.checkoutOptions.textColor),
                      labelStyle:
                          TextStyle(color: widget.checkoutOptions.textColor),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    initialValue: getAddressField(isBilling, "street"),
                    onChanged: (String? value) =>
                        setAddressField(isBilling, "street", value!),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                          style: TextStyle(
                            color: widget.checkoutOptions.textColor,
                          ),
                          decoration: InputDecoration(
                            hintText: 'المحافظه',
                            labelText: 'المحافظه',
                            focusedBorder: border,
                            enabledBorder: border,
                            hintStyle: TextStyle(
                                color: widget.checkoutOptions.textColor),
                            labelStyle: TextStyle(
                                color: widget.checkoutOptions.textColor),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          initialValue: getAddressField(isBilling, "city"),
                          onChanged: (String? value) =>
                              setAddressField(isBilling, "city", value!),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          flex: 4,
                          child: Container(
                            margin: const EdgeInsets.only(right: 16),
                            child: TextFormField(
                              style: TextStyle(
                                color: widget.checkoutOptions.textColor,
                              ),
                              decoration: InputDecoration(
                                hintText: 'الرقم البريدى',
                                labelText: 'الرقم البريدى',
                                focusedBorder: border,
                                enabledBorder: border,
                                hintStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                labelStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                              initialValue:
                                  getAddressField(isBilling, "postCode"),
                              onChanged: (String? value) => setAddressField(
                                  isBilling, "postCode", value!),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            )));
  }

  void setAddressField(bool isBilling, String field, String value) {
    if (isBilling && widget.checkoutOptions.billingAddress == null)
      widget.checkoutOptions.billingAddress = new Address();

    if (!isBilling && widget.checkoutOptions.shippingAddress == null)
      widget.checkoutOptions.shippingAddress = new Address();

    if (field == "countryCode") {
      isBilling
          ? widget.checkoutOptions.billingAddress!.countryCode = value
          : widget.checkoutOptions.shippingAddress!.countryCode = value;
    } else if (field == "street") {
      isBilling
          ? widget.checkoutOptions.billingAddress!.street = value
          : widget.checkoutOptions.shippingAddress!.street = value;
    } else if (field == "city") {
      isBilling
          ? widget.checkoutOptions.billingAddress!.city = value
          : widget.checkoutOptions.shippingAddress!.city = value;
    } else if (field == "postCode") {
      isBilling
          ? widget.checkoutOptions.billingAddress!.postCode = value
          : widget.checkoutOptions.shippingAddress!.postCode = value;
    }
  }

  String? getAddressField(bool isBilling, String field) {
    var billingAddress = widget.checkoutOptions.billingAddress != null
        ? widget.checkoutOptions.billingAddress
        : new Address();
    var shippingAddress = widget.checkoutOptions.shippingAddress != null
        ? widget.checkoutOptions.shippingAddress
        : new Address();
    if (field == "countryCode") {
      if (isBilling) {
        if (billingAddress != null)
          return billingAddress.countryCode;
        else
          return "";
      } else {
        if (shippingAddress != null)
          return shippingAddress.countryCode;
        else
          return "";
      }
    } else if (field == "street") {
      if (isBilling) {
        if (billingAddress != null)
          return billingAddress.street;
        else
          return "";
      } else {
        if (shippingAddress != null)
          return shippingAddress.street;
        else
          return "";
      }
    } else if (field == "city") {
      if (isBilling) {
        if (billingAddress != null)
          return billingAddress.city;
        else
          return "";
      } else {
        if (shippingAddress != null)
          return shippingAddress.city;
        else
          return "";
      }
    } else if (field == "postCode") {
      if (isBilling) {
        if (billingAddress != null)
          return billingAddress.postCode;
        else
          return "";
      } else {
        if (shippingAddress != null)
          return shippingAddress.postCode;
        else
          return "";
      }
    } else {
      return "";
    }
  }

  void cardNumberChange(val) {
    setState(() {
      cardType = detectCCType(val);
    });
  }

  Widget buildCreditCardScreen_AR(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              color: widget.checkoutOptions.backgroundColor,
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            CreditCardForm(
                              rtl: true,
                              formKey: formKey,
                              obscureCvv: true,
                              obscureNumber: false,
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
                              onChange: cardNumberChange,
                              cardNumberDecoration: InputDecoration(
                                labelText: 'رقم الكارت',
                                hintText: 'XXXX XXXX XXXX XXXX',
                                hintStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                labelStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                focusedBorder: border,
                                enabledBorder: border,
                                suffixIcon: (cardType != null &&
                                        CreditCardTypeIconAsset[cardType] !=
                                            null)
                                    ? Container(
                                        margin: const EdgeInsets.all(12),
                                        child: Image.asset(
                                          CreditCardTypeIconAsset[cardType]!,
                                          height: 32,
                                          width: 32,
                                          package: 'geideapay',
                                        ))
                                    : Icon(
                                        Icons.call_to_action_rounded,
                                        color: widget
                                            .checkoutOptions.backgroundColor,
                                      ),
                              ),
                              expiryDateDecoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                labelStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                focusedBorder: border,
                                enabledBorder: border,
                                labelText: 'تاريخ الانتهاء',
                                hintText: 'XX/XX',
                              ),
                              cvvCodeDecoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                labelStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                focusedBorder: border,
                                enabledBorder: border,
                                labelText: 'الرقم المرجعى',
                                hintText: 'XXX',
                              ),
                              cardHolderDecoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                labelStyle: TextStyle(
                                    color: widget.checkoutOptions.textColor),
                                focusedBorder: border,
                                enabledBorder: border,
                                labelText: 'اسم صاحب الكارت',
                              ),
                              onCreditCardModelChange: onCreditCardModelChange,
                            ),
                            _customerEmailAR(),
                            const SizedBox(
                              height: 10,
                            ),
                            (widget.checkoutOptions.showAddress != null &&
                                    widget.checkoutOptions.showAddress!)
                                ? addressForm_AR(true)
                                : Container(),
                            (widget.checkoutOptions.showAddress != null &&
                                    widget.checkoutOptions.showAddress!)
                                ? _shippingAddressCheckBoxAR()
                                : Container(),
                            (!_shippingAddressSameAsBillingAddress)
                                ? addressForm_AR(false)
                                : Container(),
                            (widget.checkoutOptions.showSaveCard != null &&
                                    widget.checkoutOptions.showSaveCard!)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Switch(
                                        value: widget.saveCard,
                                        inactiveTrackColor: Colors.grey,
                                        activeColor: Colors.white,
                                        activeTrackColor: Colors.green,
                                        onChanged: (bool value) => setState(() {
                                          widget.saveCard = value;
                                        }),
                                      ),
                                      const Text(
                                        'حفظ الكارت؟',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      primary:
                                          widget.checkoutOptions.payButtonColor,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(12),
                                      // child: Text(
                                      //   'Pay ' + widget.checkoutOptions.amount
                                      //       + ' '
                                      //       + (widget.checkoutOptions.currency != null ? widget.checkoutOptions.currency!: ''),
                                      //   style: const TextStyle(
                                      //     color: Colors.white,
                                      //     fontSize: 14,
                                      //   ),
                                      // ),
                                      child: Text(
                                        (widget.checkoutOptions.currency != null
                                                ? widget
                                                    .checkoutOptions.currency!
                                                : '') +
                                            'ادفع ' +
                                            widget.checkoutOptions.amount
                                                .toString() +
                                            ' ',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        print('valid!');
                                        setState(
                                            () => _checkoutInProgress = true);
                                        Future.delayed(
                                            const Duration(seconds: 8), () {
                                          if (_shippingAddressSameAsBillingAddress) {
                                            widget.checkoutOptions
                                                    .shippingAddress =
                                                widget.checkoutOptions
                                                    .billingAddress;
                                          }
                                          setState(() {
                                            _checkoutInProgress = false;
                                          });
                                          Navigator.pop(context, 'OK');
                                        });
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      primary: widget
                                          .checkoutOptions.cancelButtonColor,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(12),
                                      child: const Text(
                                        'الغاء',
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
                                    image: AssetImage('assets/logo.png',
                                        package: 'geideapay'),
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
            _checkoutInProgress
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container()
          ],
        ));
  }

  Widget _shippingAddressCheckBoxEN() {
    return CheckboxListTile(
      title: Text(
        "Shipping address is same as Billing Address",
        style: Theme.of(context).textTheme.labelLarge,
      ),
      value: _shippingAddressSameAsBillingAddress,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? value) {
        setState(() {
          _shippingAddressSameAsBillingAddress = value ?? false;
        });
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _shippingAddressCheckBoxAR() {
    return CheckboxListTile(
      title: Text(
        "عنوان الشحن هو نفسه عنوان إرسال الفواتير",
        style: Theme.of(context).textTheme.labelLarge,
        textDirection: TextDirection.rtl,
      ),
      value: _shippingAddressSameAsBillingAddress,
      onChanged: (bool? value) {
        setState(() {
          _shippingAddressSameAsBillingAddress = value ?? false;
        });
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _customerEmailEN() {
    return Visibility(
      visible: widget.checkoutOptions.showEmail ?? false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: TextFormField(
          style: TextStyle(
            color: widget.checkoutOptions.textColor,
          ),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Email",
            labelText: "Email",
            focusedBorder: border,
            enabledBorder: border,
            hintStyle: TextStyle(color: widget.checkoutOptions.textColor),
            labelStyle: TextStyle(color: widget.checkoutOptions.textColor),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
          initialValue: widget.checkoutOptions.customerEmail,
          onChanged: (String? value) =>
              widget.checkoutOptions.customerEmail = value,
        ),
      ),
    );
  }

  Widget _customerEmailAR() {
    return Visibility(
      visible: widget.checkoutOptions.showEmail ?? false,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: TextFormField(
            style: TextStyle(
              color: widget.checkoutOptions.textColor,
            ),
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: "بريد إلكتروني",
              labelText: "بريد إلكتروني",
              focusedBorder: border,
              enabledBorder: border,
              hintStyle: TextStyle(color: widget.checkoutOptions.textColor),
              labelStyle: TextStyle(color: widget.checkoutOptions.textColor),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            initialValue: widget.checkoutOptions.customerEmail,
            onChanged: (String? value) =>
                widget.checkoutOptions.customerEmail = value,
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      widget.paymentCard.number = creditCardModel!.cardNumber;
      List<int> expiryDate =
          CardUtils.getExpiryDate(creditCardModel.expiryDate);
      widget.paymentCard.expiryMonth = expiryDate[0];
      widget.paymentCard.expiryYear = expiryDate[1];
      widget.paymentCard.name = creditCardModel.cardHolderName;
      widget.paymentCard.cvc = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
      _checkoutInProgress = false;
    });
  }
}
