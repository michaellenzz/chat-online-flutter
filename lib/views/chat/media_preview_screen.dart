import 'dart:io';
import 'package:chat_online_flutter/controllers/upload_controller.dart';
import 'package:chewie/chewie.dart';
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
  // ignore: prefer_typing_uninitialized_variables
  late final chewieController;
  UploadController uc = Get.put(UploadController());
  String extension = '';

  @override
  void initState() {
    super.initState();
    final videoPlayerController =
        VideoPlayerController.network(widget.medias[0].path);

    videoPlayerController.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
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
                        ? Chewie(
                            controller: chewieController,
                          )
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
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
                child: const Text(
                  'Enviar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  uc
                      .uploadFile(widget.medias, extension, widget.user)
                      .then((value) {
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

  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();

    super.dispose();
  }
}
