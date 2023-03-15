import 'base_bean.dart';

class User extends BaseBean {
  String? token;
  String? loginTime;
  UserData? data;

  User({
    int? code,
    String? message,
    this.token,
    this.data,
  }) : super(code: code, message: message);

  User.fromJson(Map<String, dynamic> json) {
    BaseBean.fromJson(json);
    token = json['token'];
    loginTime = json['loginTime'];
    data = UserData.fromJson(json['data']);
  }
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = super.toJson();
    map['token'] = token;
    map['loginTime'] = loginTime;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class UserData {
  int? id;
  int? status;
  String? nickname;
  String? account;
  String? password;
  String? openid;
  String? unionid;
  int? type;
  String? unit;
  String? ctime;
  String? utime;

  UserData(
      {this.id,
      this.status,
      this.nickname,
      this.account,
      this.password,
      this.openid,
      this.unionid,
      this.type,
      this.unit,
      this.ctime,
      this.utime});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    nickname = json['nickname'];
    if (json.containsKey('account')) {
      account = json['account'];
    } else {
      account = json['phone'];
    }
    password = json['password'];
    openid = json['openid'];
    unionid = json['unionid'];
    type = json['type'];
    unit = json['unit'];
    ctime = json['ctime'];
    utime = json['utime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['nickname'] = nickname;
    data['account'] = account;
    data['password'] = password;
    data['openid'] = openid;
    data['unionid'] = unionid;
    data['type'] = type;
    data['unit'] = unit;
    data['ctime'] = ctime;
    data['utime'] = utime;
    return data;
  }

  static List<UserData> fromJsonArray(List? data) {
    if (data == null) return [];
    final list = <UserData>[];
    for (int i = 0; i < data.length; i++) {
      final v = data[i];
      final bean = UserData.fromJson(v);
      list.add(bean);
    }
    return list;
  }
}
