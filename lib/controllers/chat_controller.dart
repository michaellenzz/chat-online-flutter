import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> messages = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> chats = [];

  String userLogged = 'morgana';
  String nameUserLogged = 'Morgana';
  String photoUserLogged =
      'https://i.pinimg.com/originals/56/2e/fc/562efc6231a0b03e13ea715ae1ad9f1c.png';
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
        .where('chatId', isEqualTo: 'michael')
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

  sendMessages(message, friend) async {
    await FirebaseFirestore.instance.collection('messages').doc().set({
      'status': 'unread',
      'sender': userLogged,
      'message': message,
      'time': Timestamp.now(),
      'chatId': [userLogged, userSelected]
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userLogged)
        .collection('chats')
        .doc(userSelected)
        .set({
      'lastMessage': message,
      'lastTime': Timestamp.now(),
      'name': friend['name'],
      'photo': friend['photo']
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userSelected)
        .collection('chats')
        .doc(userLogged)
        .set({
      'lastMessage': message,
      'lastTime': Timestamp.now(),
      'name': nameUserLogged,
      'photo': photoUserLogged
    }, SetOptions(merge: true));
  }
}
