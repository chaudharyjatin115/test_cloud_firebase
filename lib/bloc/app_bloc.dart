import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_cloud_firebase/auth/auth_error.dart';

import 'package:test_cloud_firebase/bloc/app_event.dart';
import 'package:test_cloud_firebase/bloc/app_state.dart';
import 'package:test_cloud_firebase/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppStateLoggedOut(isLoading: false)) {
    on<AppEventGoToLogin>((event, emit) {
      emit(AppStateLoggedOut(isLoading: false));
    });
    on<AppEventGoToRegistration>((event, emit) {
      emit(const AppStateIsInRegistrationView(isLoading: false));
    });
    //handle login
    on<AppEventLogIn>((event, emit) async {
      emit(AppStateLoggedOut(isLoading: true));
      //login user

      try {
        final email = event.email;
        final password = event.password;
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        //get images for user
        final user = userCredential.user!;
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(user: user, images: images, isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedOut(isLoading: false, authError: AuthError.from(e)));
      }
    });
    //handle going to login screen

    on<AppEventGoToLogin>((event, emit) {
      emit(AppStateLoggedOut(isLoading: false));
    });
    //initialize the registration view
    on<AppEventRegister>(
      (event, emit) async {
        //start loading
        emit(const AppStateIsInRegistrationView(isLoading: true));
        final email = event.email;
        final password = event.password;
        try {
          //getting credentials
          final credentials = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          emit(AppStateLoggedIn(
              user: credentials.user!, images: [], isLoading: false));
        } on FirebaseAuthException catch (e) {
          emit(AppStateIsInRegistrationView(
              isLoading: false, authError: AuthError.from(e)));
        }
      },
    );
    //handle the app initialization
    on<AppEventInitialize>((event, emit) async {
      final user = await FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AppStateLoggedOut(isLoading: false));
      } else {
        //go grab the users uploaded images
        final image = await _getImages(user.uid);
        emit(AppStateLoggedIn(user: user, images: image, isLoading: false));
      }
    });

    //handle loggging out

    on<AppEventLogOut>(
      (event, emit) async {
        emit(
          (AppStateLoggedOut(isLoading: true)),
        );
        await FirebaseAuth.instance.signOut();
        emit(
          AppStateLoggedOut(isLoading: false),
        );
      },
    );
    //handle account deletetion
    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        //log the user out if we dont have a current user
        if (user == null) {
          emit(AppStateLoggedOut(isLoading: false));
          return;
        }
        //start loading
        emit(AppStateLoggedIn(
            user: user, images: state.images ?? [], isLoading: true));
        //delete the user folder
        try {
          //delete the user folder
          final files = await FirebaseStorage.instance.ref(user.uid).listAll();
          for (final item in files.items) {
            item.delete().catchError((_) {}); //maybe handle the error
          }
          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});
          //delete the user
          await user.delete();
          //log the user out
          await FirebaseAuth.instance.signOut();
          emit(AppStateLoggedOut(isLoading: false));
        } on FirebaseAuthException catch (e) {
          emit(AppStateLoggedIn(
              user: user,
              images: state.images ?? [],
              isLoading: false,
              authError: AuthError.from(e)));
        } on FirebaseException {
          //we might not be able to delete the folder
          //log the user out
          emit(AppStateLoggedOut(isLoading: false));
        }
      },
    );
    //handle uploading images
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;
        //log user out if we dont have valid user;
        if (user == null) {
          emit(AppStateLoggedOut(isLoading: false));
          return;
        } //start loading process
        emit(
          AppStateLoggedIn(
              user: user, images: state.images ?? [], isLoading: false),
        );
        final file = File(event.filePathUpload);
        await uploadImage(file: file, userId: user.uid);
        //after upload is complete grab the latest file refrence
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(user: user, images: images, isLoading: false));
      },
    );
  }
  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
