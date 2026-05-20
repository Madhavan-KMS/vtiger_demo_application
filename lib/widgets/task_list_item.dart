import 'package:flutter/material.dart';

import '../models/common/module_model.dart';
import '../models/common/module_record_model.dart';

import '../views/common/detail/module_detail_view.dart';

import '../../services/api_service.dart';
import '../../utils/session_manager.dart';

class TaskListItem extends StatefulWidget {
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
  State<TaskListItem> createState() =>
      _TaskListItemState();
}

class _TaskListItemState
    extends State<TaskListItem> {

  /// DELETE RECORD

  Future<void> deleteRecord() async {

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

        moduleName: widget.moduleName,

        recordId:
            widget.record.getValue("id"),
      );

      if (!mounted) return;

      if (success) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "Record deleted successfully",
            ),
          ),
        );

        setState(() {

          widget.record.rawData["deleted"] = true;
        });

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

      print(e);

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

    /// HIDE DELETED RECORD

    if (widget.record.rawData["deleted"] == true) {

      return const SizedBox();
    }

    /// FIRST KEY FIELD

    String firstFieldName = "subject";

    if (widget.moduleModel.summaryFields
        .isNotEmpty) {

      firstFieldName =
          widget
              .moduleModel
              .summaryFields[0]["fieldname"];
    }

    /// FIRST FIELD VALUE

    final firstValue =
        widget.record.getValue(
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

                      record: widget.record,

                      moduleModel:
                          widget.moduleModel,

                      moduleName:
                          widget.moduleName,
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

                    /// SECOND FIELD

                    if (widget
                            .moduleModel
                            .summaryFields
                            .length >
                        1)

                      Text(

                        widget.record.getValue(

                          widget
                                  .moduleModel
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

              /// DELETE BUTTON

              if (widget.record.getValue(
                      "deleteable") ==
                  true)

                IconButton(

                  onPressed:
                      deleteRecord,

                  icon: const Icon(

                    Icons.delete_outline,

                    color: Colors.red,
                  ),
                ),

              /// DETAIL ARROW

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