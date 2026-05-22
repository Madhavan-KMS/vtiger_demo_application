import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/session_manager.dart';
import '../models/common/field_model.dart';

class CreateTaskViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<FieldModel> fields = [];

final Map<String, TextEditingController>
    controllers = {};

final Map<String, dynamic>
    dropdownValues = {};

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

Future<bool> updateTask({

  required String id,

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

    Map body = {

      "id": id,

      "subject": subject,

      "taskstatus": taskStatus,

      "taskpriority": priority,

      "tasktype": taskType,
    };

    bool success =
    await ApiService.updateRecord(

      crmUrl: crmUrl,

      session: session,

      moduleName: "Tasks",

      body: body,
    );

    return success;

  } catch (e) {

    print(e);

    return false;
  }
}

Future<void> loadFields({
  bool quickCreateOnly = false,
}) async {

  try {

    isLoading = true;

    notifyListeners();

    String crmUrl =
        await SessionManager.getCrmUrl();

    String session =
        await SessionManager.getSession();

    final response =
        await ApiService.getDescribeData(

      crmUrl: crmUrl,

      session: session,

      moduleName: "Tasks",
    );

    final fieldMap =
        response["fields"] as Map<String, dynamic>;

    fields.clear();

    fieldMap.forEach((key, value) {

      final field =
          FieldModel.fromJson(value);

      /// ONLY VIEWABLE FIELDS

      if (!field.viewable) {
        return;
      }

      /// QUICK CREATE FILTER

      if (
          quickCreateOnly &&
          field.quickCreate != true
      ) {
        return;
      }

      fields.add(field);

      controllers[field.fieldName] =
          TextEditingController();

      /// PICKLIST DEFAULT VALUE

      if (
          field.picklistValues != null &&
          field.picklistValues.isNotEmpty
      ) {

        dropdownValues[field.fieldName] =
            field.picklistValues.first["value"];
      }
    });

  } catch (e) {

    print(e);

  } finally {

    isLoading = false;

    notifyListeners();
  }
}

Future<bool> saveTask() async {

  try {

    isLoading = true;

    notifyListeners();

    String crmUrl =
        await SessionManager.getCrmUrl();

    String session =
        await SessionManager.getSession();

    Map<String, dynamic> body = {};

    for (FieldModel field in fields) {

      /// SKIP NON EDITABLE

      if (!field.editable) {
        continue;
      }

      /// PICKLIST VALUE

      if (dropdownValues.containsKey(
        field.fieldName,
      )) {

        body[field.fieldName] =
            dropdownValues[field.fieldName];
      }

      /// TEXT VALUE

      else if (controllers.containsKey(
        field.fieldName,
      )) {

        body[field.fieldName] =
            controllers[field.fieldName]!
                .text
                .trim();
      }
    }

    /// REQUIRED DEFAULTS

    body["subject"] =
        controllers["subject"]
                ?.text
                .trim() ??
            "";

    body["taskstatus"] =
        dropdownValues["taskstatus"] ??
            "Todo";

    body["taskpriority"] =
        dropdownValues["taskpriority"] ??
            "High";

    body["tasktype"] =
        dropdownValues["tasktype"] ??
            "Checklist Item";

    /// OWNER FIELD

    body["assigned_user_id"] = {
      "id": "1",
      "label": "Administrator",
      "module": "Users",
    };

    print(body);

    final response =
        await ApiService.createTask(

      crmUrl: crmUrl,

      session: session,

      body: body,
    );

    print(response);

    isLoading = false;

    notifyListeners();

    return response != null;

  } catch (e) {

    print(e);

    isLoading = false;

    notifyListeners();

    return false;
  }
}
}