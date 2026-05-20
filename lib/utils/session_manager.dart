import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {

  static Future<void> saveLogin({

    required String crmUrl,

    required String session,

  }) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "crmUrl",
      crmUrl,
    );

    await prefs.setString(
      "session",
      session,
    );
  }

  static Future<String> getCrmUrl() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
          "crmUrl",
        ) ??
        "";
  }

  static Future<String> getSession() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
          "session",
        ) ??
        "";
  }
  static Future<void> clearSession() async {

  final prefs =
      await SharedPreferences.getInstance();

  await prefs.clear();
}
}