import 'package:intl/intl.dart';

extension StringUtils on String? {
  String get hidePhone => StringUtils._phoneString(phone: this);

  String get hideUserName => StringUtils._userNameString(name: this);

  bool get isNumeric => StringUtils._isNumeric(str: this);

  String get toPrice => StringUtils._cutOutPrice(price: this);

  String get toThousandPrice => StringUtils._formatThousandPrice(price: this);

  double get toDouble => StringUtils._strToDouble(str: this);

  ///隐藏手机号中间4位数
  static String _phoneString({String? phone}) {
    if (phone == null || phone == '') return '';
    return phone.replaceFirst(RegExp(r'\d{4}'), '****', 3);
  }

  ///隐藏姓名(只显示姓  隐藏名字)
  static String _userNameString({String? name}) {
    if (name == null || name == '') return '';
    return name.replaceAll(name.substring(1, name.length), '**');
  }

  ///判断是否是纯数字
  static bool _isNumeric({String? str}) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  ///将金额转换为小数点后两位
  static String _cutOutPrice({String? price}) {
    String cutOutPrice = '0.00';
    if (price != null && price != '') {
      var newPrice = double.tryParse(price);
      if (newPrice != null) {
        cutOutPrice = newPrice.toStringAsFixed(2);
      }
    }
    return cutOutPrice;
  }

  ///金额处理千分位金额
  static String _formatThousandPrice({String? price}) {
    String priceStr = price ?? '';
    try {
      num? money = num.tryParse(priceStr);
      int truncateMoney = money?.truncate() ?? 0;
      if (truncateMoney >= 1000) {
        NumberFormat format = NumberFormat('0,000');
        return format.format(truncateMoney);
      } else {
        List<String> resultList = priceStr.split(".");
        if (resultList.isNotEmpty) {
          return priceStr.split(".").first;
        } else {
          return priceStr;
        }
      }
    } catch (error) {
      return '';
    }
  }

  ///将字符串转为double
  static double _strToDouble({String? str}) {
    String newStr = str ?? '';
    try {
      double? doubleValue = double.tryParse(newStr);
      if (doubleValue != null) {
        return doubleValue;
      }
      return 0;
    } catch (error) {
      return 0;
    }
  }
}
