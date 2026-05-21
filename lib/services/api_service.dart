import '../client/vtiger_client.dart';
import 'dart:convert';

class ApiService {

  static final VtigerClient client =
      VtigerClient();

  /// AUTH LOGIN

  static Future<Map<String, dynamic>>
  authLogin({

    required String username,

    required String password,

  }) async {

    final response = await client.doPost(

      endpoint:
          "https://crmaccounts.od1.vtiger.ws/Users/Auth",

      headers: {
        "Content-Type": "application/json",
      },

      body:
          '{"username":"$username","password":"$password"}',
    );

    print(response);

    return response;
  }

  /// MOBILE LOGIN

  static Future<Map<String, dynamic>>
  mobileLogin({

    required String crmUrl,

    required String username,

    required String password,

  }) async {

    final response = await client.doPost(

      endpoint:
          "$crmUrl/mobile-api/login",

      body: {

        "username": username,

        "password": password,

        "module": "Mobile",
      },
    );

    print(response);

    return response;
  }

  /// FETCH RECORDS

  static Future<List> fetchRecords({

    required String crmUrl,

    required String session,

    required String moduleName,

  }) async {

    final response = await client.doGet(

      endpoint:
          "$crmUrl/mobile-api/records?module=$moduleName",

      headers: {

        "Cookie":
            "PHPSESSID=$session",
      },
    );

    print(response);

    return response;
  }

  /// SUMMARY FIELDS

  static Future<List> getSummaryFields({

    required String crmUrl,

    required String session,

    required String moduleName,

  }) async {

    final response = await client.doGet(

      endpoint:
          "$crmUrl/ui-api/describe?module=$moduleName",

      headers: {

        "Cookie":
            "PHPSESSID=$session",
      },
    );

    print(response);

    Map fields =
        response["fields"];

    List fieldList =
        fields.values.toList();

    List summaryFields =
        fieldList.where((field) {

          return
              field["summaryfield"] == true;

        }).toList();

    return summaryFields;
  }


static Future<dynamic> getDescribeData({

  required String crmUrl,

  required String session,

  required String moduleName,

}) async {

  try {

    final response =
        await client.doGet(

      endpoint:
          "$crmUrl/ui-api/describe?module=$moduleName",

      headers: {

        "Cookie":
            "PHPSESSID=$session",
      },
    );

    print("DESCRIBE RESPONSE");
    print(response);

    return response;

  } catch (e) {

    print("DESCRIBE API ERROR");
    print(e);

    return null;
  }
}



/// CREATE TASK

/// CREATE TASK

static Future<dynamic> createTask({

  required String crmUrl,

  required String session,

  required Map body,

}) async {

  final response =
      await client.doPost(

    endpoint:
        "$crmUrl/mobile-api/records?module=Tasks",

    headers: {

      "Cookie":
          "PHPSESSID=$session",

      "Content-Type":
          "application/json",
    },

    body: jsonEncode(body),
  );

  print(
    "CREATE TASK RESPONSE : ",
  );

  print(response);

  return response;
}


static Future<bool> deleteRecord({

  required String crmUrl,

  required String session,

  required String moduleName,

  required dynamic recordId,

}) async {

  try {

    final response = await client.doDelete(

      endpoint:
          "$crmUrl/mobile-api/records?module=$moduleName",

      headers: {

        "Cookie":
            "PHPSESSID=$session",

        "Content-Type":
            "application/json",
      },

      body: {

        "id": recordId,
      },
    );

    print("DELETE RESPONSE");
    print(response);

    return true;

  } catch (e) {

    print("DELETE ERROR");
    print(e);

    return false;
  }
}

static Future<bool> updateRecord({

  required String crmUrl,

  required String session,

  required String moduleName,

  required Map body,

}) async {

  try {

    final response = await client.doPut(

      endpoint:
          "$crmUrl/mobile-api/records?module=$moduleName",

      headers: {

        "Cookie":
            "PHPSESSID=$session",

        "Content-Type":
            "application/json",
      },

      body: body,
    );

    print("UPDATE RESPONSE");
    print(response);

    return true;

  } catch (e) {

    print("UPDATE ERROR");
    print(e);

    return false;
  }
}



  /// LOGOUT

static Future<void> logout({

  required String crmUrl,

  required String session,

}) async {

  final response =
      await client.doPost(

    endpoint:
        "$crmUrl/mobile-api/logout",

    headers: {

      "Cookie":
          "PHPSESSID=$session",
    },

    body: {

      "module": "Mobile",
    },
  );

  print(response);
}
}