import 'package:chat_online_flutter/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class BottonSend extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var mensagem;
  // ignore: prefer_typing_uninitialized_variables
  var user;
  BottonSend(this.mensagem, this.user, {Key? key}) : super(key: key);
  final ChatController cc = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30)),
      child: IconButton(
          splashRadius: 23,
          onPressed: () {
            if (mensagem.text.isNotEmpty) {
              cc.sendMessages(user.data(), message: mensagem.text);
              mensagem.clear();
            }
          },
          icon: const Icon(
            Icons.send,
            color: Colors.white,
          )),
    );
  }
}
