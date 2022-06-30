import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_cloud_firebase/bloc/app_bloc.dart';
import 'package:test_cloud_firebase/bloc/app_event.dart';
import 'package:test_cloud_firebase/dialogs/delete_account_dialog.dart';
import 'package:test_cloud_firebase/dialogs/logging_out_dialog.dart';

enum MenuAction { logout, deleteAccount }

class MainPopUpMenuButton extends StatelessWidget {
  const MainPopUpMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogout = await showLogOutDialog(context);
            if (shouldLogout) {
              context.read<AppBloc>().add(const AppEventLogOut());
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(context);
            if (shouldDeleteAccount!) {
              context.read<AppBloc>().add(const AppEventDeleteAccount());
            }
            break;
        }
      },
      itemBuilder: (context) {
        return [
          // pop menu item builder requires a list as return

          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Log it'),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text('Delete Account'),
          ),
        ];
      },
    );
  }
}
