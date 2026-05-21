import 'package:flutter/material.dart';

import '../viewModels/create_task_viewmodel.dart';

class CreateTaskView extends StatefulWidget {

  const CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() =>
      _CreateTaskViewState();
}

class _CreateTaskViewState
    extends State<CreateTaskView> {

  final nameController =
      TextEditingController();

  String stage = "Todo";

  String priority = "High";

  String taskType =
      "Checklist Item";

  bool isLoading = false;

  final viewModel =
      CreateTaskViewModel();
  

  

  Future<void> saveTask() async {

    if (nameController.text.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    bool success =
        await viewModel.createTask(

      subject:
          nameController.text,

      taskStatus: stage,

      priority: priority,

      taskType: taskType,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {

      if (!mounted) return;

      Navigator.pop(context, true);
    }
  }

  InputDecoration fieldDecoration(
    String hint,
  ) {

    return InputDecoration(

      hintText: hint,

      filled: true,

      fillColor: Colors.white,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 18,
      ),

      border: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(16),

        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      enabledBorder: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(16),

        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),

      focusedBorder: OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(16),

        borderSide: const BorderSide(
          color: Color(0xFF4B6BFB),
          width: 2,
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),

      child: Align(

        alignment:
            Alignment.centerLeft,

        child: Text(

          title,

          style: const TextStyle(

            fontSize: 18,

            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFFF7F7F7),

      appBar: AppBar(

        backgroundColor: Colors.white,

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

          "Create Task",

          style: TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        actions: [

          TextButton(

            onPressed:
                isLoading
                    ? null
                    : saveTask,

            child:
                const Text(

              "Save",

              style: TextStyle(

                color:
                    Color(0xFF4B6BFB),

                fontSize: 18,

                fontWeight:
                    FontWeight.bold,
              ),
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

            const Row(

              children: [

                Text(

                  "Task Details",

                  style: TextStyle(

                    fontSize: 20,

                    fontWeight:
                        FontWeight.bold,

                    color:
                        Color(0xFF4B6BFB),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            sectionTitle("Name *"),

            TextField(

              controller:
                  nameController,

              decoration:
                  fieldDecoration(
                "Enter Name",
              ),
            ),

            const SizedBox(height: 25),

            sectionTitle(
              "Assigned To *",
            ),

            Container(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
              ),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  16,
                ),

                border: Border.all(
                  color:
                      Colors.grey.shade300,
                ),
              ),

              child: DropdownButtonHideUnderline(

                child: DropdownButton(

                  value: "Administrator",

                  isExpanded: true,

                  items: const [

                    DropdownMenuItem(

                      value:
                          "Administrator",

                      child:
                          Text(
                        "Administrator",
                      ),
                    ),
                  ],

                  onChanged: (value) {},
                ),
              ),
            ),

            const SizedBox(height: 25),

            sectionTitle("Stage *"),

            Container(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
              ),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  16,
                ),

                border: Border.all(
                  color:
                      Colors.grey.shade300,
                ),
              ),

              child: DropdownButtonHideUnderline(

                child: DropdownButton(

                  value: stage,

                  isExpanded: true,

                  items: const [

                    DropdownMenuItem(
                      value: "Todo",
                      child: Text("Todo"),
                    ),

                    DropdownMenuItem(
                      value: "Completed",
                      child:
                          Text(
                        "Completed",
                      ),
                    ),
                  ],

                  onChanged: (value) {

                    setState(() {

                      stage = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            sectionTitle("Priority *"),

            Container(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
              ),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  16,
                ),

                border: Border.all(
                  color:
                      Colors.grey.shade300,
                ),
              ),

              child: DropdownButtonHideUnderline(

                child: DropdownButton(

                  value: priority,

                  isExpanded: true,

                  items: const [

                    DropdownMenuItem(
                      value: "High",
                      child: Text("High"),
                    ),

                    DropdownMenuItem(
                      value: "Medium",
                      child:
                          Text(
                        "Medium",
                      ),
                    ),

                    DropdownMenuItem(
                      value: "Low",
                      child: Text("Low"),
                    ),
                  ],

                  onChanged: (value) {

                    setState(() {

                      priority = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            sectionTitle(
              "Task Type *",
            ),

            Container(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
              ),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  16,
                ),

                border: Border.all(
                  color:
                      Colors.grey.shade300,
                ),
              ),

              child: DropdownButtonHideUnderline(

                child: DropdownButton(

                  value: taskType,

                  isExpanded: true,

                  items: const [

                    DropdownMenuItem(

                      value:
                          "Checklist Item",

                      child:
                          Text(
                        "Checklist Item",
                      ),
                    ),
                  ],

                  onChanged: (value) {

                    setState(() {

                      taskType = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 40),

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