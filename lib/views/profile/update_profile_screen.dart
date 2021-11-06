// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:chat_online_flutter/controllers/chat_controller.dart';
import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:chat_online_flutter/controllers/upload_controller.dart';
import 'package:chat_online_flutter/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';

class UpdateProfileScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  UpdateProfileScreen() {
    recado.text = 'Olá, eu estou usando Flutter Chat.';
  }

  LoginController lc = Get.put(LoginController());
  ChatController cc = Get.put(ChatController());
  UploadController uc = Get.put(UploadController());
  List<Media>? image = [];

  final name = TextEditingController();
  final recado = TextEditingController();
  RxBool makeUpload = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      height: 50,
                    ),
                    const Text('Configure seu perfil',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey)),
                    const SizedBox(
                      height: 30,
                    ),
                    Stack(
                      children: [
                        makeUpload.value
                            ? CircleAvatar(
                                radius: 100,
                                backgroundImage:
                                    FileImage(File(image![0].path)),
                              )
                            : Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                    color: Colors.grey[300]),
                                child: Obx(() =>
                                    uc.statusUpload.value == 'uploading'
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : const Icon(
                                            Icons.person,
                                            size: 90,
                                            color: Colors.white,
                                          ))),
                        Positioned(
                            bottom: 5,
                            right: 5,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt,
                                  size: 32, color: Colors.blueGrey),
                              onPressed: () async {
                                image = await ImagesPicker.pick(
                                    pickType: PickType.image,
                                    language: Language.System,
                                    count: 1,
                                    quality: 0.6,
                                    cropOpt: CropOption(
                                        cropType: CropType.rect,
                                        aspectRatio: CropAspectRatio.custom));

                                if (image != null) {
                                  uc
                                      .uploadPhotoProfile(image![0])
                                      .then((value) {
                                    if (uc.statusUpload.value == 'success') {
                                      makeUpload.value = true;
                                    }
                                  });
                                }
                              },
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
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () {
                          if(name.text.isNotEmpty){
                            lc
                              .saveDataFirestore(
                            name.text,
                            lc.photoUserLogged,
                            recado.text
                          )
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
