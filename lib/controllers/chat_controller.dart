import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> messages = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> chats = [];

  String userLogged = 'morgana';
  String userSelected = '';

  @override
  void onInit() {
    getMessages();
    getChats();
    super.onInit();
  }

  getMessages() async {
    await FirebaseFirestore.instance
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots()
        .forEach((element) {
      messages = element.docs;
      update();
    });
  }

  getChats() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userLogged)
        .collection('chats')
        .snapshots()
        .forEach((element) {
      chats = element.docs;
      update();
    });
  }

  sendMessages(message, idChat) async {
    await FirebaseFirestore.instance.collection('messages').doc().set({
      'status': 'unread',
      'sender': userLogged,
      'message': message,
      'time': Timestamp.now(),
      'chatId': idChat
    });

    await FirebaseFirestore.instance.collection('users')
      .doc(userLogged)
      .collection('chats')
      .doc(userSelected).update({
      'lastMessage': message,
      'lastTime': Timestamp.now()
    });

    await FirebaseFirestore.instance.collection('users')
      .doc(userSelected)
      .collection('chats')
      .doc(userLogged).update({
      'lastMessage': message,
      'lastTime': Timestamp.now()
    });

  }
}
