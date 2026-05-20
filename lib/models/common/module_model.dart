import '../../services/api_service.dart';
import '../../utils/session_manager.dart';

class ModuleModel {

  final String name;

  ModuleModel({
    required this.name,
  });

  List<dynamic> summaryFields = [];

  List<dynamic> headerFields = [];

  Future<void> init() async {

    await loadDescribeData();
  }

  Future<void> loadDescribeData() async {

    String crmUrl =
        await SessionManager.getCrmUrl();

    String session =
        await SessionManager.getSession();

    final describeData =
        await ApiService.getDescribeData(

      crmUrl: crmUrl,

      session: session,

      moduleName: name,
    );

    if (describeData == null) {
      return;
    }

    Map<String, dynamic> fields = {};

    if (describeData["fields"] is Map) {

      fields =
          Map<String, dynamic>.from(
            describeData["fields"],
          );
    }

    List<dynamic> fieldList =
        fields.values.toList();

    /// KEY FIELDS

    summaryFields =
        fieldList.where((field) {

      return field["summaryfield"] == true;

    }).toList();

    /// HEADER FIELDS

    headerFields =
        fieldList.where((field) {

      return field["headerfield"] == true;

    }).toList();

    print("SUMMARY FIELDS");
    print(summaryFields);

    print("HEADER FIELDS");
    print(headerFields);
  }
}