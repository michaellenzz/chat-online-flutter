import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> contacts = [];
  List<String> phones = [];
  List<String> phonesTemp = [];
  RxString state = 'A LOGAR'.obs;
  int count = 0;

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
        count++;
        phonesTemp.add(element);
        if (phonesTemp.length == 10) {
          getContactDatabase(phonesTemp);
          phonesTemp.clear();
        }
        if(count == phones.length){
          state.value = 'done';
        }
      }
    } else if (phones.isEmpty) {
      //Não há contatos na agenda
    } else {
      getContactDatabase(phones);
      state.value = 'done';
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
      update();
      // ignore: avoid_print
    }).catchError((e) {
      state.value = 'erro';
    });
  }

  String tratarNumeros(String number) {
    number = number.replaceAll('-', '');
    number = number.replaceAll(' ', '');
    number = number.replaceAll(')', '');
    number = number.replaceAll('(', '');

    //completo mas sem o 9
    if (number.startsWith('+55') && number.length == 13) {
      var prefix = number.substring(0, 5);
      var sufix = number.substring(5, 13);
      return '${prefix}9$sufix';
    }

    //ok
    if (number.startsWith('+55') && number.length == 14) return number;

    //061998575936
    if (number.startsWith('0') && number.length == 12) {
      number = number.replaceRange(0, 1, '');
      return '+55$number';
    }

    //06198575936
    if (number.startsWith('0') && number.length == 11) {
      number = number.replaceRange(0, 1, '');
      var prefix = number.substring(0, 2);
      var sufix = number.substring(2, 10);
      return '+55${prefix}9$sufix';
    }

    //61998575936
    if (number.length == 11) {
      return '+55$number';
    }

    //6198575936
    if (number.length == 10) {
      var prefix = number.substring(0, 2);
      var sufix = number.substring(2, 10);
      return '+55${prefix}9$sufix';
    }

    //998575936
    if (number.length == 9) {
      var prefix = lc.userLogged.substring(0, 5);
      return '$prefix$number';
    }

    //98575936
    if (number.length == 8) {
      var prefix = lc.userLogged.substring(0, 5);
      return '${prefix}9$number';
    }

    return '';
  }
}
