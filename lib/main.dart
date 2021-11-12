import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:chat_online_flutter/views/home/home_screen.dart';
import 'package:chat_online_flutter/views/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final LoginController lc = Get.put(LoginController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    OneSignal.shared.setAppId('4b42a942-e307-420a-8c9a-9323d8082ad6');
    OneSignal.shared.promptUserForPushNotificationPermission();

    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {

      var notify = event.notification.additionalData;
      
      if (notify!["sender"] == lc.friendSelected) {
        event.complete(null);
      }
    });

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chat',
        theme: ThemeData(
            primarySwatch: MaterialColor(0xFFb3dec1, color),
            primaryColor: MaterialColor(0xFFb3dec1, color)),
        home: lc.estaLogado.value ? HomeScreen() : LoginScreen());
  }

  Map<int, Color> color = {
    50: const Color.fromRGBO(136, 14, 79, .1),
    100: const Color.fromRGBO(136, 14, 79, .2),
    200: const Color.fromRGBO(136, 14, 79, .3),
    300: const Color.fromRGBO(136, 14, 79, .4),
    400: const Color.fromRGBO(136, 14, 79, .5),
    500: const Color.fromRGBO(136, 14, 79, .6),
    600: const Color.fromRGBO(136, 14, 79, .7),
    700: const Color.fromRGBO(136, 14, 79, .8),
    800: const Color.fromRGBO(136, 14, 79, .9),
    900: const Color.fromRGBO(136, 14, 79, 1),
  };
}
