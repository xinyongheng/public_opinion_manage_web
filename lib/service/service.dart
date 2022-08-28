import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:public_opinion_manage_web/config/config.dart';
import 'package:public_opinion_manage_web/custom/dialog.dart';
import 'package:public_opinion_manage_web/utils/token_util.dart';

typedef SuccessCallback = void Function(dynamic data);
typedef ErrorCallback = void Function(String msg, dynamic data);

class ServiceHttp {
  // static void checkToken(String token, Callback callback) {}
  static ServiceHttp? _instance;
  late Dio _dio;
  static const String parentUrl = 'http://192.168.3.14:8200';
  // static const String parentUrl = 'http://192.168.1.107:8200';
  static const String loginApi = '/api/login';
  static const String registerApi = '/api/register';

  EasyLoadingStatusCallback? callback;

  // 私有的命名构造函数
  ServiceHttp._internal() {
    _dio = Dio();
    _setIntercept();
  }

  factory ServiceHttp() {
    _instance ??= ServiceHttp._internal();
    return _instance!;
  }

  dio() => _dio;

  Future<void> addHeaders(Map map, String path) async {
    if (!path.contains('/api/')) {
      String? token = await UserUtil.getToken();
      map['Authorization'] = token!;
    }
    map['Platform'] = loadPlatform();
  }

  String loadPlatform() {
    if (kIsWeb) return 'html';
    return Platform.operatingSystem;
  }

  void get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool isData = true,
    required SuccessCallback success,
    ErrorCallback? error,
  }) async {
    showWaitDialog();
    String finalPath = path.startsWith('http') ? path : (parentUrl + path);
    Response res = await _dio
        .get(finalPath,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress)
        .catchError((err) {
      print('Error11: $err');
      showNoticeDialog('请检查网络，稍后重试');
    });
    _handleRes(res, isData, success, error);
  }

  void _handleRes(Response<dynamic> res, bool isData, SuccessCallback success,
      ErrorCallback? error) {
    int code = res.data['code'];
    String message = res.data['message'] ?? "未知错误";
    if (code != 200) {
      //  错误
      _handlerError(message, code, error);
    } else {
      success.call(isData ? res.data['data'] : res.data);
    }
  }

  void post<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      bool isData = true,
      required SuccessCallback success,
      ErrorCallback? error}) async {
    String finalPath = path.startsWith('http') ? path : (parentUrl + path);
    Response res = await _dio
        .post(finalPath,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress)
        .catchError((err) {
      print('Error11: $err');
      showNoticeDialog('请检查网络，稍后重试');
    });
    _handleRes(res, isData, success, error);
  }

  void _handlerError(String message, int code, ErrorCallback? callback) {
    showNoticeDialog(message);
    if (code == 401) {
      Config.startLoginPage();
    } else {
      callback?.call(message, null);
    }
  }

  void _setIntercept() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        showWaitDialog();
        Map map = options.headers;
        await addHeaders(map, options.path);
        print(options.headers);
        print(options.data);
        print('*************input**************');
        handler.next(options);
      },
      onResponse: (Response e, ResponseInterceptorHandler handler) {
        // print('onResponse： ${DateTime.now()}');
        print(json.encode(e.data));
        print('*************output**************');
        handler.next(e);
        dismissDialog();
      },
      onError: (DioError e, ErrorInterceptorHandler handler) {
        // handler.next(e);
        print(e.message);
        handler.resolve(Response(
            requestOptions: e.requestOptions,
            statusCode: 444,
            data: {"code": 444, 'message': e.message},
            statusMessage: 'fail'));
        dismissDialog();
      },
    ));
  }
}
