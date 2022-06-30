// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_cloud_firebase/bloc/app_bloc.dart';
import 'package:test_cloud_firebase/bloc/app_event.dart';
import 'package:test_cloud_firebase/bloc/app_state.dart';
import 'package:test_cloud_firebase/views/main_popmenu_button.dart';
import 'package:test_cloud_firebase/views/storage_image_view.dart';

// this widgets puts whole things together

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // the image picker is hooked to key as long as key is same we are gonna use the same instance of image picker
    final picker = useMemoized(() => ImagePicker(), [key]);
//we are going to grab images from the state if state is changed or images by watching the bloc //aka change notifier
    final images = context.watch<AppBloc>().state.images ?? [];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final image =
                    // picking image from the gallery
                    await picker.pickImage(source: ImageSource.gallery);
                if (image == null) {
                  return;
                } else {
                  // uploading a image file
                  context.read<AppBloc>().add(
                        AppEventUploadImage(filePathUpload: image.path),
                      );
                }
              },
              icon: const Icon(Icons.upload)),
          const MainPopUpMenuButton(),
        ],
        title: const Text('Photo Gallery'),
      ),
      body: GridView.count(
          padding: const EdgeInsets.all(8),
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          // this means we have two contents horizontally to each other
          crossAxisCount: 2,
          // taking images from source and mappting it then showing it as list
          children: images.map((img) => StorageImageView(image: img)).toList()),
    );
  }
}
