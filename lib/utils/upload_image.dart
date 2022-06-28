import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

// util that helps us upload images to firebase it requires the file path and user id to add it to specific users storage
Future<bool> uploadImage({required File file, required String userId}) =>

// creating a instance of firebase storage
    FirebaseStorage.instance
        // which takes user id as refrence to get the folder which refers to the userid
        .ref(userId)
        // creating a child aka file which this file is gonna get uploaded
        .child(
            // we are gonna name our file as a unique uuid
            const Uuid().v4())
        .putFile(file)
        //if upload successful  then return value true
        .then((_) => true)
        // if theres a error false
        .catchError((_) => false);
