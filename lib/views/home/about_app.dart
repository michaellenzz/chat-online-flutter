import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre o app'),
        centerTitle: true,
      ),
      body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/logo.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Aplicativo de mensagens instatâneas simples e intuitivo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Desenvolvido por: Michael Lenz',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Contato:  ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'michael-lenz@hotmail.com',
                    style: TextStyle(
                        fontSize: 16, decoration: TextDecoration.underline),
                  ),
                ],
              )
            ],
          )),
    );
  }


}
