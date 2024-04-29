class ServerEnvironment {
  static List<ServerEnvironmentModel> environments() {
    return [
      ServerEnvironmentModel.EGY_PROD(),
      ServerEnvironmentModel.EGY_PREPROD(),
      ServerEnvironmentModel.UAE_PROD(),
      ServerEnvironmentModel.UAE_PREPROD(),
      ServerEnvironmentModel.KSA_PROD(),
      ServerEnvironmentModel.KSA_PREPROD(),
    ];
  }
}

class ServerEnvironmentModel {
  final String title;
  final String apiBaseUrl;

  ServerEnvironmentModel(this.title, this.apiBaseUrl);

  factory ServerEnvironmentModel.EGY_PROD() = _EGY_PROD;

  factory ServerEnvironmentModel.EGY_PREPROD() = _EGY_PREPROD;

  factory ServerEnvironmentModel.UAE_PROD() = _UAE_PROD;

  factory ServerEnvironmentModel.UAE_PREPROD() = _UAE_PREPROD;

  factory ServerEnvironmentModel.KSA_PROD() = _KSA_PROD;

  factory ServerEnvironmentModel.KSA_PREPROD() = _KSA_PREPROD;
}

class _EGY_PROD extends ServerEnvironmentModel {
  _EGY_PROD() : super('EGY-PROD', 'https://api.merchant.geidea.net');
}

class _EGY_PREPROD extends ServerEnvironmentModel {
  _EGY_PREPROD()
      : super('EGY-PREPROD', 'https://api-merchant.staging.geidea.net');
}

class _UAE_PROD extends ServerEnvironmentModel {
  _UAE_PROD() : super('UAE-PROD', 'https://api.merchant.geidea.ae');
}

class _UAE_PREPROD extends ServerEnvironmentModel {
  _UAE_PREPROD()
      : super('UAE-PREPROD', 'https://api-merchant.staging.geidea.ae');
}

class _KSA_PROD extends ServerEnvironmentModel {
  _KSA_PROD() : super('KSA-PROD', 'https://api.ksamerchant.geidea.net');
}

class _KSA_PREPROD extends ServerEnvironmentModel {
  _KSA_PREPROD()
      : super('KSA-PREPROD', 'https://api-ksamerchant.staging.geidea.net');
}
