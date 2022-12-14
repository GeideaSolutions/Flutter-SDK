import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geideapay/api/response/order_api_response.dart';
import 'package:geideapay/common/geidea.dart';
import 'package:geideapay/geideapay.dart';
import 'package:geideapay/models/address.dart';
import 'package:geideapay/widgets/checkout/checkout_options.dart';


class CheckoutFlow extends StatefulWidget {
  String geideaPublicKey = '';

  String geideaApiPassword = '';
  CheckoutFlow(this.geideaPublicKey, this.geideaApiPassword, {Key? key}) : super(key: key);

  @override
  _CheckoutFlowState createState() => _CheckoutFlowState();
}

class _CheckoutFlowState extends State<CheckoutFlow> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  final plugin = GeideapayPlugin();
  bool _checkoutInProgress = false;
  String _checkoutAmount = "100";
  String paymentIntentID = "", merchantReferenceID = "", customerEmail = "",
      bCountry = "", bStreet = "", bCity = "", bPostal = "",
      sCountry = "", sStreet = "", sCity = "", sPostal = "";
  String _currency = "EGP";
  String callbackUrl = "";
  final String _returnUrl ="https://returnurl.com";
  final bool _cardOnFile = true;

  String? cardholderName = "Ahmed";
  PaymentCard? card;
  OrderApiResponse? orderApiResponse;

  // Group Value for Radio Button.
  int id = 1;
  String radioButtonLangItem = 'EN';

  String paymentOperation = "Default (merchant configuration)";
  var paymentOperations = ['Default (merchant configuration)', 'Pay', 'PreAuthorize', 'AuthorizeCapture'];

  String initiatedBy = "Internet";
  var initiatedByOptions = ['Internet', 'Merchant'];

  String agreementType = "None";
  var agreementTypes = ['None', 'Recurring', 'Installment', 'Unscheduled'];

  var showBilling = false, showShipping = false, showSaveCard = false;

  @override
  void initState() {
    plugin.initialize(publicKey: widget.geideaPublicKey, apiPassword: widget.geideaApiPassword );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout Flow"), backgroundColor: Colors.red,),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    _verticalSizeBox,
                    const Text("SDK Language", style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: id,
                          onChanged: (val) {
                            setState(() {
                              radioButtonLangItem = 'EN';
                              id = 1;
                            });
                          },
                        ),
                        const Text(
                          'English',
                          style: TextStyle(fontSize: 17.0),
                        ),
                        Radio(
                          value: 2,
                          groupValue: id,
                          onChanged: (val) {
                            setState(() {
                              radioButtonLangItem = 'AR';
                              id = 2;
                            });
                          },
                        ),
                        const Text(
                          'Arabic',
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                    _verticalSizeBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("Show Billing"),
                            contentPadding: EdgeInsets.zero,
                            value: showBilling,
                            onChanged: (newValue) {
                              setState(() {
                                showBilling = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text("Show Shipping"),
                            value: showShipping,
                            onChanged: (newValue) {
                              setState(() {
                                showShipping = newValue!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          ),
                        ),
                      ],
                    ),
                    _verticalSizeBox,
                    CheckboxListTile(
                      title: const Text("Show Save Card"),
                      contentPadding: EdgeInsets.zero,
                      value: showSaveCard,
                      onChanged: (newValue) {
                        setState(() {
                          showSaveCard = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                    ),
                    _verticalSizeBox,
                    //payment operation
                    dropDownField('Payment Operation', paymentOperations),
                    _verticalSizeBox,
                    //initiated by
                    dropDownField('Initiated By', initiatedByOptions),
                    _verticalSizeBox,
                    dropDownField('Agreement Type', agreementTypes),
                    _verticalSizeBox,
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Payment Intent ID',
                        labelText: 'Payment Intent ID',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                      initialValue: paymentIntentID,
                      onChanged: (String? value) => paymentIntentID = value!,
                    ),
                    _verticalSizeBox,
                    const Text("Order details", style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold)),
                    _verticalSizeBox,
                    //amount, currency
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Amount',
                                labelText: 'Amount *',
                                contentPadding:
                                EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5.0)),
                                ),
                              ),
                              initialValue: _checkoutAmount,
                              validator: validateNumber('amount'),
                              onChanged: (String? value) => _checkoutAmount = value!,
                            ),
                          ),
                          _horizontalSizeBox,
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'EGP',
                                labelText: 'Currency',
                                contentPadding:
                                EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5.0)),
                                ),
                              ),
                              initialValue: _currency,
                              onChanged: (String? value) => _currency = value!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Merchant reference ID
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Merchant Reference ID',
                          labelText: 'Merchant Reference ID',
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        initialValue: merchantReferenceID,
                        onChanged: (String? value) => merchantReferenceID = value!,
                      ),
                    ),
                    //Customer Email
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Customer Email',
                          labelText: 'Customer Email',
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        initialValue: customerEmail,
                        onChanged: (String? value) => customerEmail = value!,
                      ),
                    ),
                    _verticalSizeBox,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Callback URL',
                          labelText: 'Callback URL',
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        initialValue: callbackUrl,
                        onChanged: (String? value) => callbackUrl = value!,
                      ),
                    ),
                    _verticalSizeBox,
                    const Text("Billing address", style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold)),
                    _verticalSizeBox,
                    addressForm(true),
                    _verticalSizeBox,
                    const Text("Shipping address", style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold)),
                    _verticalSizeBox,
                    addressForm(false),
                    _verticalSizeBox,
                    Theme(
                      data: Theme.of(context).copyWith(
                        accentColor: green,
                        primaryColorLight: Colors.white,
                        primaryColorDark: navyBlue,
                        textTheme: Theme
                            .of(context)
                            .textTheme
                            .copyWith(
                          bodyText2: const TextStyle(
                            color: lightBlue,
                          ),
                        ),
                      ),
                      child: Builder(
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    flex: 2,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: _getPlatformButton(
                                          'Checkout',
                                              () => _handleCheckout(context),
                                          true
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    _verticalSizeBox,
                  ],
                ),
              ),
            ),
          ),
          _checkoutInProgress ? Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ) : Container()
        ],
      ),
    );
  }

  String truncate(String text, { length: 200, omission: '...' }) {
    if (length >= text.length) {
      return text;
    }
    return text.replaceRange(length, text.length, omission);
  }

  _handleCheckout(BuildContext context) async {
    FocusScope.of(context).unfocus();
    Address billingAddress = Address(city: bCity, countryCode: bCountry, street: bStreet, postCode: bPostal);
    Address shippingAddress = Address(city: sCity, countryCode: sCountry, street: sStreet, postCode: sPostal);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      CheckoutOptions checkoutOptions = CheckoutOptions(
          _checkoutAmount, _currency,
          callbackUrl: callbackUrl,
          lang: radioButtonLangItem,
          billingAddress: billingAddress,
          shippingAddress: shippingAddress,
        customerEmail: customerEmail,
        merchantReferenceID: merchantReferenceID,
        paymentIntentId: paymentIntentID,
        paymentOperation: paymentOperation,
        showShipping: showShipping,
        showBilling: showBilling,
        showSaveCard: showSaveCard,
      );

      setState(() => _checkoutInProgress = true);

      try {
        OrderApiResponse response =
        await plugin.checkout(
            context: context, checkoutOptions: checkoutOptions);
        print('Response = $response');
        setState(() => _checkoutInProgress = false);

        _updateStatus(
            response.detailedResponseMessage, truncate(response.toString()));
      } catch (e) {
        setState(() => _checkoutInProgress = false);
        _showMessage(e.toString());
        //rethrow;
      }
    }
  }


  Widget _getPlatformButton(String string, Function() function, bool active) {
    // is still in progress
    Widget widget;
    if (Platform.isIOS) {
      widget = CupertinoButton(
        onPressed: function,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        color: active? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
        child: Text(
          string,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      widget = ElevatedButton(
        onPressed: active? function : null,
        child: Text(
          string.toUpperCase(),
          style: const TextStyle(fontSize: 17.0),
        ),
        style: ButtonStyle(
            backgroundColor: active? MaterialStateProperty.all(Colors.lightBlue) : MaterialStateProperty.all(Colors.grey)),
      );
    }
    return widget;
  }

  _updateStatus(String? reference, String? message) {
    _showMessage('Reference: $reference \n Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
      action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }

  validateNumber(String s) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter ' + s;
      }
      return null;
    };
  }

  addressForm(bool isBilling) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Country Code',
              labelText: 'Country Code',
              contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            initialValue: isBilling ? bCountry: sCountry,
            onChanged: (String? value) => isBilling ? bCountry = value! : sCountry = value!,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Street name & number',
              labelText: 'Street name & number',
              contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            initialValue: isBilling ? bStreet: sStreet,
            onChanged: (String? value) => isBilling ? bStreet = value! : sStreet = value!,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'City',
                    labelText: 'City',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  initialValue: isBilling ? bCity: sCity,
                  onChanged: (String? value) => isBilling ? bCity = value! : sCity = value!,
                ),
              ),
              _horizontalSizeBox,
              Expanded(
                flex: 5,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Postal',
                    labelText: 'Postal',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  initialValue: isBilling ? bPostal: sPostal,
                  onChanged: (String? value) => isBilling ? bPostal = value! : sPostal = value!,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
  dropDownField(String label, List<String> items) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        contentPadding:
        const EdgeInsets.symmetric(
            horizontal: 10.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(5.0)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: getDropValue(label),
          onChanged: (String? newValue) {
            setState(() {
              if(label == 'Payment Operation')
              {
                paymentOperation = newValue!;
              }
              else if(label == 'Initiated By')
              {
                 initiatedBy = newValue!;
              }
              else if(label == 'Agreement Type')
              {
                 agreementType = newValue!;
              }
            });
          },
          items: items
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  getDropValue(String label) {
    if(label == 'Payment Operation')
    {
      return paymentOperation;
    }
    else if(label == 'Initiated By')
    {
      return initiatedBy;
    }
    else if(label == 'Agreement Type')
    {
      return agreementType;
    }
  }
}

const Color green = Color(0xFF3db76d);
const Color lightBlue = Color(0xFF34a5db);
const Color navyBlue = Color(0xFF031b33);