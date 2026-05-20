import 'package:flutter/material.dart';

import '../../../utils/session_manager.dart';
import '../../../views/login_view.dart';
import '../list/moduleListView.dart';
import '../../../services/api_service.dart';

class MenuView extends StatefulWidget {

  const MenuView({super.key});

  @override
  State<MenuView> createState() =>
      _MenuViewState();
}

class _MenuViewState
    extends State<MenuView> {

  final TextEditingController
      searchController =
          TextEditingController();

  String searchText = "";

  final List<Map<String, dynamic>>
      menuSections = [

    {
      "title": "Favourites",

      "icon": Icons.star,

      "color": Colors.orange,

      "expanded": true,

      "items": [
        {
          "name":"Leads",
          "icon": Icons.badge_outlined,
        },

        {
          "name": "Tasks",
          "icon": Icons.checklist,
        },

        {
          "name": "Contacts",
          "icon": Icons.person_outline,
        },

        {
          "name": "Documents",
          "icon": Icons.description_outlined,
        },
      ],
    },

    {
      "title": "SALES",

      "icon": Icons.handshake_outlined,

      "color": Colors.green,

      "expanded": false,

      "items": [

        {
          "name": "Deals",
          "icon": Icons.currency_rupee,
        },

        {
          "name": "Quotes",
          "icon": Icons.description_outlined,
        },

        {
          "name": "Sales Orders",
          "icon": Icons.receipt_long_outlined,
        },
      ],
    },

    {
      "title": "Projects",

      "icon": Icons.work_outline,

      "color": Colors.lightBlue,

      "expanded": false,

      "items": [

        {
          "name": "Tasks",
          "icon": Icons.checklist,
        },

        {
          "name": "Projects",
          "icon": Icons.work_outline,
        },

        {
          "name": "Timelogs",
          "icon": Icons.history,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Drawer(

      backgroundColor:
          const Color(0xFFF5F5F5),

      child: SafeArea(

        child: Column(

          children: [

            /// TOP BAR

            Container(

              padding:
                  const EdgeInsets.symmetric(

                horizontal: 20,

                vertical: 12,
              ),

              child: Row(

                children: [

                  /// CLOSE BUTTON

                  InkWell(

                    onTap: () {

                      Navigator.pop(context);
                    },

                    child: Container(

                      width: 50,

                      height: 50,

                      decoration:
                          BoxDecoration(

                        color:
                            const Color(
                          0xFF4B6BFB,
                        ),

                        borderRadius:
                            BorderRadius
                                .circular(
                          12,
                        ),
                      ),

                      child: const Icon(

                        Icons.close,

                        color:
                            Colors.white,
                      ),
                    ),
                  ),

                  const Spacer(),

                  const Text(

                    "MENU",

                    style: TextStyle(

                      fontSize: 30,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  const Icon(

                    Icons.settings_outlined,

                    size: 34,
                  ),
                ],
              ),
            ),

            Expanded(

              child: ListView(

                padding:
                    const EdgeInsets.all(16),

                children: [

                  /// SEARCH

                  Container(

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),

                    decoration:
                        BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),

                    child: TextField(

                      controller:
                          searchController,

                      onChanged: (value) {

                        setState(() {

                          searchText =
                              value
                                  .toLowerCase();
                        });
                      },

                      decoration:
                          const InputDecoration(

                        border:
                            InputBorder.none,

                        hintText:
                            "Search menu items",
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  ...menuSections.map((section) {

                    return buildSection(section);

                  }).toList(),
                ],
              ),
            ),

            /// BOTTOM

            Container(

              padding:
                  const EdgeInsets.symmetric(

                horizontal: 18,

                vertical: 16,
              ),

              color: Colors.white,

              child: Row(

                children: [

                  CircleAvatar(

                    radius: 28,

                    backgroundColor:
                        Colors.lightBlue
                            .shade100,

                    child: const Text(

                      "AD",

                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  const Expanded(

                    child: Text(

                      "Administrator",

                      style: TextStyle(

                        fontSize: 20,

                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ),

                  InkWell(

                    onTap: () async {

                      try {

                          String crmUrl =await SessionManager.getCrmUrl();
                          String session =await SessionManager.getSession();
                          /// SERVER LOGOUT
                          await ApiService.logout(

                                crmUrl: crmUrl,

                                session: session,
                                );
                           /// CLEAR LOCAL SESSION

                           await SessionManager.clearSession();

                          if (!mounted) return;

                           Navigator.pushAndRemoveUntil( context,

                           MaterialPageRoute(
                           builder:
                          (_) => const LoginView(),
                           ),

                          (route) => false,
                             );
    
                       } catch (e) {
                           print(e);
                           }
                    },
                    child: Row(

                      children: [

                        Icon(

                          Icons.power_settings_new,

                          color:
                              Colors.red.shade400,

                          size: 34,
                        ),

                        const SizedBox(width: 8),

                        const Text(

                          "Sign Out",

                          style: TextStyle(

                            fontSize: 20,
                          ),
                        ),
                      ],
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

  /// SECTION

  Widget buildSection(
    Map<String, dynamic> section,
  ) {

    bool expanded =
        section["expanded"];

    List items =
        section["items"];

    /// SEARCH FILTER

    if (searchText.isNotEmpty) {

      items =
          items.where((item) {

        return item["name"]
            .toString()
            .toLowerCase()
            .contains(searchText);

      }).toList();

      if (items.isEmpty) {

        return const SizedBox();
      }

      expanded = true;
    }

    return Container(

      margin:
          const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Column(

        children: [

          /// SECTION HEADER

          InkWell(

            onTap: () {

              setState(() {

                section["expanded"] =
                    !section["expanded"];
              });
            },

            child: Padding(

              padding:
                  const EdgeInsets.all(22),

              child: Row(

                children: [

                  Icon(

                    section["icon"],

                    color:
                        section["color"],

                    size: 34,
                  ),

                  const SizedBox(width: 18),

                  Expanded(

                    child: Text(

                      section["title"],

                      style: const TextStyle(

                        fontSize: 22,

                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),

                  Icon(

                    expanded

                        ? Icons.keyboard_arrow_up

                        : Icons.keyboard_arrow_down,

                    color: Colors.grey,

                    size: 34,
                  ),
                ],
              ),
            ),
          ),

          /// ITEMS

          if (expanded)

            Padding(

              padding:
                  const EdgeInsets.only(

                left: 22,

                right: 22,

                bottom: 20,
              ),

              child: Column(

                children:
                    items.map<Widget>((item) {

                  return Padding(

                    padding:
                        const EdgeInsets.only(
                      bottom: 18,
                    ),

                    child: InkWell(

                      onTap: () {

                        openModule(
                          item["name"],
                        );
                      },

                      child: Row(

                        children: [

                          Container(

                            width: 54,

                            height: 54,

                            decoration:
                                BoxDecoration(

                              color: Colors
                                  .grey
                                  .shade100,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),
                            ),

                            child: Icon(

                              item["icon"],

                              size: 30,
                            ),
                          ),

                          const SizedBox(
                            width: 20,
                          ),

                          Expanded(

                            child: Text(

                              item["name"],

                              style:
                                  const TextStyle(

                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  /// OPEN MODULE

  void openModule(
    String moduleName,
  ) {

    Navigator.pop(context);

    Navigator.push(

      context,

      MaterialPageRoute(

        builder:
            (_) => ModuleListView(

          moduleName: moduleName,
        ),
      ),
    );
  }
}