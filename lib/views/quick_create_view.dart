import 'package:flutter/material.dart';

import '../models/common/field_model.dart';
import '../viewModels/create_task_viewmodel.dart';
import '../widgets/dynamic_field_widget.dart';

import 'full_create_view.dart';

class QuickCreateView extends StatefulWidget {
  const QuickCreateView({super.key});

  @override
  State<QuickCreateView> createState() =>
      _QuickCreateViewState();
}

class _QuickCreateViewState
    extends State<QuickCreateView> {
  final CreateTaskViewModel viewModel =
      CreateTaskViewModel();

  @override
  void initState() {
    super.initState();

    loadFields();
  }

  Future<void> loadFields() async {
    await viewModel.loadFields(
      quickCreateOnly: true,
    );

    /// SAFE CONTROLLERS

    if (!viewModel.controllers
        .containsKey("due_date")) {
      viewModel.controllers["due_date"] =
          TextEditingController();
    }

    if (!viewModel.controllers
        .containsKey("time_end")) {
      viewModel.controllers["time_end"] =
          TextEditingController();
    }

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

  Future<void> openFullForm() async {
    final result =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                const FullCreateView(),
      ),
    );

    if (result == true) {
      if (!mounted) return;

      Navigator.pop(context, true);
    }
  }

  List<FieldModel> get quickFields {
    return viewModel.fields.where((field) {
      return field.quickCreate ==
              true &&
          field.viewable == true;
    }).toList();
  }

  Widget buildFieldTitle({
    required String title,
    bool requiredField = false,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          /// REQUIRED STAR

          if (requiredField)

            const Text(
              " *",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildModernDateTimeField({
    required String dateField,
    required String timeField,
  }) {
    return Row(
      children: [
        /// DATE FIELD

        Expanded(
          child: InkWell(
            onTap: () async {
              DateTime? pickedDate =
                  await showDatePicker(
                context: context,
                initialDate:
                    DateTime.now(),
                firstDate:
                    DateTime(2000),
                lastDate:
                    DateTime(2100),
              );

              if (pickedDate != null) {
                viewModel.controllers[
                        dateField]
                    ?.text = pickedDate
                        .toString()
                        .split(" ")[0];

                if (!mounted) return;

                setState(() {});
              }
            },
            child: Container(
              height: 60,
              decoration:
                  BoxDecoration(
                color:
                    Colors.grey.shade100,
                borderRadius:
                    BorderRadius.circular(
                        16),
                border: Border.all(
                  color: Colors
                      .grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    decoration:
                        BoxDecoration(
                      color: Colors
                          .grey.shade200,
                      borderRadius:
                          const BorderRadius.only(
                        topLeft:
                            Radius.circular(
                                16),
                        bottomLeft:
                            Radius.circular(
                                16),
                      ),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Text(
                        viewModel.controllers[
                                    dateField]
                                ?.text ??
                            "",
                        style:
                            const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        /// TIME FIELD

        Expanded(
          child: InkWell(
            onTap: () async {
              TimeOfDay? pickedTime =
                  await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.now(),
              );

              if (pickedTime != null) {
                viewModel.controllers[
                        timeField]
                    ?.text =
                    pickedTime.format(
                        context);

                if (!mounted) return;

                setState(() {});
              }
            },
            child: Container(
              height: 60,
              decoration:
                  BoxDecoration(
                color:
                    Colors.grey.shade100,
                borderRadius:
                    BorderRadius.circular(
                        16),
                border: Border.all(
                  color: Colors
                      .grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    decoration:
                        BoxDecoration(
                      color: Colors
                          .grey.shade200,
                      borderRadius:
                          const BorderRadius.only(
                        topLeft:
                            Radius.circular(
                                16),
                        bottomLeft:
                            Radius.circular(
                                16),
                      ),
                    ),
                    child: const Icon(
                      Icons.access_time,
                      color: Colors.grey,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Text(
                        viewModel.controllers[
                                    timeField]
                                ?.text ??
                            "",
                        style:
                            const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
          "Create Task",
          style: TextStyle(
            color: Colors.black,
            fontWeight:
                FontWeight.w600,
          ),
        ),

        actions: [
          TextButton(
            onPressed: saveRecord,
            child: const Text(
              "Save",
              style: TextStyle(
                fontSize: 18,
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

              : SingleChildScrollView(
                  child: Container(
                    width: double.infinity,

                    margin:
                        const EdgeInsets.only(
                      top: 10,
                    ),

                    padding:
                        const EdgeInsets.all(
                            20),

                    decoration:
                        const BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.only(
                        topLeft:
                            Radius.circular(
                                20),
                        topRight:
                            Radius.circular(
                                20),
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        ...quickFields.map(
                          (field) {
                            /// DATE + TIME DESIGN

                            if (field.fieldName ==
                                "due_date") {
                              return Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [
                                  buildFieldTitle(
                                    title:
                                        "Due Date & Time",

                                    requiredField:
                                        field
                                            .mandatory,
                                  ),

                                  buildModernDateTimeField(
                                    dateField:
                                        "due_date",

                                    timeField:
                                        "time_end",
                                  ),

                                  const SizedBox(
                                    height: 24,
                                  ),
                                ],
                              );
                            }

                            /// SKIP TIME FIELD

                            if (field.fieldName ==
                                "time_end") {
                              return const SizedBox();
                            }

                            /// NORMAL FIELD

                            return Padding(
                              padding:
                                  const EdgeInsets.only(
                                bottom: 22,
                              ),

                              child:
                                  DynamicFieldWidget(
                                field: field,

                                controller:
                                    viewModel.controllers[
                                            field
                                                .fieldName] ??
                                        TextEditingController(),

                                dropdownValue:
                                    viewModel.dropdownValues[
                                        field.fieldName],

                                onChanged:
                                    (value) {
                                  setState(() {
                                    viewModel.dropdownValues[
                                            field
                                                .fieldName] =
                                        value;
                                  });
                                },
                              ),
                            );
                          },
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Center(
                          child: TextButton(
                            onPressed:
                                openFullForm,

                            child:
                                const Text(
                              "View full form",

                              style:
                                  TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}