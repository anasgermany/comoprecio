/// App-wide constants for ComoPrecio
library;

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'ComoPrecio';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrl = 'https://api.comoprecio.app/v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheExpiration = Duration(minutes: 5);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Price
  static const String defaultCurrency = 'EUR';
  static const String currencySymbol = '€';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxSearchQueryLength = 200;

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = true;
}

class StorageKeys {
  StorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userPreferences = 'user_preferences';
  static const String searchHistory = 'search_history';
  static const String onboardingComplete = 'onboarding_complete';
  static const String themeMode = 'theme_mode';
  static const String selectedCurrency = 'selected_currency';
}

class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String me = '/auth/me';

  // Search
  static const String search = '/search';

  // Products
  static String product(String id) => '/products/$id';
  static String priceHistory(String id) => '/products/$id/history';

  // Alerts
  static const String alerts = '/alerts';
  static String alert(String id) => '/alerts/$id';

  // Sources
  static const String sources = '/sources';
}
