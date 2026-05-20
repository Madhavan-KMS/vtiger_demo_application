import 'dart:convert';

import 'package:http/http.dart' as http;

class VtigerWSClient {

  Future<dynamic> doGet({

    required String endpoint,

    Map<String, String>? headers,

  }) async {

    final response = await http.get(

      Uri.parse(endpoint),

      headers: headers,
    );

    return jsonDecode(response.body);
  }

  Future<dynamic> doPost({

    required String endpoint,

    Map<String, String>? headers,

    dynamic body,

  }) async {

    final response = await http.post(

      Uri.parse(endpoint),

      headers: headers,

      body: body,
    );

    return jsonDecode(response.body);
  }
}