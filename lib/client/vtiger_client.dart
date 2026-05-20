import 'vtiger_ws_client.dart';

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
}