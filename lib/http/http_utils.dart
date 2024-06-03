import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../utils/toast_utils.dart';

///请求方式-枚举类型
enum MethodType { get, post, delete, put, patch }

class HttpUtils {
  static final HttpUtils _instance = HttpUtils._internal(baseUrl: '');

  factory HttpUtils() => _instance;

  late Dio dio;

  HttpUtils._internal({required String baseUrl}) {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      contentType: 'application/json; charset=utf-8',
      connectTimeout: const Duration(milliseconds: 15000),
      receiveTimeout: const Duration(milliseconds: 15000),
      responseType: ResponseType.json,
      validateStatus: (status) {
        return true;
      },
    );

    dio = Dio(options);

    /// 添加请求日志
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseHeader: false,
      responseBody: false,
      error: false,
    ));

    /// 添加拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        /// 打印返回值
        const bool inProduction = bool.fromEnvironment("dart.vm.product");
        if (!inProduction) {
          log(
            jsonEncode(response.data),
            name: 'Response Text:  ',
          );
        }

        /// 对接口抛出异常的检查
        _apiVerify(response);
        return handler.next(response);
      },
    ));
  }

  ///统一请求入口
  static Future<NetResult> request(
    String baseUrl,
    String path, {
    String? token,
    MethodType method = MethodType.get,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool isShowLoading = false,
    CancelToken? cancelToken,
  }) async {
    ///开始网络请求
    late NetResult netResult;
    Dio dio = HttpUtils._internal(baseUrl: baseUrl).dio;
    // String? token1 = token ?? '';
    Map<String, dynamic> headerMap = {};
    if (headers != null) headerMap.addAll(headers);
    headerMap['token'] = token;
    headerMap['Authorization'] = token;
    Options options = Options(
      method: method.name,
      headers: headerMap,
    );
    CancelToken newCancelToken = cancelToken ?? CancelToken();
    try {
      if (isShowLoading) {
        await EasyLoading.show(
          // status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
      }

      final response = await dio.request(
        path,
        options: options,
        queryParameters: queryParameters,
        data: body,
        cancelToken: newCancelToken,
      );
      // if (response.headers["authorization"] != null) {
      //   LocalStore.setValue(
      //       key: StoreValue.tokenKey,
      //       value: response.headers["authorization"]![0]);
      // }
      if (isShowLoading) EasyLoading.dismiss();
      netResult = NetResult(
        headers: response.headers,
        result: response.data,
        statusCode: response.statusCode ?? 0,
        error: _apiIsSucceed(response),
      );
    } on DioError catch (error) {
      if (isShowLoading) EasyLoading.dismiss();
      _formatError(error);
      netResult = NetResult(
        errorMeg: error.message ?? '服务器出现错误',
      );
    }
    return netResult;
  }

  ///下载
  static Future<NetResult> download(
    String path,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    data,
    Options? options,

  }) async {
    ///开始网络请求
    late NetResult netResult;
    try {
      Response response = await Dio().download(
        path,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: options,
      );
      netResult = NetResult(
        headers: response.headers,
        result: 'Download successful',
        statusCode: response.statusCode ?? 0,
        error: response.statusCode != 200,
      );
    } on DioError catch (error) {
      _formatError(error);
      netResult = NetResult(
        errorMeg: error.message ?? '服务器出现错误',
        result: 'Download failure',
      );
    }
    return netResult;
  }

  ///判断接口是否成功
  static bool _apiIsSucceed(Response response) {
    if (response.data != null && response.data != '') {
      Map<String, dynamic> map = response.data;
      return map['resultCode'] == 'OK' ? false : true;
    }
    return false;
  }

  ///接口校验
  static void _apiVerify(Response response,{VoidCallback? unLoginAction}) {
    if (response.data != null && response.data != '') {
      ///判断返回值是否是Map
      if (response.data is Map) {
        Map<String, dynamic> map = response.data;
        String resultCode = map['resultCode'];

        if (resultCode.toUpperCase() == "FAIL") {
          throw DioException(
            requestOptions: RequestOptions(path: ''),
            response: response,
            type: DioExceptionType.unknown,
            error: response.data,
            message: map['resultMsg'],
          );
        }

        if (resultCode.toUpperCase() == "UNLOGIN") {
          unLoginAction?.call();
          return;
        }
      } else if (response.data is String) {
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          response: response,
          type: DioExceptionType.unknown,
          error: response.data,
          message: response.data,
        );
      }
    } else {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        response: response,
        type: DioExceptionType.unknown,
        error: response.data,
        message: response.data,
      );
    }
  }

  /*
   * Dio库error统一处理
   */
  static void _formatError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.connectionTimeout:
        ToastUtils.showToast(msg: '网络连接超时');
        break;
      case DioExceptionType.sendTimeout:
        ToastUtils.showToast(msg: '网络请求超时');
        break;
      case DioExceptionType.receiveTimeout:
        ToastUtils.showToast(msg: '服务响应超时');
        break;
      case DioExceptionType.unknown:
        ToastUtils.showToast(msg: error.message);
        break;
      case DioExceptionType.badResponse:
        try {
          int? errCode = error.response!.statusCode;
          String? errMsg = error.response!.statusMessage;
          switch (errCode) {
            case 400:
              ToastUtils.errorToast(errorText: '请求语法错误');
              break;
            case 401:
              ToastUtils.errorToast(errorText: '没有权限');
              break;
            case 403:
              ToastUtils.errorToast(errorText: '服务器拒绝执行');
              break;
            case 404:
              ToastUtils.errorToast(errorText: '无法连接服务器');
              break;
            case 405:
              ToastUtils.errorToast(errorText: '请求方法被禁止');
              break;
            case 500:
              ToastUtils.errorToast(errorText: '服务器出现问题');
              break;
            case 502:
              ToastUtils.errorToast(errorText: '无效的请求');
              break;
            case 503:
              ToastUtils.errorToast(errorText: '服务器挂了');
              break;
            case 505:
              ToastUtils.errorToast(errorText: '不支持HTTP协议请求');
              break;
            default:
              ToastUtils.errorToast(errorText: errMsg ?? '未知错误');
              break;
          }
        } on Exception catch (_) {
          ToastUtils.errorToast(errorText: '未知错误');
          break;
        }
        break;
      default:
        ToastUtils.errorToast(errorText: error.message);
        break;
    }
  }
}

/// 自定义Dio返回类
class NetResult {
  dynamic result;

  dynamic headers;

  int total;

  bool error;

  int statusCode;

  String errorMeg;

  bool get success => !error;

  NetResult({
    this.result,
    this.headers,
    this.statusCode = -1,
    this.error = true,
    this.total = 0,
    this.errorMeg = '',
  });

  @override
  String toString() {
    return 'NetResult：statusCode: $statusCode \n'
        'NetResult: headers: $headers \n'
        'NetResult: error: $error \n'
        'NetResult: total: $total \n'
        'NetResult: errorMeg: $errorMeg \n'
        'NetResult: result: ${result.toString()}';
  }
}

/// 自定义Dio取消请求处理类
class CustomCancelToken {
  static CancelToken cancelToken = CancelToken();

  static cancel() {
    cancelToken.cancel('取消请求');
    cancelToken = CancelToken();
  }
}
