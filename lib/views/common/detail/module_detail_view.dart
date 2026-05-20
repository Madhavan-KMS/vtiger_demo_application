import 'package:flutter/material.dart';

import '../../../models/common/module_model.dart';
import '../../../models/common/module_record_model.dart';

class ModuleDetailView extends StatelessWidget {

  final ModuleRecordModel record;

  final ModuleModel moduleModel;
  final String moduleName;

  const ModuleDetailView({

    super.key,

    required this.record,

    required this.moduleModel, required this.moduleName,
  });

  /// GET VALUE

  String getValue(String fieldName) {

    dynamic value =
        record.getValue(fieldName);

    if (value == null) {
      return "";
    }

    if (value is Map) {

      return
          value["label"] ??
          value["id"] ??
          "";
    }

    return value.toString();
  }

  /// NAME SECTION

  Widget buildNameSection() {

    String nameField = "subject";

    String nameLabel = "Name";

    /// USE FIRST SUMMARY FIELD

    if (moduleModel.summaryFields.isNotEmpty) {

      nameField =
          moduleModel
              .summaryFields
              .first["fieldname"];

      nameLabel =
          moduleModel
              .summaryFields
              .first["fieldlabel"];
    }

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(

            nameLabel,

            style: const TextStyle(

              fontSize: 15,

              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 10),

          Text(

            getValue(nameField),

            style: const TextStyle(

              fontSize: 28,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// HEADER FIELDS

  Widget buildHeaderFields() {

    List<dynamic> headerFields =
        moduleModel.headerFields;

    if (headerFields.isEmpty) {

      return const SizedBox();
    }

    return Container(

      margin:
          const EdgeInsets.only(top: 15),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: GridView.builder(

        shrinkWrap: true,

        physics:
            const NeverScrollableScrollPhysics(),

        itemCount:
            headerFields.length,

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount: 2,

          childAspectRatio: 2.2,

          crossAxisSpacing: 1,

          mainAxisSpacing: 1,
        ),

        itemBuilder: (context, index) {

          final field =
              headerFields[index];

          String fieldName =
              field["fieldname"] ?? "";

          String fieldLabel =
              field["fieldlabel"] ?? "";

          return Container(

            padding:
                const EdgeInsets.all(15),

            decoration: BoxDecoration(

              border: Border(

                right: BorderSide(
                  color:
                      Colors.grey.shade300,
                ),

                bottom: BorderSide(
                  color:
                      Colors.grey.shade300,
                ),
              ),
            ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Text(

                  fieldLabel,

                  style: const TextStyle(

                    fontSize: 14,

                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 8),

                Text(

                  getValue(fieldName),

                  maxLines: 2,

                  overflow:
                      TextOverflow.ellipsis,

                  style: const TextStyle(

                    fontSize: 16,

                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// KEY FIELDS

  Widget buildKeyFields() {

    List<dynamic> keyFields =
        moduleModel.summaryFields;

    if (keyFields.isEmpty) {

      return const SizedBox();
    }

    return Container(

      margin:
          const EdgeInsets.only(top: 20),

      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(

        children:
            keyFields.map((field) {

          String fieldName =
              field["fieldname"] ?? "";

          String fieldLabel =
              field["fieldlabel"] ?? "";

          return Padding(

            padding:
                const EdgeInsets.only(
              bottom: 25,
            ),

            child: Row(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const Icon(
                  Icons.label_outline,
                  size: 24,
                ),

                const SizedBox(width: 15),

                Expanded(

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Text(

                        fieldLabel,

                        style:
                            const TextStyle(

                          fontSize: 15,

                          color:
                              Colors.grey,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(

                        getValue(
                          fieldName,
                        ),

                        style:
                            const TextStyle(

                          fontSize: 18,

                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(

        backgroundColor:
            const Color(0xFF4B6BFB),

        foregroundColor:
            Colors.white,

        title: Text("$moduleName Details",
),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(15),

        child: Column(

          children: [

            /// NAME FIELD

            buildNameSection(),

            /// HEADER FIELDS

            buildHeaderFields(),

            /// KEY FIELDS

            buildKeyFields(),
          ],
        ),
      ),
    );
  }
}