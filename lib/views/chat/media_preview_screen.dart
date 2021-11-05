import 'dart:io';
import 'package:chat_online_flutter/controllers/upload_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MediaPreviewScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var medias;
  // ignore: prefer_typing_uninitialized_variables
  var user;

  MediaPreviewScreen(this.medias, this.user, {Key? key}) : super(key: key);

  @override
  _MediaPreviewScreenState createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  final controller = PageController();
  final description = TextEditingController();
  late VideoPlayerController _controller;
  UploadController uc = Get.put(UploadController());
  String extension = '';

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.medias[0].path))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pré-visualização'),
      ),
      body: Obx(
        () => uc.statusUpload.value == 'uploading'
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : PageView.builder(
                itemCount: widget.medias.length,
                scrollDirection: Axis.horizontal,
                controller: controller,
                onPageChanged: (i) {},
                itemBuilder: (c, i) {
                  extension =
                      widget.medias[i].path.contains('.mp4') ? 'mp4' : 'jpg';
                  return SizedBox(
                    width: width,
                    child: extension == 'mp4'
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                            child: VideoPlayer(_controller))
                        : Image.file(
                            File(widget.medias[i].path),
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                  );
                },
              ),
      ),
      bottomSheet: Container(
        color: Colors.yellow.withAlpha(40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
                child: const Text(
                  'Enviar',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  uc.uploadFile(widget.medias, extension, widget.user).then((value) {
                    if (uc.statusUpload.value == 'success') {
                      Get.back();
                    }
                  });
                }),
          ],
        ),
      ),
    );
  }
}
