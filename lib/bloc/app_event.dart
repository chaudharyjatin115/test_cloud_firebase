import 'package:flutter/foundation.dart' show immutable;
// base class
@immutable
abstract class AppEvent {
  const AppEvent();
}
// in this event we need to show image picker so we need the absolute path of the file to upload to firebase storage
@immutable
class AppEventUploadImage implements AppEvent {
  //path of file to upload
  final String filePathUpload;

  const AppEventUploadImage({
    required this.filePathUpload,
  });
}
// this event happens when user wants to delete the acccountV
@immutable
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogOut implements AppEvent {
  const AppEventLogOut();
}

@immutable
class AppEventInitialize implements AppEvent {
  const AppEventInitialize();
}

@immutable
class AppEventEmailLogIn implements AppEvent {
  // this carries the payload of email and password to bloc
  final String password;
  final String email;

  const AppEventEmailLogIn({required this.password, required this.email});
}

@immutable
class AppEventGoToRegistration implements AppEvent {
  // this event would be given when we click on register screen
  // and decided by bloc which view to show
  const AppEventGoToRegistration();
}

@immutable
class AppEventGoToLogin implements AppEvent {
  const AppEventGoToLogin();
}

@immutable
class AppEventRegister implements AppEvent {
  final String password;
  final String email;

  const AppEventRegister({required this.password, required this.email});
}
