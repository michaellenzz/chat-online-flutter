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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.media['urlFile'])
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
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
                ? Image.network(widget.media['urlFile'])
                : InkWell(
                    child: VideoPlayer(_controller),
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  )),
      ),
    );
  }
}
