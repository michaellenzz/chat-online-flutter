import 'package:bubble/bubble.dart';
import 'package:chat_online_flutter/controllers/chat_controller.dart';
import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:chat_online_flutter/controllers/upload_controller.dart';
import 'package:chat_online_flutter/views/chat/botton_send.dart';
import 'package:chat_online_flutter/views/chat/field_message.dart';
import 'package:chat_online_flutter/views/chat/media_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final user;
  // ignore: use_key_in_widget_constructors
  ChatScreen(this.user) {
    cc.getStatusFriend();
  }

  final mensagem = TextEditingController();

  final ChatController cc = Get.put(ChatController());
  final LoginController lc = Get.put(LoginController());
  final UploadController uc = Get.put(UploadController());

  List<String> messagesUnread = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Container(
              alignment: Alignment.centerRight,
              child: const Icon(Icons.arrow_back_ios)),
          onTap: () {
            Get.back();
          },
        ),
        leadingWidth: 30,
        titleSpacing: 0,
        title: Row(
          children: [
            InkWell(
              child: user.data()['photo'].isEmpty
                  ? Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey[300]),
                      child: const Icon(
                        Icons.person,
                        size: 35,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(user.data()['photo']),
                    ),
              onTap: () {
                Get.back();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.data()['name'],
                    style: const TextStyle(fontSize: 20),
                  ),
                  //mostrar presença do amigo
                  /*
                  GetBuilder<ChatController>(
                    init: ChatController(),
                    builder: (value) => value.statusFriend.isEmpty
                        ? Container()
                        : Text(
                            value.statusFriend,
                            style: const TextStyle(fontSize: 13),
                          ),
                  )
                  */
                ],
              ),
            )
          ],
        ),
      ),
      body: Container(
          color: Colors.yellow.withAlpha(40),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 57),
          //pa: const EdgeInsets.only(bottom: 56),
          child: GetBuilder<ChatController>(
            init: ChatController(),
            builder: (value) => ListView.builder(
                reverse: true,
                itemCount: value.messages.length,
                itemBuilder: (c, i) {
                  if (value.messages.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    //verificar mensagens do amigo especifico
                    if (value.messages[i].data()['chatId'].contains(user.id)) {
                      var time = value.messages[i].data()['time'].toDate();
                      var sender = value.messages[i].data()['sender'];

                      //pegar as mensagens não lidas
                      if (sender != lc.userLogged.value &&
                          value.messages[i].data()['status'] == 'unread' &&
                          value.messages[i]
                              .data()['chatId']
                              .contains(user.id)) {
                        cc.updateStatusMessage(value.messages[i].id);
                      }

                      return Bubble(
                        margin: const BubbleEdges.only(top: 5, bottom: 5),
                        //padding: const BubbleEdges.symmetric(vertical: 12),
                        alignment: sender == lc.userLogged.value
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        nip: sender == lc.userLogged.value
                            ? BubbleNip.rightBottom
                            : BubbleNip.leftTop,
                        color: sender == lc.userLogged.value
                            ? const Color.fromRGBO(255, 255, 255, 100)
                            : const Color(0xFFfff291),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: value.messages[i].data()['type'] ==
                                          'message'
                                      ? Text(
                                          value.messages[i].data()['message'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        )
                                      : value.messages[i].data()['type'] ==
                                              'jpg'
                                          ? InkWell(
                                              child: Image.network(value
                                                  .messages[i]
                                                  .data()['urlFile']),
                                              onTap: () {
                                                Get.to(() => MediaViewScreen(
                                                    value.messages[i].data()));
                                              },
                                            )
                                          : InkWell(
                                            child: InkWell(
                                              child: Container(
                                                  color: Colors.orange[50],
                                                  width: width * 0.6,
                                                  height: width * 0.6,
                                                  child: const Icon(
                                                    Icons.play_circle_outline,
                                                    size: 60,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                                onTap: (){
                                                  Get.to(() => MediaViewScreen(
                                                    value.messages[i].data()));
                                                },
                                            ),
                                          )),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${time.hour < 10 ? '0${time.hour}' : '${time.hour}'}:${time.minute < 10 ? '0${time.minute}' : '${time.minute}'}',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[800]),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  sender == lc.userLogged.value
                                      ? Image.asset(
                                          'assets/images/double-tick.png',
                                          width: 18,
                                          color: value.messages[i]
                                                      .data()['status'] ==
                                                  'read'
                                              ? Colors.blue
                                              : Colors.grey)
                                      : Container()
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }
                }),
          )),
      bottomSheet: Container(
        color: Colors.yellow.withAlpha(40),
        child: Row(
          children: [FieldMessage(mensagem, user), BottonSend(mensagem, user)],
        ),
      ),
    );
  }
}
