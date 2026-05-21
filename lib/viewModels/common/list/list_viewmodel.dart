import 'package:flutter/material.dart';

import '../../../models/common/module_model.dart';
import '../../../models/common/module_record_model.dart';

import '../../../services/api_service.dart';
import '../../../utils/session_manager.dart';

class ListViewModel extends ChangeNotifier {

  final String moduleName;

  ListViewModel({
    required this.moduleName,
  });

  late ModuleModel moduleModel;

  List<ModuleRecordModel> records = [];

  bool isLoading = false;

  late String crmUrl;

  late String session;

  bool isInitialized = false;

  /// INIT

  Future<void> init() async {

    crmUrl =
        await SessionManager.getCrmUrl();

    session =
        await SessionManager.getSession();

    /// LOAD DESCRIBE ONLY ONCE

    if (!isInitialized) {

      moduleModel =
          ModuleModel(
        name: moduleName,
      );

      await moduleModel.init();

      isInitialized = true;
    }

    /// ALWAYS REFRESH RECORDS

    await fetchRecords();
  }

  /// FETCH RECORDS

  Future<void> fetchRecords() async {

    try {

      isLoading = true;

      notifyListeners();

      final response =
          await ApiService.fetchRecords(

        crmUrl: crmUrl,

        session: session,

        moduleName: moduleName,
      );

      /// IMPORTANT
      /// CLEAR OLD RECORDS

      records = [];

      /// CREATE NEW RECORD OBJECTS

      records =
          response.map<ModuleRecordModel>((record) {

        return ModuleRecordModel(
          rawData: Map<String, dynamic>.from(record),
        );

      }).toList();

      isLoading = false;

      notifyListeners();

    } catch (e) {

      print(e);

      isLoading = false;

      notifyListeners();
    }
  }
}