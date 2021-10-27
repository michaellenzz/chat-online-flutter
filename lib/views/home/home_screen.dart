import 'package:chat_online_flutter/controllers/chat_controller.dart';
import 'package:chat_online_flutter/views/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final ChatController cc = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Flutter'),
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: GetBuilder<ChatController>(
            init: ChatController(),
            builder: (value) => ListView.builder(
                itemCount: value.chats.length,
                itemBuilder: (c, i) {
                  if (value.chats.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var time = value.chats[i].data()['lastTime'].toDate();
                    return InkWell(
                      onTap: () {
                        cc.userSelected = value.chats[i].id;
                        Get.to(() => ChatScreen(value.chats[i]));
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage:
                                NetworkImage(value.chats[i].data()['photo']),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    value.chats[i].data()['name'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(value.chats[i].data()['lastMessage'],
                                  maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Text(
                                '${time.hour}:${time.minute}',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                }),
          )),
    );
  }
}
