class ModuleRecordModel {

  final Map rawData;

  ModuleRecordModel({

    required this.rawData,
  });

  dynamic getValue(String fieldName) {

    dynamic value =
        rawData[fieldName];

    if (value is Map) {

      return value["label"] ??
          value["id"] ??
          "";
    }

    return value ?? "";
  }
}