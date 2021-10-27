import 'package:bubble/bubble.dart';
import 'package:chat_online_flutter/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  
  ChatScreen({Key? key}) : super(key: key);

  final imageUser =
      'https://vilamulher.com.br/imagens/thumbs/2014/11/10/4-razoes-para-ser-uma-pessoa-mais-curiosa-thumb-570.jpg';

  final mensagem = TextEditingController();

  final ChatController cc = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: Container(
              alignment: Alignment.centerRight,
              child: const Icon(Icons.arrow_back_ios)),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        leadingWidth: 30,
        titleSpacing: 0,
        title: Row(
          children: [
            InkWell(
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(imageUser),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Morgana',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Container(
          color: Colors.yellow.withAlpha(40),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 56),
          child: GetBuilder<ChatController>(
            init: ChatController(),
            builder: (value) => ListView.builder(
                reverse: true,
                itemCount: value.messages.length,
                itemBuilder: (c, i) {
                  if (value.messages.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var time = value.messages[i].data()['time'].toDate();
                    var sender = value.messages[i].data()['sender'];
                    
                    return Bubble(
                      margin: const BubbleEdges.only(top: 10),
                      alignment: sender == cc.userLogged ? Alignment.topRight : Alignment.topLeft,
                      nip: sender == cc.userLogged ? BubbleNip.rightBottom : BubbleNip.leftTop,
                      color: sender == cc.userLogged ?  const Color.fromRGBO(255, 255, 255, 255) : const Color.fromRGBO(225, 255, 199, 1.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            value.messages[i].data()['message'],  
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.fromLTRB(9, 16, 0, 0),
                            child: Text(
                              '${time.hour}:${time.minute}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
          ) /*ListView(
          reverse: true,
          children: [
            Bubble(
              margin: const BubbleEdges.only(top: 10),
              alignment: Alignment.topLeft,
              nip: BubbleNip.leftTop,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Fala menino Ney',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.fromLTRB(9, 16, 0, 0),
                    child: const Text(
                      '08:41',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Bubble(
              margin: const BubbleEdges.only(top: 10),
              alignment: Alignment.topRight,
              nip: BubbleNip.rightBottom,
              color: const Color.fromRGBO(225, 255, 199, 1.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Fala aí meu querido!!!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.fromLTRB(9, 16, 0, 0),
                      child: Image.asset(
                        'assets/images/tick.png',
                        width: 22,
                        color: Colors.grey,
                      )),
                ],
              ),
            ),
          ],
        ),*/
          ),
      bottomSheet: Container(
        color: Colors.yellow.withAlpha(40),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.deepOrangeAccent[100]),
                child: TextField(
                  controller: mensagem,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(fontSize: 19, color: Colors.black),
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15, right: 10),
                      border: InputBorder.none,
                      hintText: 'Digite aqui...',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 5),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: IconButton(
                  splashRadius: 23,
                  onPressed: () {
                    cc.sendMessages(mensagem.text);
                    mensagem.clear();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
