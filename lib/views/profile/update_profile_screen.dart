import 'package:chat_online_flutter/controllers/chat_controller.dart';
import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:chat_online_flutter/controllers/upload_controller.dart';
import 'package:chat_online_flutter/views/home/home_screen.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class UpdateProfileScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  _UpdateProfileScreenState() {
    recado.text = 'Olá, eu estou usando Flutter Chat.';
    name.text = lc.nameUserLogged!;
  }
  LoginController lc = Get.put(LoginController());

  ChatController cc = Get.put(ChatController());

  UploadController uc = Get.put(UploadController());

  XFile? image;

  final ImagePicker _picker = ImagePicker();

  final name = TextEditingController();

  final recado = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configure seu perfil'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Obx(
            () => lc.state.value == 'LOADING'
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Stack(
                          children: [
                            lc.photoUserLogged.isNotEmpty
                                ? Obx(() => uc.statusUpload.value == 'uploading'
                                    ? Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(200),
                                            color: Colors.grey[300]),
                                        child: const Center(
                                            child: CircularProgressIndicator()),
                                      )
                                    : CircleAvatar(
                                        radius: 100,
                                        backgroundImage:
                                            ExtendedNetworkImageProvider(
                                                lc.photoUserLogged,
                                                cache: true),
                                      ))
                                : Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        color: Colors.grey[300]),
                                    child: Obx(() => uc.statusUpload.value ==
                                            'uploading'
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : const Icon(
                                            Icons.person,
                                            size: 90,
                                            color: Colors.white,
                                          ))),
                            Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Theme.of(context).primaryColor),
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt,
                                        size: 25, color: Colors.white),
                                    onPressed: () async {
                                      image = await _picker.pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 70,
                                          maxHeight: 1500,
                                          maxWidth: 1500);

                                      if (image != null) {
                                        var img = await ImageCropper.cropImage(
                                          sourcePath: image!.path,
                                          aspectRatioPresets: [
                                            CropAspectRatioPreset.square,
                                          ],
                                          maxWidth: 1000,
                                          maxHeight: 1000,
                                        );
                                        uc
                                            .uploadPhotoProfile(img)
                                            .then((value) {
                                          if (uc.statusUpload.value ==
                                              'success') {
                                                setState(() {
                                                  
                                                });
                                              }
                                        });
                                      }
                                    },
                                  ),
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                          controller: name,
                          decoration: const InputDecoration(
                              labelText: 'Seu nome',
                              contentPadding: EdgeInsets.only(
                                  left: 15, right: 10, top: 10, bottom: 10),
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                          controller: recado,
                          decoration: const InputDecoration(
                              labelText: 'Recado',
                              contentPadding: EdgeInsets.only(
                                  left: 15, right: 10, top: 10, bottom: 10),
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(context).primaryColor),
                          child: TextButton(
                            child: const Text(
                              'Salvar',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            onPressed: () {
                              if (name.text.isNotEmpty) {
                                lc
                                    .saveDataFirestore(name.text,
                                        lc.photoUserLogged, recado.text)
                                    .then((value) {
                                  if (lc.state.value == 'SUCCESS') {
                                    Get.off(() => HomeScreen());
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        Obx(() => lc.state.value == 'ERROR'
                            ? const Text(
                                'Erro ao atualizar seu perfil!',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )
                            : Container()),
                      ],
                    ),
                  ),
          ),
        ));
  }
}
