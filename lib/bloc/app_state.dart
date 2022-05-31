import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:test_cloud_firebase/auth/auth_error.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState(this.isLoading, this.authError);
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn(
      {required this.user,
      required this.images,
      required bool isLoading,
      required AuthError? authError})
      : super(isLoading, authError);
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
  const AppStateLoggedOut(bool isLoading, AuthError? authError)
      : super(isLoading, authError);
  @override
  String toString() =>
      'AppStateLoggedOut,isLoadin=$isLoading,authError=$authError';
}

@immutable
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView(bool isLoading, AuthError? authError)
      : super(isLoading, authError);
}

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
