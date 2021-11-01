import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> contacts = [];
  List<String> phones = [];
  int count = 0;
  List<String> temPhones = []; //array com a combinação de 10 telefones

  @override
  void onInit() {
    getContactDevice();
    super.onInit();
  }

  getContactDevice() async {
    List<Contact> contacts = await ContactsService.getContacts();
    for (var element in contacts) {
      for (var n in element.phones!) {
        phones.add(tratarNumeros(n.value.toString()));
      }
    }
    separate10in10();
  }

  separate10in10() async{
    if (phones.length > 10) {
      for (int i = 0; i < phones.length; i++) {
        temPhones.add(phones[i]);
        if (temPhones.length == 10) {
          await getContactDatabase(temPhones);
          temPhones.clear();
        }
      }
    } else {
      getContactDatabase(phones);
    }
  }

  getContactDatabase(n) async {
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name')
        .where('phone', whereIn: n)
        .snapshots()
        .forEach((element) {
      contacts.addAll(element.docs);
      update();
    });
  }

  String tratarNumeros(number) {
    number = number.replaceAll('-', '');
    number = number.replaceAll(' ', '');
    if (number.startsWith('+55')) return number;
    if (number.startsWith('55')) return '+$number';
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
