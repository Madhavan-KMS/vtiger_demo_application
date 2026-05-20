import 'package:flutter/material.dart';

import '../viewModels/login_viewmodel.dart';
import 'common/list/moduleListView.dart';

class LoginView extends StatefulWidget {

  const LoginView({super.key});

  @override
  State<LoginView> createState() =>
      _LoginViewState();
}

class _LoginViewState
    extends State<LoginView> {

  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final LoginViewModel viewModel =
      LoginViewModel();

  bool isLoading = false;

  Future<void> login() async {

    setState(() {
      isLoading = true;
    });

    bool success =
        await viewModel.login(

      username:
          usernameController.text,

      password:
          passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {

      if (!mounted) return;

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder:
              (context) =>

                  const ModuleListView(
                    moduleName: "Tasks",
                  ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Login"),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(

              controller:
                  usernameController,

              decoration:
                  const InputDecoration(
                labelText: "Username",
              ),
            ),

            const SizedBox(height: 20),

            TextField(

              controller:
                  passwordController,

              obscureText: true,

              decoration:
                  const InputDecoration(
                labelText: "Password",
              ),
            ),

            const SizedBox(height: 30),

            isLoading

                ? const CircularProgressIndicator()

                : ElevatedButton(

                    onPressed: login,

                    child:
                        const Text("LOGIN"),
                  ),
          ],
        ),
      ),
    );
  }
}