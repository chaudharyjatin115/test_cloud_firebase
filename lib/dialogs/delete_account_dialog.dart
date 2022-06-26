import 'package:flutter/material.dart';
import 'package:test_cloud_firebase/dialogs/generic_dialogs.dart';

Future<bool> showDeleteAccountDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Delete Account',
      content: 'are you sure you want to delete your account?',
      optionsBuilder: () => {
            'cancel': false,
            'Delete account': true,
          }).then((value) => value ?? false);
}
