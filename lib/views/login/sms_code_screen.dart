// ignore_for_file: must_be_immutable

import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SMSCodeScreen extends StatelessWidget {
  SMSCodeScreen({Key? key}) : super(key: key);

  LoginController lc = Get.put(LoginController());

  final codeSMS = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirme seu código'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Bem vindo ao Flutter Chat',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepOrange),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text('Agora digite o código que recebeu por SmS',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey)),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: codeSMS,
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.deepOrange),
              child: TextButton(
                child: const Text(
                  'Avançar',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                onPressed: () {
                  lc.signInWithPhoneNumber(codeSMS.text);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
