import 'package:flutter/material.dart';

import '../../../viewModels/common/list/list_viewmodel.dart';
import '../../../widgets/task_list_item.dart';
import '../../../utils/session_manager.dart';
import '../../login_view.dart';
import '../../../services/api_service.dart';
import '../menu/menu_view.dart';
import '../../quick_create_view.dart';

class ModuleListView extends StatefulWidget {
  final String moduleName;

  const ModuleListView({
    super.key,
    required this.moduleName,
  });

  @override
  State<ModuleListView> createState() =>
      _ModuleListViewState();
}

class _ModuleListViewState
    extends State<ModuleListView> {
  late ListViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = ListViewModel(
      moduleName: widget.moduleName,
    );

    loadData();
  }

  /// LOAD RECORDS
  Future<void> loadData() async {
    setState(() {
      viewModel.isLoading = true;
    });

    await viewModel.init();

    setState(() {
      viewModel.isLoading = false;
    });
  }

  /// REFRESH AFTER EDIT/DELETE
  Future<void> refreshList() async {
    await loadData();
  }

  /// LOGOUT
  Future<void> logout() async {
    try {
      String crmUrl =
          await SessionManager.getCrmUrl();

      String session =
          await SessionManager.getSession();

      /// SERVER LOGOUT
      await ApiService.logout(
        crmUrl: crmUrl,
        session: session,
      );

      /// CLEAR LOCAL SESSION
      await SessionManager.clearSession();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder:
              (context) => const LoginView(),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// CREATE TASK BUTTON
      floatingActionButton:
          FloatingActionButton(

  onPressed: () async {

    final result =
        await Navigator.push(

      context,

      MaterialPageRoute(

        builder:
            (context) =>
                const QuickCreateView(),
      ),
    );

    if (result == true) {

      await loadData();
    }
  },

  child: const Icon(Icons.add),
),


      /// DRAWER
      drawer: const MenuView(),

      /// APP BAR
      appBar: AppBar(
        title: Text(widget.moduleName),

        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),

      /// BODY
      body:
          viewModel.isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )
              : viewModel.records.isEmpty
                  ? const Center(
                      child: Text(
                        "No Records Found",
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: refreshList,

                      child: ListView.builder(
                        itemCount:
                            viewModel.records.length,

                        itemBuilder:
                            (context, index) {
                          return TaskListItem(
                            record:
                                viewModel.records[index],

                            moduleModel:
                                viewModel.moduleModel,

                            moduleName:
                                widget.moduleName,

                            onRefresh:
                                refreshList,
                          );
                        },
                      ),
                    ),
    );
  }
}