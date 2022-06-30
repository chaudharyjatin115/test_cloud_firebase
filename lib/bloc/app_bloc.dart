import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_cloud_firebase/auth/auth_error.dart';
import 'package:test_cloud_firebase/bloc/app_event.dart';
import 'package:test_cloud_firebase/bloc/app_state.dart';
import 'package:test_cloud_firebase/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  // the default(initial) app state is logged out
  AppBloc()
      : super(
          const AppStateLoggedOut(isLoading: false),
        ) {
    // handle uploading images
    on<AppEventUploadImage>(
      (event, emit) async {
        // getting user from state
        final user = state.user;
        // checking if user is not null if user is not valid log the user out
        if (user == null) {
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
          // checking against null and returning user you could also use else statement to
          return;
        }
        // start the loading process
        emit(AppStateLoggedIn(
            user: user,
            //if we cant get the images return an empty iterable
            images: state.images ?? [],
            isLoading: true));
//starting uploaging a photo
        // creating a file refrence from the event which has a property of string
        final file = File(event.filePathUpload);
        // upload a file
        await uploadImage(file: file, userId: user.uid);
// after the upload is complete grab the file refrence latest to show
        final images = await _getImages(user.uid);
        // emit the new images and turn off loading
        emit(
          AppStateLoggedIn(user: user, images: images, isLoading: false),
        );
      },
    );

    // handle account deletetion to delete the account we need to
    on<AppEventDeleteAccount>((event, emit) async {
      // getting the current user we could also state . user to get the user
      final user = FirebaseAuth.instance.currentUser;
      //log the user out if theres no current user and show a loading overlay
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: true));
        return;
      }
      // start loading
      emit(
        AppStateLoggedIn(
            user: user, images: state.images ?? [], isLoading: true),
      );
      //
      // delete the user folder
      try {
// getting the refrence to the folder this is gonna give the folder whos name is equal to users uid
        final folderContents =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        // going through all the contents of the folder and delete them one at a time
        for (final item in folderContents.items) {
          // we are leaving the error handling portion  by not working on it  leaving it for letter
          await item.delete().catchError((_) {}); // handle the error

        }
        // deleting the folder itself
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {}); // handle the error later
        // delete the user
        await user.delete();
        // log out the user
        await FirebaseAuth.instance.signOut();
        //logging out the user in ui as well
        emit(const AppStateLoggedOut(isLoading: false));
      }
      // catching the error with firebase auth exception and showing the error with factory
      on FirebaseAuthException catch (e) {
        emit(AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: false,
            authError: AuthError.from(e)));
      } on FirebaseException {
        // we might not be able to delete the folder
        //kogging the user out you could emit any error you want
        emit(const AppStateLoggedOut(isLoading: false));
      }
    });
//log out event
    on<AppEventLogOut>((event, emit) async {
      await FirebaseAuth.instance.signOut();
      emit(const AppStateLoggedOut(isLoading: false));
    });

    // intializing the app
    on<AppEventInitialize>(
      (event, emit) async {
//get the current user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(const AppStateLoggedOut(isLoading: false));
        } else {
          // go grab the users uploaded images
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(user: user, images: images, isLoading: false),
          );
        }
      },
    );

    // register the user
    on<AppEventRegister>(
      (event, emit) async {
        // start loading
        emit(
          const AppStateIsInRegistrationView(isLoading: true),
        );
// getting the email and password from event
        final email = event.email;
        final password = event.password;
        try {
          // creating the user with email and password
          final credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          // get user images with uid
          emit(AppStateLoggedIn(
              user: credential.user!, images: [], isLoading: false));
        } // throwin up an error
        on FirebaseAuthException catch (e) {
          emit(
            AppStateIsInRegistrationView(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );
    // handling going to login
    on<AppEventGoToLogin>(
      (event, emit) {
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
      },
    );
    //handling  the login event
    on<AppEventEmailLogIn>(
      (event, emit) async {
        // while we are on login screen the first state would be logout and coz we are loading so loading property would be true
        emit(const AppStateLoggedOut(isLoading: true));

        try {
          // logging in the user by getting the email and password from event and creating a credential
          final email = event.email;
          final password = event.password;
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
// getting the user from user credential
          final user = credential.user!;
          // getting the user images
          final images = await _getImages(user.uid);
          // emitting the app state logged in on successful login
          emit(AppStateLoggedIn(user: user, images: images, isLoading: false));
          //
        } on FirebaseAuthException catch (e) {
          // emiting the logged out state on firebase exception
          emit(AppStateLoggedOut(
              isLoading: false, authError: AuthError.from(e)));
        }
      },
    );
    on<AppEventGoToRegistration>((event, emit) {
      // emiting the app state logged out
      emit(const AppStateIsInRegistrationView(isLoading: false));
    });
  }
  // we need  to define a few helper functions to rertrive a particular persons stored images
  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId) // this  would grab a folder whos equal to userid
          .list()
          .then((listResult) => listResult.items);
}
