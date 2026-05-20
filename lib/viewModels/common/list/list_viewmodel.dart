import '../../../models/common/module_model.dart';
import '../../../models/common/module_record_model.dart';
import '../../../services/api_service.dart';
import '../../../utils/session_manager.dart';

class ListViewModel {

  final String moduleName;

  late ModuleModel moduleModel;

  List<ModuleRecordModel> records = [];

  bool isLoading = true;

  ListViewModel({

    required this.moduleName,
  });

  Future<void> init() async {

    moduleModel = ModuleModel(
      name: moduleName,
    );

    await moduleModel.init();

    await fetchModuleRecords();
  }

  Future<void> fetchModuleRecords() async {

    String crmUrl =
        await SessionManager.getCrmUrl();

    String session =
        await SessionManager.getSession();

    final response =
        await ApiService.fetchRecords(

      crmUrl: crmUrl,

      session: session,

      moduleName: moduleName,
    );

    records =
        response.map<ModuleRecordModel>((record) {

      return ModuleRecordModel(
        rawData: record,
      );

    }).toList();

    isLoading = false;
  }
}