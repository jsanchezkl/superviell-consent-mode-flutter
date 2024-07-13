import 'package:shared_preferences/shared_preferences.dart';

class ConsentManager {
  static const String _consentStatusKey = 'consent_status';

  static Future<void> storeConsentStatus(bool consentGiven) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentStatusKey, consentGiven);
  }

  static Future<bool> getConsentStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_consentStatusKey) ?? false;
  }
}
