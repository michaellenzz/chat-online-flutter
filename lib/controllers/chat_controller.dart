import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> messages = [];
  String userLogged = 'michael';

  @override
  void onInit() {
    getMessages();
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

  sendMessages(message) async {
    await FirebaseFirestore.instance.collection('messages').doc().set(
        {'sender': 'michael', 'message': message, 'time': Timestamp.now()});
  }
}
