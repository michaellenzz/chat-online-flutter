import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';



class LoginController extends GetxController {

final _auth = FirebaseAuth.instance;

String verificId = '';

  verifyPhone(phoneNumber) async {

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 30),
        codeSent: (String verificationId, int? forceResendingToken) {
          
          verificId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificId = verificationId;
        },
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          //print(phoneAuthCredential);
        },
        verificationFailed: (FirebaseAuthException error) {
          // ignore: avoid_print
          print(error);
        });
  }

  void signInWithPhoneNumber(codeSMS) async {
  try {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificId,
      smsCode: codeSMS,
    );

    final User? user = (await _auth.signInWithCredential(credential)).user;

    print("Successfully signed in UID: ${user!.uid}");
  } catch (e) {
    print("Failed to sign in: " + e.toString());
  }
}
}
