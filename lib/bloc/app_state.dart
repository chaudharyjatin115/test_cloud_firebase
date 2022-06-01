import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:test_cloud_firebase/auth/auth_error.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;
  final User? user;

  const AppState({required this.isLoading, this.authError, this.user});
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn(
      {required this.user,
      required this.images,
      required bool isLoading,
      AuthError? authError})
      : super(isLoading: isLoading, authError: authError);
  //loading the list when new images are added

  @override
  bool operator ==(other) {
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length == otherClass.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(user.uid, images);
}

@immutable
class AppStateLoggedOut extends AppState {
  AppStateLoggedOut({
    required bool isLoading,
    AuthError? authError,
  }) : super(isLoading: isLoading, authError: authError);
  @override
  String toString() =>
      'AppStateLoggedOut,isLoadin=$isLoading,authError=$authError';
}

@immutable
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView(
      {required bool isLoading, AuthError? authError})
      : super(isLoading: isLoading, authError: authError);
}

//extract user from appstate
extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}
