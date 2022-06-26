import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:test_cloud_firebase/auth/auth_error.dart';

@immutable
// this is called superclass
abstract class AppState {
  // this is the base class any instances of this class would gave three properties
  final bool isLoading;
  // this decides if app is loading or not and trigger the loading overlay
  final AuthError? authError;
  // auth error is optional
  final User? user;

  const AppState({required this.isLoading, this.authError, this.user});
}
//                           subClassing



@immutable
// extending means  it going to use the properties of superclass without implementing the those properties

class AppStateLoggedIn extends AppState {
  // when you are logged in you just need user and refrence of iterable of all the images
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
  const AppStateLoggedOut({
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
