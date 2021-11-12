import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationController extends GetxController {

  LoginController lc = Get.put(LoginController());
  sendNotification(playerId, friend, photoFriend, message, {photo}) async {
    await OneSignal.shared.postNotification(OSCreateNotification(
      playerIds: [playerId],
      heading: friend,
      content: message ?? 'Imagem',
      bigPicture: photo,
      androidLargeIcon: photoFriend,
      additionalData: {'type': 'message', 'sender': lc.friendSelected},
    ));
  }
}
