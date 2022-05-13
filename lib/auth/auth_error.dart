


import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {'user not found':AuthErrorUserNotFound(),
'weak password ':AuthErrorWeakPasswordError(),
'invalid-email':AuthErrorInvalidEmail(),
'operation-not-allowed':AuthErrorOperationNotAllowed(),
'email-already-in-use':AuthErrorEmailAlreadyInUse(),
'requires-recent-login':AuthErrorRequiresRecentLogin(),
'no-current-user':AuthErrorNoCurrentUser()

};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({required this.dialogTitle, required this.dialogText});
  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
    const AuthErrorUnknown();
}
@immutable
class AuthErrorUnknown extends AuthError{
 const  AuthErrorUnknown() : super(dialogTitle:'Authentication Error', dialogText: 'Unknown authentication Error');

}
@immutable
class AuthErrorNoCurrentUser extends AuthError {
const  AuthErrorNoCurrentUser()
      : super(
            dialogTitle:
            'no current user!',
            dialogText: 'No user with this information');
}

@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
 const  AuthErrorRequiresRecentLogin()
      : super(
            dialogTitle: 'Requires recent Login',
            dialogText: 'You need to login and log back in again in order to perform this operation');
}
@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed() 

  
      : super(
            dialogTitle: 'Operation Not allowed',
            dialogText: 'You cannot register using this method at this moment');
}
@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
            dialogTitle: 'User not Found',
            dialogText:'The given user was not found on the server');
}
@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
            dialogTitle: 'Invalid email ',
            dialogText: 'please double check the email and try again');
}
@immutable
class AuthErrorWeakPasswordError extends AuthError{
const   AuthErrorWeakPasswordError() : super(dialogTitle: 'Weak password', dialogText:'Please choose a strong password');
  
}
@immutable
class AuthErrorEmailAlreadyInUse extends AuthError{
 const  AuthErrorEmailAlreadyInUse() : super(dialogTitle: 'Email already in use', dialogText:'this email is already registered with a user');

}