class FileInfo {
  late String type;
  late String name;
  late String path;
  // FileInfo();
  FileInfo(this.path) {
    int pointIndex = path.lastIndexOf('/');
    if (pointIndex > -1) {
      name = path.substring(pointIndex);
    } else {
      name = path;
    }
    type = fileType(name);
  }

  String fileName(String path) {
    int pointIndex = path.lastIndexOf('/');
    if (pointIndex > -1) {
      return path.substring(pointIndex);
    } else {
      return path;
    }
  }

  String fileType(String name) {
    int pointIndex = name.lastIndexOf('.');
    String endString;
    if (pointIndex > -1) {
      endString = name.substring(pointIndex);
    } else {
      endString = name;
    }
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
      default:
        return 'file';
    }
  }
}
