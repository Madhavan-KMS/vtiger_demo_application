class FieldModel {

  final String fieldName;

  final String label;

  final bool quickCreate;

  final bool editable;

  final bool viewable;

  final bool mandatory;

  final String type;

  final dynamic picklistValues;

  final String blockLabel;

  final String? referenceModule;

  FieldModel({

    required this.fieldName,

    required this.label,

    required this.quickCreate,

    required this.editable,

    required this.viewable,

    required this.mandatory,

    required this.type,

    required this.blockLabel,

    this.picklistValues,

    this.referenceModule,
  });

  factory FieldModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return FieldModel(

      /// FIELD NAME

      fieldName:
          json["fieldname"] ??
              "",

      /// LABEL

      label:
          json["translated_fieldlabel"] ??
              json["fieldlabel"] ??
              "",

      /// QUICK CREATE

      quickCreate:
          json["quickcreate"] ??
              false,

      /// EDITABLE

      editable:
          json["editable"] ??
              true,

      /// VIEWABLE

      viewable:
          json["viewable"] ??
              true,

      /// MANDATORY

      mandatory:
          json["mandatory"] ??
              false,

      /// FIELD TYPE

      type:
          json["typeofdata"] ??
              json["uitype"]
                  ?.toString() ??
              "",

      /// BLOCK LABEL

      blockLabel:
          json["blocklabel"] ??
              json["block"] ??
              "",

      /// PICKLIST VALUES

      picklistValues:
          json["picklistValues"] ??
              [],

      /// REFERENCE MODULE

      referenceModule:
          json["refersTo"] != null &&
                  json["refersTo"]
                      is List &&
                  json["refersTo"]
                      .isNotEmpty
              ? json["refersTo"][0]
              : null,
    );
  }
}