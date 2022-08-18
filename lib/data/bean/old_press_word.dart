class OldPressWordFile {
  int? id;
  int? state;
  int? userId;
  String? content;
  String? name;
  String? path;
  String? wordName;
  String? ctime;
  String? utime;

  OldPressWordFile(
      {this.id,
      this.state,
      this.userId,
      this.content,
      this.name,
      this.path,
      this.wordName,
      this.ctime,
      this.utime});

  OldPressWordFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
    userId = json['userId'];
    content = json['content'];
    name = json['name'];
    path = json['path'];
    wordName = json['wordName'];
    ctime = json['ctime'];
    utime = json['utime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['state'] = state;
    data['userId'] = userId;
    data['content'] = content;
    data['name'] = name;
    data['path'] = path;
    data['wordName'] = wordName;
    data['ctime'] = ctime;
    data['utime'] = utime;
    return data;
  }
}
