/// App configuration per flavor (environment).
/// Never hardcode secrets here — use --dart-define at build time.
enum Flavor { dev, staging, prod }

class AppConfig {
  AppConfig._();

  static late Flavor flavor;
  static late String apiBaseUrl;
  static late bool enableLogging;
  static late bool enableCertPinning;
  static late bool enableCrashReporting;

  static void init(Flavor f) {
    flavor = f;
    switch (f) {
      case Flavor.dev:
        apiBaseUrl = const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api-dev.securevault.local',
        );
        enableLogging = true;
        enableCertPinning = false;   // easier local dev
        enableCrashReporting = false;

      case Flavor.staging:
        apiBaseUrl = const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api-staging.securevault.com',
        );
        enableLogging = true;
        enableCertPinning = true;
        enableCrashReporting = true;

      case Flavor.prod:
        apiBaseUrl = const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api.securevault.com',
        );
        enableLogging = false;
        enableCertPinning = true;
        enableCrashReporting = true;
    }
  }

  static bool get isDev => flavor == Flavor.dev;
  static bool get isProd => flavor == Flavor.prod;
}
