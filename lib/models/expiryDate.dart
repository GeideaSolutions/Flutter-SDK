class ExpiryDate {


  int? month, year;

  ExpiryDate({this.month, this.year});

  ExpiryDate.fromMap(Map<String, dynamic> map) {
    month = map['month'];
    year = map['year'];
  }

  @override
  String toString() {
    return 'ExpiryDate{month: $month, year: $year}';
  }

  @override
  Map<String, dynamic>? toMap() {
    return {"month": month, "year": year};
  }

}