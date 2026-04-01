class AppSettingsModel {
  final String currency;
  final String userName;
  final String themeMode; // 'light', 'dark', 'system'

  AppSettingsModel({
    this.currency = '\$',
    this.userName = 'User',
    this.themeMode = 'system',
  });
}
