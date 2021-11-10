import 'package:chat_online_flutter/views/chat/media_preview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MenuMedia {
  // ignore: prefer_typing_uninitialized_variables
  var user;
  MenuMedia(this.user);
  final ImagePicker _picker = ImagePicker();

  showMenuMidia(context) {
    final RenderBox button = context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          const Offset(50, -65),
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + const Offset(0, 300),
        ),
      ),
      Offset.zero & const Size(50, -65),
    );

    showMenu(
      context: context,
      position: position,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      items: <PopupMenuEntry>[
        PopupMenuItem<String>(
          padding: const EdgeInsets.only(right: 0),
          enabled: true,
          value: '',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () async {
                    Get.back();
                    List<XFile>? photos = await _picker.pickMultiImage(
                        imageQuality: 70, maxHeight: 1500, maxWidth: 1500);

                    if (photos != null) {
                      Get.to(() => MediaPreviewScreen(photos, user));
                    }
                  },
                  icon: const Icon(
                    Icons.photo_rounded,
                    size: 30,
                    color: Color(0xFF7CC6FE),
                  )),
              IconButton(
                  onPressed: () async {
                    Get.back();
                    final XFile? video = await _picker.pickVideo(
                        source: ImageSource.gallery,
                        preferredCameraDevice: CameraDevice.front,
                        maxDuration: const Duration(minutes: 4));

                    List<XFile?> temp = [];
                    temp.add(video);
                    if (video != null) {
                      Get.to(() => MediaPreviewScreen(temp, user));
                    }
                  },
                  icon: const Icon(
                    Icons.video_camera_back_rounded,
                    size: 33,
                    color: Color(0xFF7CC6FE),
                  )),
              IconButton(
                  onPressed: () async {
                    Get.back();
                    final XFile? photo = await _picker.pickImage(
                        source: ImageSource.camera,
                        preferredCameraDevice: CameraDevice.front,
                        imageQuality: 70,
                        maxHeight: 1500,
                        maxWidth: 1500);

                    List<XFile?> temp = [];
                    temp.add(photo);
                    if (photo != null) {
                      Get.to(() => MediaPreviewScreen(temp, user));
                    }
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Color(0xFF7CC6FE),
                  )),
              IconButton(
                  onPressed: () async {
                    Get.back();
                    final XFile? photo = await _picker.pickVideo(
                        source: ImageSource.camera,
                        maxDuration: const Duration(seconds: 30),
                        preferredCameraDevice: CameraDevice.front);

                    List<XFile?> temp = [];
                    temp.add(photo);
                    if (photo != null) {
                      Get.to(() => MediaPreviewScreen(temp, user));
                    }
                  },
                  icon: const Icon(
                    Icons.videocam_rounded,
                    size: 35,
                    color: Color(0xFF7CC6FE),
                  )),
            ],
          ),
        )
      ],
    );
  }
}
