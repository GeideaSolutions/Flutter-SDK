class AuthenticationDetails {


  String? acsEci, authenticationToken, paResStatus, veResEnrolled, xid,
      accountAuthenticationValue, proofXml;

  AuthenticationDetails(
      {this.acsEci, this.authenticationToken, this.paResStatus, this.veResEnrolled, this.xid, this.accountAuthenticationValue, this.proofXml});

  AuthenticationDetails.fromMap(Map<String, dynamic> map) {
    acsEci = map['acsEci'];
    authenticationToken = map['authenticationToken'];
    paResStatus = map['paResStatus'];
    veResEnrolled = map['veResEnrolled'];
    xid = map['xid'];
    accountAuthenticationValue = map['accountAuthenticationValue'];
    proofXml = map['proofXml'];
  }

  @override
  String toString() {
    return 'AuthenticationDetails{acsEci: $acsEci, authenticationToken: $authenticationToken, paResStatus: $paResStatus, veResEnrolled: $veResEnrolled, xid: $xid, accountAuthenticationValue: $accountAuthenticationValue, proofXml: $proofXml}';
  }

  @override
  Map<String, dynamic>? toMap() {
    return {
      "acsEci": acsEci,
      "authenticationToken": authenticationToken,
      "paResStatus": paResStatus,
      "veResEnrolled": veResEnrolled,
      "xid": xid,
      "accountAuthenticationValue": accountAuthenticationValue,
      "proofXml": proofXml
    };
  }
}