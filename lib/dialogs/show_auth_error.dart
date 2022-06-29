import 'package:flutter/material.dart';
import 'package:test_cloud_firebase/auth/auth_error.dart';
import 'package:test_cloud_firebase/dialogs/generic_dialogs.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
      context: context,
      title: authError.dialogTitle,
      content: authError.dialogText,
      optionsBuilder: () => {
            'cancel': false,
            'logout': true,
          });
}
