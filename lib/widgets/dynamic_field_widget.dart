import 'package:flutter/material.dart';

import '../models/common/field_model.dart';
import '../views/relation_list_view.dart';

class DynamicFieldWidget extends StatefulWidget {

  final FieldModel field;

  final TextEditingController controller;

  final dynamic dropdownValue;

  final Function(dynamic)? onChanged;

  const DynamicFieldWidget({

    super.key,

    required this.field,

    required this.controller,

    this.dropdownValue,

    this.onChanged,
  });

  @override
  State<DynamicFieldWidget> createState() => _DynamicFieldWidgetState();
}

class _DynamicFieldWidgetState extends State<DynamicFieldWidget> {
  bool isPicklist() {

    return widget.field.type
            .toLowerCase()
            .contains("picklist") ||
        widget.field.type
            .toLowerCase()
            .contains("metricpicklist");
  }

  bool isReferenceField() {

    return widget.field.fieldName
            .toLowerCase()
            .contains("account") ||
        widget.field.fieldName
            .toLowerCase()
            .contains("organization");
  }

  @override
  Widget build(BuildContext context) {

    /// PICKLIST FIELD

    if (isPicklist()) {

      final values =
          widget.field.picklistValues ?? [];

      return Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(

            widget.field.label,

            style: const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField(

            value: widget.dropdownValue,

            decoration: InputDecoration(

              filled: true,

              fillColor: Colors.white,

              border:
                  OutlineInputBorder(

                borderRadius:
                    BorderRadius.circular(
                  16,
                ),

                borderSide:
                    BorderSide(
                  color:
                      Colors.grey.shade300,
                ),
              ),

              enabledBorder:
                  OutlineInputBorder(

                borderRadius:
                    BorderRadius.circular(
                  16,
                ),

                borderSide:
                    BorderSide(
                  color:
                      Colors.grey.shade300,
                ),
              ),
            ),

            items:
                values.map<
                    DropdownMenuItem>(
              (item) {

                return DropdownMenuItem(

                  value:
                      item["value"],

                  child: Text(
                    item["label"]
                        .toString(),
                  ),
                );
              },
            ).toList(),

            onChanged: widget.onChanged,
          ),
        ],
      );
    }

    /// REFERENCE FIELD

    if (isReferenceField()) {

      return Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(

            widget.field.label,

            style: const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          InkWell(

            onTap: () async {

              String moduleName =
                  "Accounts";

              final selected =
                  await Navigator.push(

                context,

                MaterialPageRoute(

                  builder:
                      (context) =>
                          RelationListView(

                    moduleName:
                        moduleName,
                  ),
                ),
              );

              if (selected != null) {

  setState(() {

    widget.controller.text =
        selected["label"] ?? "";
  });

  if (widget.onChanged != null) {

    widget.onChanged!(selected);
  }
}
            },

            child: Container(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
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

              child: Row(

                children: [

                  Expanded(

                    child: Text(

                      widget.controller
                              .text
                              .isEmpty
                          ? "Type to search"
                          : widget.controller
                              .text,

                      style: TextStyle(

                        fontSize: 16,

                        color: widget.controller
                                .text
                                .isEmpty
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),

                  Container(

                    padding:
                        const EdgeInsets.all(
                      12,
                    ),

                    decoration:
                        BoxDecoration(

                      border: Border(

                        left: BorderSide(
                          color: Colors
                              .grey
                              .shade300,
                        ),
                      ),
                    ),

                    child: const Icon(
                      Icons.add,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    /// NORMAL TEXT FIELD

    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(

          widget.field.label,

          style: const TextStyle(
            fontSize: 16,
            fontWeight:
                FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        TextField(

          controller: widget.controller,

          decoration: InputDecoration(

            hintText:
                "Enter ${widget.field.label}",

            filled: true,

            fillColor: Colors.white,

            border:
                OutlineInputBorder(

              borderRadius:
                  BorderRadius.circular(
                16,
              ),

              borderSide:
                  BorderSide(
                color:
                    Colors.grey.shade300,
              ),
            ),

            enabledBorder:
                OutlineInputBorder(

              borderRadius:
                  BorderRadius.circular(
                16,
              ),

              borderSide:
                  BorderSide(
                color:
                    Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}