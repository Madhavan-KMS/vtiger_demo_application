import '../services/api_service.dart';
import '../utils/session_manager.dart';

class CreateTaskViewModel {

  Future<bool> createTask({

    required String subject,

    required String taskStatus,

    required String priority,

    required String taskType,

  }) async {

    try {

      String crmUrl =
          await SessionManager.getCrmUrl();

      String session =
          await SessionManager.getSession();

      final response =
          await ApiService.createTask(

        crmUrl: crmUrl,

        session: session,

        body: {

          "subject": subject,

          "assigned_user_id": {

            "id": "1",

            "label":
                "Administrator",

            "module": "Users",
          },

          "taskstatus":
              taskStatus,

          "priority":
              priority,

          "tasktype":
              taskType,
        },
      );

      print(
        "CREATE TASK RESPONSE : ",
      );

      print(response);

      return true;

    } catch (e) {

      print(e);

      return false;
    }
  }
}