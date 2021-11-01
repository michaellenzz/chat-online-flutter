import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> messages = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> chats = [];


  LoginController lc = Get.put(LoginController());

  @override
  void onInit() {
    //lc.verificarLogado();

    if (lc.userLogged.value.isNotEmpty) {
      getMessages();
      getChats();
      getStatusFriend();
    }

    super.onInit();
  }

  getMessages() async {
    await FirebaseFirestore.instance
        .collection('messages')
        .where('chatId', arrayContains: lc.userLogged.value)
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
        .doc(lc.userLogged.value)
        .collection('chats')
        .orderBy('lastTime', descending: true)
        .snapshots()
        .forEach((element) {
      chats = element.docs;
      update();
    });
  }

  getStatusFriend() async {
    if (lc.friendSelected.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(lc.friendSelected)
          .snapshots()
          .forEach((value) {
        lc.statusFriend = value.data()!['status'];
        lc.photoFriend = value.data()!['photo'];
        update();
      });
    }
  }

  updateStatusMessage(String messageId) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .update({'status': 'read'});
  }

//TODO
  verifyPresense(bool online) {
    var time = Timestamp.now().toDate();
    var hour =
        '${time.hour < 10 ? '0${time.hour}' : '${time.hour}'}:${time.minute < 10 ? '0${time.minute}' : '${time.minute}'}';
    FirebaseFirestore.instance
        .collection('users')
        .doc(lc.userLogged.value)
        .update({'status': online ? 'online' : 'Visto por último às $hour'});
  }

  sendMessages(message, friend) async {
    await FirebaseFirestore.instance.collection('messages').doc().set({
      'status': 'unread',
      'sender': lc.userLogged.value,
      'message': message,
      'time': Timestamp.now(),
      'chatId': [lc.userLogged.value, lc.friendSelected]
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(lc.userLogged.value)
        .collection('chats')
        .doc(lc.friendSelected)
        .set({
      'lastMessage': message,
      'lastTime': Timestamp.now(),
      'name': friend['name'],
      'photo': friend['photo']
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(lc.friendSelected)
        .collection('chats')
        .doc(lc.userLogged.value)
        .set({
      'lastMessage': message,
      'lastTime': Timestamp.now(),
      'name': lc.nameUserLogged,
      'photo': lc.photoUserLogged
    }, SetOptions(merge: true));
  }
}
