class StatementDescriptor {
  String? name, phone;

  StatementDescriptor({this.name, this.phone});

  StatementDescriptor.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    phone = map['phone'];
  }

  @override
  String toString() {
    return 'StatementDescriptor{name: $name, phone: $phone}';
  }

  @override
  Map<String, dynamic>? toMap() {
    return {"name": name, "phone": phone};
  }
}