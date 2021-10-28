import 'package:chat_online_flutter/controllers/chat_controller.dart';
import 'package:chat_online_flutter/controllers/contact_controller.dart';
import 'package:chat_online_flutter/views/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsScreen extends StatelessWidget {
  ContactsScreen({Key? key}) : super(key: key);

  final ChatController cc = Get.put(ChatController());
  final ContactController con = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        titleSpacing: 0,
        title: Container(
          height: 43,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          margin: const EdgeInsets.only(right: 10),
          child: TextField(
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              hintText: 'Pesquisar...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.only(left: 15, top: 9),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (text) {},
            //autofocus: true,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(13),
        child: GetBuilder<ContactController>(
          init: ContactController(),
          builder: (value) => ListView.builder(
            itemCount: value.contacts.length,
            itemBuilder: (c, i) {
              if (value.contacts.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        cc.userSelected = value.contacts[i].id;
                        Get.off(() => ChatScreen(value.contacts[i]));
                      },
                      child: Row(
                        children: [
                          value.contacts[i].data()['photo'].isEmpty
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
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                      value.contacts[i].data()['photo']),
                                ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    value.contacts[i].data()['name'],
                                    style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(value.contacts[i].data()['status'],
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey[800])),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    i == value.contacts.length - 1
                        ? Container()
                        : const Divider(
                            height: 30,
                          )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
