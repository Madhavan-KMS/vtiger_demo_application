import 'package:flutter/material.dart';

import '../viewModels/create_task_viewmodel.dart';
import '../widgets/dynamic_field_widget.dart';

class FullCreateView extends StatefulWidget {

  const FullCreateView({super.key});

  @override
  State<FullCreateView> createState() =>
      _FullCreateViewState();
}

class _FullCreateViewState
    extends State<FullCreateView>
    with SingleTickerProviderStateMixin {

  final viewModel =
      CreateTaskViewModel();

  late TabController
      tabController;

  @override
  void initState() {

    super.initState();

    tabController =
        TabController(
      length: 3,
      vsync: this,
    );

    loadData();
  }

  Future<void> loadData() async {

    await viewModel.loadFields(
      quickCreateOnly: false,
    );

    if (!mounted) return;

    setState(() {});
  }

  Future<void> saveRecord() async {

    bool success =
        await viewModel.saveTask();

    if (!mounted) return;

    if (success) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Task created successfully",
          ),
        ),
      );

      Navigator.pop(context, true);

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Failed to create task",
          ),
        ),
      );
    }
  }

  Widget buildFields(
    List fields,
  ) {

    return ListView.builder(

      padding:
          const EdgeInsets.all(16),

      itemCount:
          fields.length,

      itemBuilder:
          (context, index) {

        final field =
            fields[index];

        return Padding(

          padding:
              const EdgeInsets.only(
            bottom: 20,
          ),

          child:
              DynamicFieldWidget(

            field: field,

            controller:
                viewModel.controllers[
                    field.fieldName]!,

            dropdownValue:
                viewModel.dropdownValues[
                    field.fieldName],

            onChanged: (value) {

              setState(() {

                viewModel.dropdownValues[
                    field.fieldName] = value;
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    /// MANUAL FIELD SPLIT

    final totalFields =
        viewModel.fields;

    final taskFields =
        totalFields.take(12).toList();

    final descriptionFields =
        totalFields.skip(12).take(8).toList();

    final serviceFields =
        totalFields.skip(20).toList();

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

          "Create Task",

          style: TextStyle(

            color: Colors.black,

            fontWeight:
                FontWeight.w600,
          ),
        ),

        actions: [

          TextButton(

            onPressed:
                saveRecord,

            child: const Text(

              "Save",

              style: TextStyle(

                fontSize: 18,

                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),
        ],
      ),

      body:
          viewModel.isLoading

              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : Column(

                  children: [

                    Container(

                      color:
                          Colors.white,

                      child: TabBar(

                        controller:
                            tabController,

                        isScrollable:
                            true,

                        labelColor:
                            Colors.blue,

                        unselectedLabelColor:
                            Colors.grey,

                        indicatorColor:
                            Colors.blue,

                        indicatorWeight:
                            3,

                        labelStyle:
                            const TextStyle(

                          fontSize: 18,

                          fontWeight:
                              FontWeight.w600,
                        ),

                        tabs: const [

                          Tab(
                            text:
                                "Task Details",
                          ),

                          Tab(
                            text:
                                "Description Details",
                          ),

                          Tab(
                            text:
                                "Service Details",
                          ),
                        ],
                      ),
                    ),

                    Expanded(

                      child: Container(

                        color:
                            Colors.white,

                        child:
                            TabBarView(

                          controller:
                              tabController,

                          children: [

                            buildFields(
                              taskFields,
                            ),

                            buildFields(
                              descriptionFields,
                            ),

                            buildFields(
                              serviceFields,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  @override
  void dispose() {

    tabController.dispose();

    super.dispose();
  }
}