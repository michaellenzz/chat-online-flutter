import 'dart:io';
import 'package:chat_online_flutter/controllers/chat_controller.dart';
import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadController extends GetxController {
  RxString statusUpload = 'init'.obs;
  ChatController cc = Get.put(ChatController());
  LoginController lc = Get.put(LoginController());

  Future<void> uploadFile(files, String extension, user) async {
    for (var element in files) {
      statusUpload.value = 'uploading';

      ///Start uploading
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      String path = 'medias/$fileName.$extension';
      firebase_storage.Reference reference =
          firebase_storage.FirebaseStorage.instance.ref(path);

      ///Show the status of the upload
      firebase_storage.TaskSnapshot uploadTask =
          await reference.putFile(File(element.path));

      ///Get the download url of the file
      String url = await uploadTask.ref.getDownloadURL();

      if (uploadTask.state == firebase_storage.TaskState.success) {
        statusUpload.value = 'success';
        await cc.sendMessages(user.data(),
            urlFile: url, reference: path, extension: extension);
      } else {
        statusUpload.value = 'fail';
      }
    }
  }

  Future<void> uploadPhotoProfile(image) async {
    statusUpload.value = 'uploading';

    ///Start uploading
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String path = 'profile/$fileName.jpg';
    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref(path);

    ///Show the status of the upload
    firebase_storage.TaskSnapshot uploadTask =
        await reference.putFile(File(image.path));

    ///Get the download url of the file
    lc.photoUserLogged = await uploadTask.ref.getDownloadURL();
    update();

    if (uploadTask.state == firebase_storage.TaskState.success) {
      statusUpload.value = 'success';
    } else {
      statusUpload.value = 'fail';
    }
  }
}
