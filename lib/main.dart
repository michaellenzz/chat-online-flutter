import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:chat_online_flutter/views/home/home_screen.dart';
import 'package:chat_online_flutter/views/login/login_screen.dart';
import 'package:chat_online_flutter/views/profile/profile_screen.dart';
import 'package:chat_online_flutter/views/profile/update_profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final LoginController lc = Get.put(LoginController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    OneSignal.shared.setAppId('4b42a942-e307-420a-8c9a-9323d8082ad6');
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      //print("Accepted permission: $accepted");
    });
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Chat',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: lc.estaLogado.value ? HomeScreen() : LoginScreen());
  }
}
