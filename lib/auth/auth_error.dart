import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
// importing the only needed portion of library
import 'package:flutter/foundation.dart' show immutable;

//defining an empty error maping
//maping the firebase errors to local class instances and using them
// error  and which class do i need for that error
// maps key would be error from firebase exceptio
//n as value
const Map<String, AuthError> authErrorMapping = {
//mapping the auth error from firebase auth to our class the string from firebase auth exception  is key and value is our class
// we need to map the errors to a class so we dont need the if else statements to bloat our code
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'no-current-user': AuthErrorNoCurrentUser(),
  // error code in string    //creating a instance of the said class
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'email-already-in-user': AuthErrorEmailAlreadyInUse(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'permission denied': AuthErrorPermissionDenied(),
};

//base auth error class
@immutable
abstract class AuthError {
//auth error needs a dialog to show when it occurs
  final String dialogTitle;
  final String dialogText;
// making these properties required because they are needed in error dialogs
  const AuthError({required this.dialogTitle, required this.dialogText});

  factory AuthError.from(FirebaseAuthException exception) =>
      //this is used to take exception from firebase Auth and provide it to dialog
//adding error to map if its not known then add authEroor unknown
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      const AuthErrorUnknown();
}

// this error whould be returned if we are not handling the particular error
@immutable
class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
            dialogTitle: 'Authentication Error',
            dialogText: 'unknown Authentication Error');
}

@immutable
// this error would be thrown if the user isnt found in databse
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
            dialogTitle: 'No current user',
            dialogText: ' no current user with this information was found');
}

@immutable
// this error would be thrown if the user hasnt recently logged in
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
            dialogTitle: 'Requires Recent Login',
            dialogText:
                'You need to log out and log back in again in order to perform operation');
}

@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
            dialogTitle: 'Operation Not Allowed',
            dialogText:
                ' You cannot register using this method at this moment');
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
            dialogTitle: 'user not found',
            dialogText: 'The given user was not found on the server');
}

@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
            dialogTitle: 'Weak Password',
            dialogText: 'Please choose a stronger password');
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
            dialogTitle: 'Invalid Email',
            dialogText: 'Please double check the password and try again');
}

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
            dialogTitle: 'Email already used by other user',
            dialogText: 'Please try other email');

}

@immutable
class AuthErrorPermissionDenied extends AuthError {
  const AuthErrorPermissionDenied()
      : super(
            dialogTitle: 'You dont have permission ',
            dialogText: 'user dont have permission ');
}
