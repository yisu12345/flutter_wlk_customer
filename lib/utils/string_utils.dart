// import 'package:intl/intl.dart';

extension StringUtils on String? {
  String get hidePhone => StringUtils._phoneString(phone: this);

  String get hideUserName => StringUtils._userNameString(name: this);

  bool get isNumeric => StringUtils._isNumeric(str: this);

  String get toPrice => StringUtils._cutOutPrice(price: this);

  String get toSplMoney => StringUtils._splNumberInsyo(str: this);

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
        // NumberFormat format = NumberFormat('0,000');
        return _formatNum(truncateMoney);
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

  static String _formatNum(num, {point = 3}) {
    if (num != null) {
      String str = double.parse(num.toString()).toString();
      // 分开截取
      List<String> sub = str.split('.');
      // 处理值
      List val = List.from(sub[0].split(''));
      // 处理点
      List<String> points = List.from(sub[1].split(''));
      //处理分割符
      for (int index = 0, i = val.length - 1; i >= 0; index++, i--) {
        // 除以三没有余数、不等于零并且不等于1 就加个逗号
        if (index % 3 == 0 && index != 0 && i != 1) val[i] = val[i] + ',';
      }
      // 处理小数点
      for (int i = 0; i <= point - points.length; i++) {
        points.add('0');
      }
      //如果大于长度就截取
      if (points.length > point) {
        // 截取数组
        points = points.sublist(0, point);
      }
      // 判断是否有长度
      if (points.length > 0) {
        return '${val.join('')}.${points.join('')}';
      } else {
        return val.join('');
      }
    } else {
      return "0.0";
    }
  }

  ///将数字转换位千分位隔开
  static String _splNumberInsyo({String? str}) {
    if (str?.isEmpty == true) {
      return '';
    }
    // num amount = num.parse(str ?? '0');
    // final NumberFormat formatter = NumberFormat.currency(
    //   locale: 'en_US', // 设置为你的本地化Locale
    //   decimalDigits: 0,
    //   name: '', // 设置货币符号，例如 'USD' 或 'EUR'
    // );
    // return formatter.format(amount);
    return str ?? '';
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
