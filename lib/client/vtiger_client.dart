import 'vtiger_ws_client.dart';
import 'dart:convert';

import 'package:http/http.dart'
    as http;

class VtigerClient {

  static final VtigerClient _instance =
      VtigerClient._internal();

  factory VtigerClient() => _instance;

  VtigerClient._internal();

  final VtigerWSClient wsClient =
      VtigerWSClient();

  Future<dynamic> doGet({

    required String endpoint,

    Map<String, String>? headers,

  }) async {

    return await wsClient.doGet(

      endpoint: endpoint,

      headers: headers,
    );
  }

  Future<dynamic> doPost({

    required String endpoint,

    Map<String, String>? headers,

    dynamic body,

  }) async {

    return await wsClient.doPost(

      endpoint: endpoint,

      headers: headers,

      body: body,
    );
  }
  Future<dynamic> doDelete({

  required String endpoint,

  Map<String, String>? headers,

  dynamic body,

}) async {

  final response = await http.delete(

    Uri.parse(endpoint),

    headers: headers,

    body: jsonEncode(body),
  );

  print("DELETE STATUS CODE");
  print(response.statusCode);

  print("DELETE RESPONSE BODY");
  print(response.body);

  if (response.statusCode == 200) {

    return jsonDecode(response.body);
  }

  throw Exception(
    "DELETE API FAILED",
  );
}
Future<dynamic> doPut({

  required String endpoint,

  required Map<String, String> headers,

  required dynamic body,

}) async {

  try {

    final response = await http.put(

      Uri.parse(endpoint),

      headers: headers,

      body: jsonEncode(body),
    );

    print("PUT STATUS CODE");
    print(response.statusCode);

    print("PUT RESPONSE");
    print(response.body);

    if (response.statusCode == 200) {

      return jsonDecode(response.body);
    }

    throw Exception("PUT API FAILED");

  } catch (e) {

    print("PUT ERROR");
    print(e);

    rethrow;
  }
}
}

