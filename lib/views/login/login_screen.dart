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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LoginController lc = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(10),
      child: Obx(
        () => lc.state.value == 'LOADING'
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      'Bem vindo ao Flutter Chat',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7cc6fe)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text('Para começar, digite seu número de telefone',
                        style: TextStyle(
                            fontSize: 16,
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
                      //inputBorder: const OutlineInputBorder(),
                      onInputChanged: (PhoneNumber value) {
                        number = value;
                      },
                      validator: (text) {
                        if (text!.isEmpty || text.length < 13) {
                          return 'Número inválido';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).primaryColor),
                      child: TextButton(
                        child: const Text(
                          'Avançar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        onPressed: () {
                          _showMyDialog(context, number.phoneNumber);
                        },
                      ),
                    ),
                    Obx(() => lc.state.value == 'ERRORSMS'
                        ? const Text(
                            'Erro ao ao enviar o SMS, tente novamente!',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )
                        : Container()),
                  ],
                ),
              ),
      ),
    ));
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
                  if (_formKey.currentState!.validate()) {
                    Get.back();

                    lc.verifyPhone(phone);
                    Get.off(() => SMSCodeScreen());
                  }
                },
                child: const Text('Ok'))
          ],
        );
      },
    );
  }
}
