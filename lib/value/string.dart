import 'dart:convert';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:crypto/crypto.dart';


class BaseStringValue {
  static String chinaMoney = '￥';

  ///md5 加密 32位
  static String generate_MD5(String data) {
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return digest.toString();
  }

  ///cell key 随机数+时间
  static String cellKeyString({String? string}) {
    var random = Random();
    int randomNumber = random.nextInt(10000); // 生成0到10000000000000之间的随机整数
    return '$randomNumber + $string + ${DateTime.now().toString()}';
  }
}

