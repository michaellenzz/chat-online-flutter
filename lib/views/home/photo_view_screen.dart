import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class PhotoView extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final media;
  // ignore: prefer_typing_uninitialized_variables
  final name;
  const PhotoView(this.media, this.name, {Key? key}) : super(key: key);

  @override
  State<PhotoView> createState() => _PhotoView();
}

class _PhotoView extends State<PhotoView> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
            width: width,
            child: ExtendedImage.network(
              widget.media,
              fit: BoxFit.fill,
              cache: true,
              handleLoadingProgress: true,
            )),
      ),
    );
  }
}
