import 'package:url_launcher/url_launcher.dart';

enum LaunchType { tel, sms, email, link }

const launchTypeValues = {
  LaunchType.tel: "tel:",
  LaunchType.sms: "sms:",
  LaunchType.email: "mailto:",
  LaunchType.link: ''
};

class LaunchUtils {
  ///自定义Launch方法
  static Future<bool> customLaunch({
    required String urlString,
    LaunchType launchType = LaunchType.link,
    bool enableJavaScript = false,
    bool enableDomStorage = false,
    Map<String, String> headers = const <String, String>{},
    LaunchMode mode = LaunchMode.externalApplication,
    String? webOnlyWindowName,
  }) {
    return launchUrl(
      Uri.parse('${launchTypeValues[launchType]}$urlString'),
      webViewConfiguration: WebViewConfiguration(
        enableJavaScript: enableJavaScript,
        enableDomStorage: enableDomStorage,
        headers: headers,
      ),
      mode: mode,
      webOnlyWindowName: webOnlyWindowName,
    );
  }

  ///判断是否打开链接
  static Future<bool> customCanLaunch(
    String urlString, {
    LaunchType launchType = LaunchType.link,
  }) async {
    return canLaunchUrl(Uri.parse('${launchTypeValues[launchType]}$urlString'));
  }
}
