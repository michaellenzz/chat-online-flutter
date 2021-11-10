import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaViewScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final media;
  const MediaViewScreen(this.media, {Key? key}) : super(key: key);

  @override
  State<MediaViewScreen> createState() => _MediaViewScreenState();
}

class _MediaViewScreenState extends State<MediaViewScreen> {
  late VideoPlayerController _controller;
  // ignore: prefer_typing_uninitialized_variables
  late final chewieController;

  @override
  void initState() {
    super.initState();
    final videoPlayerController =
        VideoPlayerController.network(widget.media['urlFile']);

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
        title: const Text('Visualizar mídia'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
            width: width,
            child: widget.media['type'] == 'jpg'
                ? ExtendedImage.network(
                    widget.media['urlFile'],
                    fit: BoxFit.fill,
                    cache: true,
                    handleLoadingProgress: true,
                  )
                : Chewie(
                    controller: chewieController,
                  )),
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
