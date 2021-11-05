import 'package:chat_online_flutter/views/chat/media_preview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';

class MenuMedia {
  // ignore: prefer_typing_uninitialized_variables
  var user;
  MenuMedia(this.user);

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
      Offset.zero & const Size(200, 200),
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
                    var medias = await ImagesPicker.pick(
                      pickType: PickType.all,
                      language: Language.System,
                      count: 5,
                      quality: 0.6,
                    );
                    if (medias != null) {
                      Get.to(() => MediaPreviewScreen(medias, user));
                    }
                  },
                  icon: const Icon(Icons.photo_rounded)),
              IconButton(
                  onPressed: () async {
                    Get.back();
                    var medias = await ImagesPicker.openCamera(
                      pickType: PickType.image,
                      language: Language.System,
                      quality: 0.6,
                    );
                    if (medias != null) {
                      Get.to(() => MediaPreviewScreen(medias, user));
                    }
                  },
                  icon: const Icon(Icons.camera_alt)),
              IconButton(
                  onPressed: () async {
                    Get.back();
                    var medias = await ImagesPicker.openCamera(
                      pickType: PickType.video,
                      language: Language.System,
                      quality: 0.6,
                      maxTime: 30,
                      maxSize: 20000,
                    );
                    if (medias != null) {
                      Get.to(() => MediaPreviewScreen(medias, user));
                    }
                  },
                  icon: const Icon(Icons.videocam_rounded)),
            ],
          ),
        )
      ],
    );
  }
}
