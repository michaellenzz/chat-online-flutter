// ignore_for_file: must_be_immutable

import 'package:chat_online_flutter/controllers/login_controller.dart';
import 'package:chat_online_flutter/views/login/sms_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'BR';
  PhoneNumber number = PhoneNumber(isoCode: 'BR');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  LoginController lc = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Bem vindo ao Flutter Chat',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepOrange),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text('Para começar, digite seu número de telefone',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey)),
            const SizedBox(
              height: 10,
            ),
            InternationalPhoneNumberInput(
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
              ),
              locale: 'BR',
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: const TextStyle(color: Colors.black),
              initialValue: number,
              textFieldController: controller,
              formatInput: true,
              maxLength: 13,
              hintText: 'Seu Número',
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              inputBorder: const OutlineInputBorder(),
              onInputChanged: (PhoneNumber value) {
                number = value;
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.deepOrange),
              child: TextButton(
                child: const Text(
                  'Avançar',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                onPressed: () {
                  _showMyDialog(context, number.phoneNumber);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(context, phone) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seu número esta correto?'),
          content: Text(
            phone,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('editar')),
            TextButton(
                onPressed: () {
                  
                  lc.verifyPhone(phone);
                  Get.to(() => SMSCodeScreen());
                },
                child: const Text('Ok'))
          ],
        );
      },
    );
  }
}
