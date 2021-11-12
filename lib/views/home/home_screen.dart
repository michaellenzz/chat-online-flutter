import 'package:chat_online_flutter/controllers/chat_controller.dart';
import 'package:chat_online_flutter/controllers/contact_controller.dart';
import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:chat_online_flutter/views/chat/chat_screen.dart';
import 'package:chat_online_flutter/views/contactsscreen/contacts_screen.dart';
import 'package:chat_online_flutter/views/home/about_app.dart';
import 'package:chat_online_flutter/views/home/photo_view_screen.dart';
import 'package:chat_online_flutter/views/login/login_screen.dart';
import 'package:chat_online_flutter/views/profile/update_profile_screen.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  HomeScreen() {
    lc.friendSelected = '';
  }

  final LoginController lc = Get.put(LoginController());
  final ContactController con = Get.put(ContactController());
  final ChatController cc = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffb3dec1),
        child: const Icon(Icons.chat),
        onPressed: () {
          getPermissionDevice().then((permission) {
            if (permission == true) {
              con.count = 0;
              con.contacts.clear();
              con.getContactDevice();
              Get.to(() => const ContactsScreen());
            }
          });
        },
      ),
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        centerTitle: true,
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.black),
              textTheme: const TextTheme().apply(bodyColor: Colors.white),
            ),
            child: PopupMenuButton<int>(
              color: Theme.of(context).primaryColor,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Configurações',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Sobre o app',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                /*
                const PopupMenuDivider(),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Sair',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),*/
              ],
            ),
          ),
        ],
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
                        lc.friendSelected = value.chats[i].id;
                        cc.getStatusFriend();
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
                                  : InkWell(
                                      onTap: () {
                                        Get.to(() => PhotoView(
                                            value.chats[i].data()['photo'],
                                            value.chats[i].data()['name']));
                                      },
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage:
                                            ExtendedNetworkImageProvider(
                                                value.chats[i].data()['photo'],
                                                cache: true),
                                      ),
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
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  value.chats[i].data()['read'] ??
                                          true //caso o doc não tenha o campo 'read'
                                      ? const SizedBox(
                                          height: 25,
                                        )
                                      : const Icon(
                                          Icons.info,
                                          color: Colors.green,
                                        )
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

  Future<bool> getPermissionDevice() async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      return true;
    }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.contacts,
    ].request();
    if (statuses[Permission.contacts] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  void onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        Get.to(() => UpdateProfileScreen());
        break;
      case 1:
        Get.to(() => const AboutApp());
        break;
      case 2:
        await FirebaseAuth.instance.signOut();
        Get.off(() => LoginScreen());
        break;
    }
  }
}
