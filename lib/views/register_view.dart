import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_cloud_firebase/bloc/app_bloc.dart';
import 'package:test_cloud_firebase/bloc/app_event.dart';
import 'package:test_cloud_firebase/extensions/if_debugging.dart';

class RegistrationView extends HookWidget {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
        text: 'chaudharyjatin115@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: 'J-56789albdb'.ifDebugging);

    return Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'enter your email'),
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.dark,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration:
                    const InputDecoration(hintText: 'enter your password here'),
              ),
              TextButton(
                child: const Text('Register'),
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  context
                      .read<AppBloc>()
                      .add(AppEventRegister(email: email, password: password));
                },
              ),
              TextButton(
                child: const Text('already registered ? log in here '),
                onPressed: () {
                  context.read<AppBloc>().add(const AppEventGoToLogin());
                },
              )
            ],
          ),
        ));
  }
}
