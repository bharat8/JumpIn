import 'package:JumpIn/core/constants/constants.dart';
import 'package:JumpIn/core/utils/progress.dart';
import 'package:JumpIn/core/utils/sharedpref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';

void handleError(BuildContext ctx) {
  SizeConfig().init(ctx);
  showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
              title: Text(
            "$Error,Try Again!",
            style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 5),
          )));
}

Future postUserAbout(String userAbout, BuildContext context) async {
  try {
    FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPrefs.userid)
        .update({'userProfileAbout': userAbout}).then((value) => showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("Updated"),
                )));
  } catch (e) {
    print("caught error $e");
    handleError(context);
  }
}

postImInJumpinFor(String inJumpinFor, BuildContext context) {
  print("inside user in jumpin for");
  try {
    circularProgressIndicator();
    FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPrefs.userid)
        .update({'inJumpinFor': inJumpinFor}).then((value) => showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("Updated"),
                )));
  } catch (e) {
    handleError(context);
  }
}

Future<void> uploadPhotoToFirestore(downloadUrl) async {
  FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPrefs.userid)
      .update({
    "photoLists": FieldValue.arrayUnion([downloadUrl])
  });
}

Future<void> deleteImageFromFirebaseStorage(String imageFileUrl) async {
  if (imageFileUrl != null) {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
        .replaceAll(new RegExp(r'(\?alt).*'), '');

    final Reference photoRef =
        await FirebaseStorage.instance.ref().child(fileUrl);
    // try {
    //   photoRef.delete();
    // }on StorageException catch (e) {
    //   print("Exception occured");
    // }
    //-----implement storage exception----
    await photoRef
        .delete()
        .whenComplete(() => deleteFromFirebaseFirestore(imageFileUrl));
  }
}

Future deleteFromFirebaseFirestore(imageFileUrl) async {
  FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPrefs.userid)
      .update({
    'photoLists': FieldValue.arrayRemove([imageFileUrl])
  }).whenComplete(() => print("deleted"));
}
