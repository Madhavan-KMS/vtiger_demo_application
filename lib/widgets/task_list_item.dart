import 'package:flutter/material.dart';

import '../models/common/module_model.dart';
import '../models/common/module_record_model.dart';

import '../views/common/detail/module_detail_view.dart';
import '../views/edit_task_view.dart';

import '../../services/api_service.dart';
import '../../utils/session_manager.dart';

class TaskListItem extends StatelessWidget {

  final ModuleRecordModel record;

  final ModuleModel moduleModel;

  final String moduleName;

  final Future<void> Function()
      onRefresh;

  const TaskListItem({

    super.key,

    required this.record,

    required this.moduleModel,

    required this.moduleName,

    required this.onRefresh,
  });

  /// DELETE RECORD

  Future<void> deleteRecord(
    BuildContext context,
  ) async {

    final confirm =
        await showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text(
            "Delete Record",
          ),

          content: const Text(
            "Are you sure you want to delete this record?",
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(
                  context,
                  false,
                );
              },

              child: const Text(
                "Cancel",
              ),
            ),

            ElevatedButton(

              onPressed: () {

                Navigator.pop(
                  context,
                  true,
                );
              },

              child: const Text(
                "Delete",
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    try {

      String crmUrl =
          await SessionManager.getCrmUrl();

      String session =
          await SessionManager.getSession();

      final success =
          await ApiService.deleteRecord(

        crmUrl: crmUrl,

        session: session,

        moduleName: moduleName,

        recordId:
            record.getValue("id"),
      );

      if (!context.mounted) return;

      if (success) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "Record deleted successfully",
            ),
          ),
        );

        /// REFRESH LIST
        await onRefresh();

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "Failed to delete record",
            ),
          ),
        );
      }

    } catch (e) {

      debugPrint(e.toString());

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Something went wrong",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    /// FIRST KEY FIELD

    String firstFieldName =
        "subject";

    if (moduleModel.summaryFields
        .isNotEmpty) {

      firstFieldName =
          moduleModel
                  .summaryFields[0]
              ["fieldname"];
    }

    /// FIRST FIELD VALUE

    final firstValue =
        record.getValue(
      firstFieldName,
    );

    return InkWell(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder:
                (context) =>
                    ModuleDetailView(

                      record: record,

                      moduleModel:
                          moduleModel,

                      moduleName:
                          moduleName,
                    ),
          ),
        );
      },

      child: Card(

        margin:
            const EdgeInsets.symmetric(

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

              /// TEXT AREA

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

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

                    /// SECOND FIELD

                    if (moduleModel
                            .summaryFields
                            .length >
                        1)

                      Text(

                        record.getValue(

                          moduleModel
                                  .summaryFields[1]
                              ["fieldname"],
                        ).toString(),

                        style:
                            const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),

              /// EDIT BUTTON

              if (record.getValue(
                      "editable") ==
                  true)

                IconButton(

                  onPressed: () async {

                    final result =
                        await Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder:
                            (context) =>
                                EditTaskView(

                                  record:
                                      record,
                                ),
                      ),
                    );

                    /// REFRESH AFTER EDIT

                    if (result == true) {

                      await onRefresh();
                    }
                  },

                  icon: const Icon(

                    Icons.edit_outlined,

                    color: Colors.blue,
                  ),
                ),

              /// DELETE BUTTON

              if (record.getValue(
                      "deleteable") ==
                  true)

                IconButton(

                  onPressed: () {

                    deleteRecord(
                      context,
                    );
                  },

                  icon: const Icon(

                    Icons.delete_outline,

                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}