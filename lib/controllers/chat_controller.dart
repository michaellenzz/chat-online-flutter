import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> messages = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> chats = [];

  String userLogged = 'morgana';
  String nameUserLogged = 'Morgana';
  String myPhoneNumber = '+5561998752594';
  String photoUserLogged =
      'https://i.pinimg.com/originals/56/2e/fc/562efc6231a0b03e13ea715ae1ad9f1c.png';
  //'https://st2.depositphotos.com/3433891/6661/i/600/depositphotos_66613339-stock-photo-man-with-crossed-arms.jpg';

  //dados do amigo
  String friendSelected = '';
  String photoFriend = '';
  String statusFriend = '';

  @override
  void onInit() {
    getMessages();
    getChats();
    super.onInit();
  }

  getMessages() async {
    await FirebaseFirestore.instance
        .collection('messages')
        .where('chatId', arrayContains: userLogged)
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
        .orderBy('lastTime', descending: true)
        .snapshots()
        .forEach((element) {
      chats = element.docs;
      update();
    });
  }

  getStatusFriend() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendSelected)
        .get()
        .then((value) {
      statusFriend = value.data()!['status'];
      photoFriend = value.data()!['photo'];
      update();
    });
  }

  sendMessages(message, friend) async {
    await FirebaseFirestore.instance.collection('messages').doc().set({
      'status': 'unread',
      'sender': userLogged,
      'message': message,
      'time': Timestamp.now(),
      'chatId': [userLogged, friendSelected]
    });

    updateStatusMessage(){
      //TODO
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userLogged)
        .collection('chats')
        .doc(friendSelected)
        .set({
      'lastMessage': message,
      'lastTime': Timestamp.now(),
      'name': friend['name'],
      'photo': friend['photo']
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendSelected)
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
