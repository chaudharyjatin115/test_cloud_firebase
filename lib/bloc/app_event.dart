import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class AppEventUploadImage implements AppEvent {
  final String filePathUpload;

  const AppEventUploadImage({
    required this.filePathUpload,
  });
}

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
class AppEventLogIn implements AppEvent {
  final String password;
  final String email;

  const AppEventLogIn({required this.password, required this.email});
}

@immutable
class AppEventGoToRegistration implements AppEvent {
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
