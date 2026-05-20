import 'package:flutter/material.dart';

import '../../../viewModels/common/list/list_viewmodel.dart';
import '../../../widgets/task_list_item.dart';
import '../../../utils/session_manager.dart';
import '../../login_view.dart';
import '../../../services/api_service.dart';
import '../../create_task_view.dart';
import '../menu/menu_view.dart';
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

class _ModuleListViewState extends State<ModuleListView> {

  late ListViewModel viewModel;

  @override
  void initState() {

    super.initState();

    viewModel = ListViewModel(
      moduleName: widget.moduleName,
    );

    loadData();
  }

  Future<void> loadData() async {

    await viewModel.init();

    setState(() {});
  }
Future<void> logout() async {

  try {

    String crmUrl =
        await SessionManager.getCrmUrl();

    String session = await SessionManager.getSession();

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
            (context) =>
                const LoginView(),
      ),

      (route) => false,
    );

  } catch (e) {

    print(e);
  }
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      floatingActionButton:

    FloatingActionButton(

      onPressed: () async {

        final result =
            await Navigator.push(

          context,

          MaterialPageRoute(

            builder:
                (context) =>

                    const CreateTaskView(),
          ),
        );

        /// REFRESH AFTER CREATE

        if (result == true) {

          await loadData();
        }
      },

      child: const Icon(Icons.add),
    ),

    drawer: const MenuView(),

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
      body:
          viewModel.isLoading

              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : ListView.builder(

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
                    );
                  },
                ),
    );
  }
}