import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationController extends GetxController {
  sendNotification(playerId, friend, photoFriend, message, {photo}) async {
    await OneSignal.shared.postNotification(OSCreateNotification(
      playerIds: [playerId],
      heading: friend,
      content: message ?? 'Imagem',
      bigPicture: photo,
      androidLargeIcon: photoFriend,
    ));
  }
}
