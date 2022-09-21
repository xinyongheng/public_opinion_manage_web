import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:video_thumbnail_imageview/video_thumbnail_imageview.dart';

class FileInfoBean {
  late String type;
  late String fileEndType;
  String? name;
  late String path;
  final Uint8List? bytes;
  int? size;
  // FileInfo();
  FileInfoBean(this.path, {this.bytes, this.name, this.size}) {
    if (name == null) {
      int pointIndex = path.lastIndexOf('/');
      if (pointIndex > -1) {
        name = path.substring(pointIndex);
      } else {
        name = path;
      }
    }
    fileEndType = fileEndText(name!);
    type = fileType(name!);
  }

  String fileName(String path) {
    int pointIndex = path.lastIndexOf('/');
    if (pointIndex > -1) {
      return path.substring(pointIndex);
    } else {
      return path;
    }
  }

  static String fileEndText(String fileName) {
    int pointIndex = fileName.lastIndexOf('.');
    String endString;
    if (pointIndex > -1) {
      endString = fileName.substring(pointIndex + 1).toLowerCase();
    } else {
      endString = 'unknown';
    }
    return endString;
  }

  static String fileType(String name) {
    String endString = fileEndText(name);
    //print(endString);
    switch (endString.toLowerCase()) {
      case 'jpg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'jpeg':
      case 'tif':
      case 'svg':
        return 'image';
      case 'mp4':
      case 'mkv':
      case 'rm':
      case 'rmvb':
      case 'avi':
      case 'mpeg':
      case 'mov':
      case 'flv':
      case '3gp':
        return 'video';
      /* case 'txt':
        return 'txt';
      case 'doc':
      case 'docx':
        return 'word'; */
      default:
        return 'file';
    }
  }

  static Widget getTagIcon(FileInfoBean bean) {
    switch (bean.type) {
      case 'image':
        return bean.path.startsWith('web_') == true
            ? Image.memory(bean.bytes!, semanticLabel: bean.name)
            : Image.file(File(bean.path));
      case 'video':
        return Stack(
          children: [
            Image(image: MemoryImage(bean.bytes!)),
            const Icon(Icons.play_circle_fill_outlined),
          ],
        );
      default:
        return const Icon(Icons.file_copy);
    }
  }
}
