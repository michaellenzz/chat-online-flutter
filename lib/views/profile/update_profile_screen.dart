// ignore_for_file: must_be_immutable

import 'package:chat_online_flutter/controllers/chat_controller.dart';
import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:chat_online_flutter/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({Key? key}) : super(key: key);

  LoginController lc = Get.put(LoginController());
  ChatController cc = Get.put(ChatController());

  final name = TextEditingController();

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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(lc.photoUserLogged),
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
                    Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepOrange),
                      child: TextButton(
                        child: const Text(
                          'Salvar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () {
                          lc
                              .saveDataFirestore(name.text, lc.photoUserLogged)
                              .then((value) {
                            if (lc.state.value == 'SUCCESS') {
                              Get.off(() => HomeScreen());
                            }
                          });
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
