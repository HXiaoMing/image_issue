import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

class ImageProcessUtil {
  ImageProcessUtil._();

  static const _tag = 'ImageProcessUtil';

  static Future<void> generateGIF() async {
    final imagesList = await _getImageList();

    print('$_tag imagesList len ${imagesList.length}');

    final gif = await _generateGIF(imagesList);

    if (gif == null) {
      print('$_tag generateGIF err');
      return;
    }

    final docDir = await getApplicationDocumentsDirectory();

    final imgGif = File('${docDir.path}/generatea.gif');
    await imgGif.writeAsBytes(gif);

    print('$_tag generate gif succ');
  }

  static Future<List<Image>> _getImageList() async {
    List<Image> imagesList = [];

    for (int index = 0; index < 7; index++) {
      final data = await rootBundle.load('assets/images/pic$index.png');

      final pngDecoder = PngDecoder();

      final decodedImage = pngDecoder.decodeImage(data.buffer.asUint8List());

      if (decodedImage != null) {
        imagesList.add(decodedImage);
      }
    }

    return imagesList;
  }

  static Future<List<int>?> _generateGIF(Iterable<Image> images) async {
    return compute<Iterable<Image>, List<int>?>((imgList) {
      final Animation animation = Animation();

      animation.backgroundColor = 0x00000000;

      for (Image image in imgList) {
        animation.addFrame(image);
      }
      return encodeGifAnimation(animation);
    }, images);
  }
}
