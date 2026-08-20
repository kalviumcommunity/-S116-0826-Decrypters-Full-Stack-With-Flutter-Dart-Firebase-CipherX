enum AppEnvironment {
  development,
  staging,
  production,
}

class AppConfig {
  final AppEnvironment environment;
  final String apiBaseUrl;
  final bool enableLogging;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableLogging,
  });

  static const AppConfig dev = AppConfig(
    environment: AppEnvironment.development,
    apiBaseUrl: 'http://localhost:8080',
    enableLogging: true,
  );

  static const AppConfig prod = AppConfig(
    environment: AppEnvironment.production,
    apiBaseUrl: 'https://api.cipher-x.org',
    enableLogging: false,
  );
}
