class Summary {
  String? subTotal, shipping, vat;

  Summary({this.subTotal, this.shipping, this.vat});

  Summary.fromMap(Map<String, dynamic> map) {
    subTotal = map['subTotal'];
    shipping = map['shipping'];
    vat = map['vat'];
  }

  @override
  String toString() {
    return 'Summary${toMap()}';
  }

  @override
  Map<String, dynamic>? toMap() {
    return {"subTotal": subTotal, "shipping": shipping, "vat": vat};
  }
}
