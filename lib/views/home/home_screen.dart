import 'package:chat_online_flutter/controllers/chat_controller.dart';
import 'package:chat_online_flutter/controllers/contact_controller.dart';
import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:chat_online_flutter/views/chat/chat_screen.dart';
import 'package:chat_online_flutter/views/contactsscreen/contacts_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final LoginController lc = Get.put(LoginController());
  final ContactController con = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.chat),
        onPressed: () {
          Get.to(() => ContactsScreen());
        },
      ),
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
                        //cc.getMessages();
                        lc.friendSelected = value.chats[i].id;
                        Get.to(() => ChatScreen(value.chats[i]));
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              value.chats[i].data()['photo'].isEmpty
                                  ? Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.grey[300]),
                                      child: const Icon(
                                        Icons.person,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                          value.chats[i].data()['photo']),
                                    ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    '${time.hour < 10 ? '0${time.hour}' : '${time.hour}'}:${time.minute < 10 ? '0${time.minute}' : '${time.minute}'}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              )
                            ],
                          ),
                          i == value.chats.length - 1
                              ? Container()
                              : const Divider(height: 30)
                        ],
                      ),
                    );
                  }
                }),
          )),
    );
  }
}
