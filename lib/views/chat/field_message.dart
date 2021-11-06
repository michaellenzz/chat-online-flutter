import 'package:chat_online_flutter/controllers/upload_controller.dart';
import 'package:chat_online_flutter/views/chat/menu_media.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class FieldMessage extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var message;
  // ignore: prefer_typing_uninitialized_variables
  var user;
  FieldMessage(this.message, this.user, {Key? key}) : super(key: key);

  final UploadController uc = Get.put(UploadController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          width: 200,
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).primaryColor),
          child: SizedBox(
            width: 200,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: TextField(
                maxLines: null,
                controller: message,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: 19, color: Colors.black),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: 15, right: 33, top: 10, bottom: 10),
                    border: InputBorder.none,
                    hintText: 'Digite aqui...',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ),
        ),
        Positioned(
            right: 3,
            child: IconButton(
              icon: const Icon(Icons.camera_alt),
              color: Colors.white,
              splashRadius: 25,
              onPressed: () {
                MenuMedia(user).showMenuMidia(context);
              },
            )),
      ],
    ));
  }
}
