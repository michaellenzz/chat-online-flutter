import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> contacts = [];
  List<String> phones = [];
  List<String> phonesTemp = [];
  RxString state = 'A LOGAR'.obs;

  final LoginController lc = Get.put(LoginController());

  getContactDevice() async {
    state.value = 'loading';
    List<Contact> contacts = await ContactsService.getContacts();
    for (var element in contacts) {
      for (var n in element.phones!) {
        if (n.value!.isNotEmpty || n.value != null) {
          phones.add(tratarNumeros(n.value.toString()));
        }
      }
    }
    separate10in10();
  }

  Future separate10in10() async {
    phones.removeWhere((element) => element.isEmpty);
    phones.removeWhere((element) => element == lc.userLogged.value);
    phones = phones.toSet().toList();

    if (phones.length > 10) {
      for (var element in phones) {
        phonesTemp.add(element);
        if (phonesTemp.length == 10) {
          getContactDatabase(phonesTemp);
          phonesTemp.clear();
        }
      }
    } else if (phones.isEmpty) {
      //Não há contatos na agenda
    } else {
      getContactDatabase(phones);
    }
  }

  Future getContactDatabase(n) async {
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .where('phone', whereIn: n)
        .snapshots()
        .forEach((element) {
      contacts.addAll(element.docs);
      state.value = 'success';
      update();
      // ignore: avoid_print
    }).catchError((e) {
      state.value = 'erro';
    });
  }

  String tratarNumeros(number) {
    // +5561998575936
    number = number.replaceAll('-', '');
    number = number.replaceAll(' ', '');

    if (number.startsWith('+55') && number.length == 13) {
      return number.replaceRange(5, 6, '9');
    }

    if (number.startsWith('+55') && number.length == 14) return number;

    if (number.startsWith('0')) {
      number = number.replaceRange(0, 1, '');
      return '+55$number';
    }
    if (number.length == 11) {
      return '+55$number';
    }
    return '';
  }
}
