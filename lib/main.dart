import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_cloud_firebase/bloc/app_event.dart';
import 'package:test_cloud_firebase/bloc/app_state.dart';
import 'package:test_cloud_firebase/dialogs/show_auth_error.dart';
import 'package:test_cloud_firebase/firebase_options.dart';
import 'package:test_cloud_firebase/loading/loading_screen.dart';
import 'package:test_cloud_firebase/views/apps.dart';
import 'package:test_cloud_firebase/views/login_view.dart';
import 'package:test_cloud_firebase/views/photo_gallery_view.dart';
import 'package:test_cloud_firebase/views/register_view.dart';

import 'bloc/app_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        //providing our bloc to whole app
        BlocProvider<AppBloc>(
      // after initializing our app we are going to send an initialize event to app bloc and initialize app
      create: (_) => AppBloc()..add(const AppEventInitialize()),
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.purple),
        // listenig part would do side effects and builder is gonna return  widgets aka ui
        home: BlocConsumer<AppBloc, AppState>(
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegistrationView();
            } else {
              // this should never happen
              return Container();
            }
          },
          listener: (context, appState) {
            if (appState.isLoading) {
              return LoadingScreen.instance()
                  .show(context: context, text: 'loading...');
            } else {
              LoadingScreen.instance().hide();
            }
            // we are going to deal with every auth error in one place
            final authError = appState.authError;
            if (authError != null) {
              showAuthError(authError: authError, context: context);
            }
          },
        ),
      ),
    );
  }
}
