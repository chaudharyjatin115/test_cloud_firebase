import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:test_cloud_firebase/auth/auth_error.dart';
import 'package:test_cloud_firebase/dialogs/show_auth_error.dart';

// to render firebase images
class StorageImageView extends StatelessWidget {
  const StorageImageView({Key? key, required this.image}) : super(key: key);
// the widget needs refrence to images to work
  final Reference image;
  @override
  Widget build(BuildContext context) {
    // it would need to return a future builder
    // image is a type of uint8 data so we made it this type
    return FutureBuilder<Uint8List?>(
      future: image.getData(),
      builder: (context, snapshot) {
        // the snapshot is gonna be type of uint8 list
        switch (snapshot.connectionState) {
          case ConnectionState.none:

          case ConnectionState.waiting:

          case ConnectionState.active:
            // if we get connection state active we need to show a progress indicator
            return const Center(
              child: CircularProgressIndicator(),
            );

          case ConnectionState.done:

            // checking if snapshot has data
            if (snapshot.hasData) {
              //getting data from snapshot

              final data = snapshot.data!;
              return Image.memory(
                data,
                fit: BoxFit.cover,
              );
            } else if (snapshot.hasError) {
              showLoadingError(authError: snapshot.error!, context: context);
            } else {
              return const CircularProgressIndicator();
            }
        }
        throw {};
      },
    );
  }
}
