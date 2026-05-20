import 'package:flutter/material.dart';
import '../models/common/module_model.dart';
import '../models/common/module_record_model.dart';
import '../views/common/detail/module_detail_view.dart';

class TaskListItem extends StatelessWidget {
  final ModuleRecordModel record; 
  final ModuleModel moduleModel;
  final String moduleName;
  const TaskListItem({
    super.key,
    required this.record,
    required this.moduleModel,
    required this.moduleName,
  });
  @override
  Widget build(BuildContext context) {
    /// FIRST KEY FIELD
    String firstFieldName =moduleModel.summaryFields[0]["fieldname"];
    /// FIRST FIELD VALUE
    final firstValue =record.getValue(firstFieldName);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ModuleDetailView(
                      record: record,
                      moduleModel:moduleModel,
                      moduleName: moduleName,
                    ),
          ),
        );
      },

      child: Card(

        margin: const EdgeInsets.symmetric(

          horizontal: 10,
          vertical: 6,
        ),

        elevation: 3,

        child: Padding(

          padding:
              const EdgeInsets.all(15),

          child: Row(

            children: [

              const Icon(
                Icons.task,
                size: 30,
              ),

              const SizedBox(width: 15),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// MAIN TITLE

                    Text(

                      firstValue.toString(),

                      style:
                          const TextStyle(

                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    /// OPTIONAL SECOND FIELD

                    if (moduleModel
                            .summaryFields
                            .length >
                        1)

                      Text(

                        record.getValue(

                          moduleModel
                              .summaryFields[1]
                                  ["fieldname"],
                        ),

                        style:
                            const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}