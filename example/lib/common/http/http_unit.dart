import 'package:flutter_wlk_customer/http/http_utils.dart';

class HttpUtil {
  static const String _debugAPi = "https://testing.map.jingheyijia.com/cityapp/api";

  static Future<NetResult> request(
    String path, {
    String? token,
    MethodType method = MethodType.get,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool isShowLoading = false,
  }) async {
    return await HttpUtils.request(
      _debugAPi,
      path,
      token: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MTc4MTYyMjcsImp0aSI6IjEiLCJpYXQiOjE3MTUyMjQyMjcsImlzcyI6InVzZXItdG9rZW4ifQ.4IPEodjBt8OUWVMG3FoANY3DYZlToWYcIDxjm9qlewU',
      method: method,
      body: body,
      queryParameters: queryParameters,
      isShowLoading: isShowLoading,

    );
  }
}
