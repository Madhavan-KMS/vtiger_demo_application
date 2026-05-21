import 'package:flutter/material.dart';

import '../viewModels/create_task_viewmodel.dart';
import '../models/common/module_record_model.dart';

class EditTaskView extends StatefulWidget {
  final ModuleRecordModel record;

  const EditTaskView({
    super.key,
    required this.record,
  });

  @override
  State<EditTaskView> createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {

  final TextEditingController nameController =
      TextEditingController();

  String assignedUser = "Administrator";

  String stage = "";

  String priority = "";

  String taskType = "";

  bool isLoading = false;

  final viewModel = CreateTaskViewModel();

  /// DROPDOWN ITEMS

  final List<String> stageItems = [

    "Todo",

    "Completed",
  ];

  final List<String> priorityItems = [

    "High",

    "Medium",

    "Low",
  ];

  final List<String> taskTypeItems = [

    "Checklist Item",

    "Call",

    "Meeting",
  ];

  @override
  void initState() {

    super.initState();

    /// CURRENT VALUES FROM RECORD

    nameController.text =
        widget.record.getValue("subject");

    stage =
        widget.record.getValue("taskstatus");

    taskType =
        widget.record.getValue("tasktype");

    /// DEFAULT PRIORITY

    priority = "High";

    /// FIX EMPTY VALUES

    if (!stageItems.contains(stage)) {

      stage = "Todo";
    }

    if (!taskTypeItems.contains(taskType)) {

      taskType = "Checklist Item";
    }

    if (!priorityItems.contains(priority)) {

      priority = "High";
    }
  }
  

  Future<void> updateTask() async {

    if (nameController.text.isEmpty) {

      return;
    }

    setState(() {

      isLoading = true;
    });

    bool success =
        await viewModel.updateTask(

      id:
          widget.record.getValue("id")
              .toString(),

      subject:
          nameController.text,

      taskStatus:
          stage,

      priority:
          priority,

      taskType:
          taskType,
    );

    setState(() {

      isLoading = false;
    });

    if (!mounted) return;

    if (success) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Task updated successfully",
          ),
        ),
      );

      Navigator.pop(
        context,
        true,
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Failed to update task",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Colors.grey.shade100,

      appBar: AppBar(

        backgroundColor:
            Colors.white,

        elevation: 0,

        leading: IconButton(

          onPressed: () {

            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),

        title: const Text(

          "Edit Task",

          style: TextStyle(
            color: Colors.black,
          ),
        ),

        actions: [

          TextButton(

            onPressed:
                isLoading
                    ? null
                    : updateTask,

            child:
                const Text(
              "Save",
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(

              "Task Details",

              style: TextStyle(

                color: Colors.blue,

                fontWeight:
                    FontWeight.bold,

                fontSize: 18,
              ),
            ),

            const SizedBox(height: 25),

            /// NAME

            const Text(

              "Name *",

              style: TextStyle(

                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(

              controller:
                  nameController,

              decoration:
                  InputDecoration(

                hintText:
                    "Enter Name",

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ASSIGNED USER

            const Text(

              "Assigned To *",

              style: TextStyle(

                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Container(

              padding:
                  const EdgeInsets.symmetric(

                horizontal: 15,

                vertical: 18,
              ),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),

              child: Row(

                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  Text(assignedUser),

                  const Icon(
                    Icons.arrow_drop_down,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// STAGE

            const Text(

              "Stage *",

              style: TextStyle(

                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(

              value: stage,

              decoration:
                  InputDecoration(

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),

              items:
                  stageItems.map((item) {

                return DropdownMenuItem(

                  value: item,

                  child: Text(item),
                );

              }).toList(),

              onChanged: (value) {

                setState(() {

                  stage = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// PRIORITY

            const Text(

              "Priority *",

              style: TextStyle(

                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(

              value: priority,

              decoration:
                  InputDecoration(

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),

              items:
                  priorityItems.map((item) {

                return DropdownMenuItem(

                  value: item,

                  child: Text(item),
                );

              }).toList(),

              onChanged: (value) {

                setState(() {

                  priority = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// TASK TYPE

            const Text(

              "Task Type *",

              style: TextStyle(

                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(

              value: taskType,

              decoration:
                  InputDecoration(

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),

              items:
                  taskTypeItems.map((item) {

                return DropdownMenuItem(

                  value: item,

                  child: Text(item),
                );

              }).toList(),

              onChanged: (value) {

                setState(() {

                  taskType = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            if (isLoading)

              const Center(

                child:
                    CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}