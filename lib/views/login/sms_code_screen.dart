// ignore_for_file: must_be_immutable

import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:chat_online_flutter/views/profile/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SMSCodeScreen extends StatelessWidget {
  SMSCodeScreen({Key? key}) : super(key: key);

  LoginController lc = Get.put(LoginController());

  final codeSMS = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                      height: 60,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text('Agora digite o código que recebeu por SMS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey)),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.30),
                      child: SizedBox(
                        height: 60,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 18,
                              letterSpacing: 5,
                              fontWeight: FontWeight.w600),
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          controller: codeSMS,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 15, right: 10, top: 10, bottom: 10),
                              border: OutlineInputBorder()),
                        ),
                      ),
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
                          'Avançar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () {
                          lc.signInWithPhoneNumber(codeSMS.text).then((value) {
                            if (lc.state.value == 'SUCCESS') {
                              Get.off(() => UpdateProfileScreen());
                            }
                          });
                        },
                      ),
                    ),
                    Obx(() => lc.state.value == 'ERROR'
                        ? const Text(
                            'Erro ao logar, tente novamente mais tarde!',
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
