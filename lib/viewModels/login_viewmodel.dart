import '../services/api_service.dart';
import '../utils/session_manager.dart';

class LoginViewModel {

  Future<bool> login({

    required String username,

    required String password,

  }) async {

    try {

      /// AUTH API

      final authResponse =
          await ApiService.authLogin(

        username: username,

        password: password,
      );

      String crmUrl =
          authResponse["result"]["user"]["url"];

      /// MOBILE LOGIN

      final loginResponse =
          await ApiService.mobileLogin(

        crmUrl: crmUrl,

        username: username,

        password: password,
      );

      String session =
          loginResponse["result"]["login"]["session"];

      /// SAVE SESSION

      await SessionManager.saveLogin(

        crmUrl: crmUrl,

        session: session,
      );

      return true;

    } catch (e) {

      print(e);

      return false;
    }
  }
}