import 'package:public_opinion_manage_web/data/bean/user_bean.dart';
import 'package:public_opinion_manage_web/utils/info_save.dart';

class UserUtil {
  static const String tokenName = 'token';
  static const String reLogin = 'reLogin';

  static Future<bool> isLogin() async => !DataUtil.isEmpty(await getToken());

  //Bearer
  static save(UserData user, {String? token, required String loginTime}) async {
    await InfoSaveUtil.save('id', user.id!);
    await InfoSaveUtil.save('nickname', user.nickname ?? '');
    if (token?.isNotEmpty == true) {
      if (token!.startsWith('Bearer')) {
        await InfoSaveUtil.save(UserUtil.tokenName, token);
      } else {
        await InfoSaveUtil.save(UserUtil.tokenName, "Bearer $token");
      }
    }
    await InfoSaveUtil.save('account', user.account!);
    await InfoSaveUtil.save('type', user.type!);
    await InfoSaveUtil.save('unit', user.unit!);
    await InfoSaveUtil.save('ctime', user.ctime ?? '');
    await InfoSaveUtil.save('utime', user.utime ?? '');
    await InfoSaveUtil.save('loginTime', loginTime);
  }

  static Future<bool> clearUser() async => await InfoSaveUtil.clear();

  static Future<String?> getToken() async =>
      await InfoSaveUtil.getString(UserUtil.tokenName);

  static getUserId() async => await InfoSaveUtil.getInt('id');

  static getAccount() async => await InfoSaveUtil.getString('account');

  static getName() async => await InfoSaveUtil.getString('nickname');

  static getType() async => await InfoSaveUtil.getInt('type');

  static getUnit() async => await InfoSaveUtil.getString('unit');

  static getLoginTime() async => await InfoSaveUtil.getString('loginTime');

  static getStringValue(String key) async => await InfoSaveUtil.getString(key);

  static getUser() async {
    return UserData(
      id: await getUserId(),
      nickname: await getName(),
      account: await getAccount(),
      type: await getType(),
      unit: await getUnit(),
      ctime: await getStringValue('ctime'),
      utime: await getStringValue('utime'),
    );
  }

  static Future<Map<String, dynamic>> makeUserIdMap() async {
    final map = <String, dynamic>{};
    map['userId'] = await getUserId();
    return map;
  }
}
