import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/session_manager.dart';

class RelationListView extends StatefulWidget {

  final String moduleName;

  const RelationListView({

    super.key,

    required this.moduleName,
  });

  @override
  State<RelationListView> createState() =>
      _RelationListViewState();
}

class _RelationListViewState
    extends State<RelationListView> {

  bool isLoading = true;

  List<dynamic> records = [];

  List<dynamic> filteredRecords = [];

  final searchController =
      TextEditingController();

  @override
  void initState() {

    super.initState();

    loadRecords();
  }

  Future<void> loadRecords() async {

  try {

    String crmUrl =
        await SessionManager.getCrmUrl();

    String session =
        await SessionManager.getSession();

    final response =
        await ApiService.fetchRecords(

      crmUrl: crmUrl,

      session: session,

      moduleName:
          widget.moduleName,
    );

    /// DIRECT LIST RESPONSE

    if (response is List) {

      records =
          List<dynamic>.from(response);

    } else {

      records = [];
    }

    filteredRecords = records;

  } catch (e) {

    print(e);

    records = [];

    filteredRecords = [];

  } finally {

    isLoading = false;

    if (mounted) {

      setState(() {});
    }
  }
}
  void search(String value) {

    filteredRecords =
        records.where((record) {

      final name =
          (record["label"] ?? "")
              .toString()
              .toLowerCase();

      return name.contains(
        value.toLowerCase(),
      );

    }).toList();

    setState(() {});
  }

  Widget buildRecordCard(
    dynamic record,
  ) {

    return GestureDetector(

      onTap: () {

        Navigator.pop(
          context,
          record,
        );
      },

      child: Container(

        margin:
            const EdgeInsets.symmetric(

          horizontal: 16,

          vertical: 8,
        ),

        padding:
            const EdgeInsets.all(16),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(20),

          boxShadow: [

            BoxShadow(

              color:
                  Colors.black.withOpacity(
                0.05,
              ),

              blurRadius: 10,

              offset:
                  const Offset(0, 4),
            ),
          ],
        ),

        child: Row(

          children: [

            CircleAvatar(

              radius: 28,

              backgroundColor:
                  Colors.blue.shade100,

              child: Text(

                (
                  record["label"] ??
                  "A"
                )
                    .toString()
                    .substring(0, 1)
                    .toUpperCase(),

                style: TextStyle(

                  fontSize: 22,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      Colors.blue.shade700,
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    record["label"] ??
                        "",

                    style:
                        const TextStyle(

                      fontSize: 20,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(

                    record[
                            "assigned_user_id_label"] ??
                        "",

                    style:
                        TextStyle(

                      color:
                          Colors.grey.shade600,

                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Colors.grey.shade200,

      appBar: AppBar(

        backgroundColor:
            Colors.blue,

        foregroundColor:
            Colors.white,

        elevation: 0,

        title: Text(
          widget.moduleName,
        ),
      ),

      body:
          isLoading

              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : Column(

                  children: [

                    Container(

                      color: Colors.blue,

                      padding:
                          const EdgeInsets.only(

                        left: 16,

                        right: 16,

                        bottom: 20,
                      ),

                      child: TextField(

                        controller:
                            searchController,

                        onChanged:
                            search,

                        decoration:
                            InputDecoration(

                          hintText:
                              "Type to search",

                          filled: true,

                          fillColor:
                              Colors.white,

                          contentPadding:
                              const EdgeInsets.symmetric(

                            horizontal: 18,

                            vertical: 16,
                          ),

                          border:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),

                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    Expanded(

                      child:
                          filteredRecords
                                  .isEmpty

                              ? const Center(

                                  child: Text(

                                    "No Records Found",

                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                )

                              : ListView.builder(

                                  padding:
                                      const EdgeInsets.only(
                                    top: 10,
                                    bottom: 20,
                                  ),

                                  itemCount:
                                      filteredRecords
                                          .length,

                                  itemBuilder:
                                      (
                                        context,
                                        index,
                                      ) {

                                    final record =
                                        filteredRecords[
                                            index];

                                    return buildRecordCard(
                                      record,
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
    );
  }
}