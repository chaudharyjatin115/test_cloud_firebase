// hook widget is used to have text editing controller in stl widgets

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:test_cloud_firebase/bloc/app_bloc.dart';
import 'package:test_cloud_firebase/bloc/app_event.dart';
import 'package:test_cloud_firebase/extensions/if_debugging.dart';

class LoginView extends HookWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(
        // these text in usetextEditingController would only show up in text fields only if we are debugging the app
        text: 'chaudharyjatin115@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: 'J-56789albdb'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration:
                  const InputDecoration(hintText: 'enter your email  here '),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
              controller: emailController,
            ),
            TextField(
              // this is used to show charachters which to you want to obscure the password with
              // obscuringCharacter:'' ,
              obscureText: true,
              decoration:
                  const InputDecoration(hintText: 'enter you password here'),
              keyboardAppearance: Brightness.dark,
              controller: passwordController,
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                // sending the password and email to bloc with read
                context
                    .read<AppBloc>()
                    .add(AppEventEmailLogIn(password: password, email: email));
              },
              child: const Text('log in '),
            ),
            TextButton(
              onPressed: () {
                // dispatching events and sending you to registration view on click
                context.read<AppBloc>().add(const AppEventGoToRegistration());
              },
              child: const Text('Not registered yet ?register here '),
            ),
          ],
        ),
      ),
    );
  }
}
