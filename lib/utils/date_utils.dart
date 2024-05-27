import 'package:flustars_flutter3/flustars_flutter3.dart';

enum DateTimeUtilsType {
  yearMonthDayHourMinuteSecond, // 2024-01-01 01:01:01
  yearMonthDayHourMinute, // 2024-01-01 01:01
  yearMonthDay, // 2024-01-01
  monthDay, //01-01
  monthDayPoint, //01.01
  monthDayWord, //01月01日
  yearMonthDayPoint, // 2024.01.01
  yearMonthDayHourMinutePoint, // 2024.01.01
  yearMonthDayHourMinuteSecondPoint, // 2024.01.01 01:01:01
  yearMonthDayWord, // 2024年01月01日
  yearMonthWord, // 2024年01月
  yearMonth, // 2024-01
  yearMonthPoint, // 2024.01
  hourMinuteSecond, // 01:01:01
  hourMinute, // 01:01
  monthDayLine, // 01:01
  monthWord, //01月
}

class DateTimeUtils {
  static String dateTimeUtilsTool({
    DateTimeUtilsType? dateTimeUtilsType,
    String? dateTime,
    String nullString = '-- --',
  }) {
    if (dateTime == null || dateTime == '') return nullString;
    DateTime date = DateTime.parse(dateTime).toLocal();
    switch (dateTimeUtilsType) {
      case null:
        return nullString;
      case DateTimeUtilsType.yearMonthDayHourMinuteSecond:
        return '${date.year.toString()}'
            '-${date.month.toString().padLeft(2, '0')}'
            '-${date.day.toString().padLeft(2, '0')}'
            ' ${date.hour.toString().padLeft(2, '0')}'
            ':${date.minute.toString().padLeft(2, '0')}'
            ':${date.second.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.yearMonthDayHourMinute:
        return '${date.year.toString()}'
            '-${date.month.toString().padLeft(2, '0')}'
            '-${date.day.toString().padLeft(2, '0')}'
            ' ${date.hour.toString().padLeft(2, '0')}'
            ':${date.minute.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.yearMonthDay:
        return '${date.year.toString()}'
            '-${date.month.toString().padLeft(2, '0')}'
            '-${date.day.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.monthDay:
        return '${date.month.toString().padLeft(2, '0')}'
            '-${date.day.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.monthDayPoint:
        return '${date.month.toString().padLeft(2, '0')}'
            '.${date.day.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.monthDayWord:
        return '${date.month.toString().padLeft(2, '0')}月'
            '${date.day.toString().padLeft(2, '0')}日';
      case DateTimeUtilsType.yearMonthDayPoint:
        return '${date.year.toString()}'
            '.${date.month.toString().padLeft(2, '0')}'
            '.${date.day.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.yearMonthDayHourMinuteSecondPoint:
        return '${date.year.toString()}'
            '.${date.month.toString().padLeft(2, '0')}'
            '.${date.day.toString().padLeft(2, '0')}'
            ' ${date.hour.toString().padLeft(2, '0')}'
            ':${date.minute.toString().padLeft(2, '0')}'
            ':${date.second.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.yearMonthDayHourMinutePoint:
        return '${date.year.toString()}'
            '.${date.month.toString().padLeft(2, '0')}'
            '.${date.day.toString().padLeft(2, '0')}'
            ' ${date.hour.toString().padLeft(2, '0')}'
            ':${date.minute.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.yearMonthDayWord:
        return '${date.year.toString()}'
            '年${date.month.toString().padLeft(2, '0')}'
            '月${date.day.toString().padLeft(2, '0')}日';
      case DateTimeUtilsType.yearMonthWord:
        return '${date.year.toString()}'
            '年${date.month.toString().padLeft(2, '0')}月';
      case DateTimeUtilsType.yearMonth:
        return '${date.year.toString()}'
            '-${date.month.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.yearMonthPoint:
        return '${date.year.toString()}'
            '.${date.month.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.hourMinuteSecond:
        return '${date.hour.toString().padLeft(2, '0')}'
            ':${date.minute.toString().padLeft(2, '0')}'
            ':${date.second.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.hourMinute:
        return '${date.hour.toString().padLeft(2, '0')}'
            ':${date.minute.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.monthDayLine:
        return '${date.month.toString().padLeft(2, '0')}'
            '/${date.day.toString().padLeft(2, '0')}';
      case DateTimeUtilsType.monthWord:
        return '${date.month.toString().padLeft(2, '0')}月';
    }
  }

  ///  计算两个日期相差多少天？
  static int differenceTwoTimes({
    String? startTime,
    String? endTime,
  }) {
    var startDate =
        startTime == null ? DateTime.now() : DateTime.parse(startTime);
    var endDate = endTime == null ? DateTime.now() : DateTime.parse(endTime);
    var days = endDate.difference(startDate).inDays;
    return days;
  }

  ///  计算两个日期相差inMinutes？
  static int differenceTwoInMinutesTimes({
    String? startTime,
    String? endTime,
  }) {
    var startDate =
        startTime == null ? DateTime.now() : DateTime.parse(startTime);
    var endDate = endTime == null ? DateTime.now() : DateTime.parse(endTime);
    var days = endDate.difference(startDate).inMinutes;
    return days;
  }

  ///获取当前月份
  static String getCurrentMonth() {
    DateTime date = DateTime.now();
    return date.month.toString().padLeft(2, '0');
  }

  ///获取当前的年月日
  static String getCurrentYMD() {
    DateTime date = DateTime.now();
    return '${date.year.toString()}'
        '-${date.month.toString().padLeft(2, '0')}'
        '-${date.day.toString().padLeft(2, '0')}';
  }

  ///判断时间是否在某个时间区间内
  static bool isTimeInRange({
    required DateTime startTime,
    required DateTime endTime,
    required DateTime dateTime,
  }) {
    return dateTime.isAfter(startTime) && dateTime.isBefore(endTime);
  }

  ///获取当月份
  static String get getMonth {
    return DateTime.now().month.toString();
  }

  ///获取当年份
  static String get getYear {
    return '2022';
    return DateTime.now().year.toString();
  }

  ///获取当前属于第几周
  static String getWeekDay(DateTime dateTime) {
    List<String> weekday = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];
    return weekday[dateTime.weekday - 1];
  }

  ///根据日期获取某月的第一天和最后一天
  static Map<String, dynamic> getMonthStartAndMonthEnd(
      {required DateTime dateTime}) {
    DateTime monthStart = DateTime(
      dateTime.year,
      dateTime.month,
      1,
    ); // 获取本月第一天的日期时间
    DateTime monthEnd = DateTime(
      dateTime.year,
      dateTime.month + 1,
      0,
      23,
      59,
      59,
    ); // 获取本月最后一天的日期时间（时间为23:59:59）
    return {
      'monthStart': monthStart,
      'monthEnd': monthEnd,
    };
  }
//
//             DateTime monthStart = DateTime(
//             int.parse(time.toString().split('-').first),
//             int.parse(time.toString().split('-').last),
//             1); // 获取本月第一天的日期时间
//         DateTime monthEnd = DateTime(
//             int.parse(time.toString().split('-').first),
//             int.parse(time.toString().split('-').last) + 1,
//             0,
//             23,
//             59,
//             59); // 获取本月最后一天的日期时间（时间为23:59:59）
  /// /
}

class TimeMachineUtil {
  /// 获取某一年的第一个月的第一天和最后一个月的最后一天
  static getStartEndYearDate(int iYear) {
    Map mapDate = {};
    int yearNow = DateTime.now().year;
    yearNow = yearNow + iYear;

    String newStartYear = '$yearNow-01-01';
    String newEndtYear = '${yearNow + 1}-01-00';

    mapDate['startTime'] = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(turnTimestamp(newStartYear)),
        format: 'yyyy-MM-dd');
    mapDate['endTime'] = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(turnTimestamp(newEndtYear)),
        format: 'yyyy-MM-dd');

    mapDate['startStamp'] = turnTimestamp(mapDate['startTime'] + ' 00:00:00');
    mapDate['endStamp'] = turnTimestamp(mapDate['endTime'] + ' 23:59:59');
    print('某一年初和年末：$mapDate');
  }

  /// 获得当前日期 未来/过去 第某个月第一天和最后一天时间
  static Map<String, String> getMonthDate(int iMonth) {
    //获取当前日期
    var currentDate = DateTime.now();
    if (iMonth + currentDate.month > 0) {
      return timeConversion(
          iMonth + currentDate.month, (currentDate.year).toString());
    } else {
      int beforeYear = (iMonth + currentDate.month) ~/ 12;
      String yearNew = (currentDate.year + beforeYear - 1).toString();
      int monthNew = (iMonth + currentDate.month) - beforeYear * 12;
      return timeConversion(12 + monthNew, yearNew);
    }
  }

  static Map<String, String> timeConversion(int monthTime, String yearTime) {
    Map<String, String> dateMap = {};
    dateMap['startDate'] =
        '$yearTime-${monthTime < 10 ? '0$monthTime' : '$monthTime'}-01';
    //转时间戳再转时间格式 防止出错
    dateMap['startDate'] = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(
            turnTimestamp(dateMap['startDate'] ?? "")),
        format: 'yyyy-MM-dd');
    //某个月结束时间，转时间戳再转
    String endMonth =
        '$yearTime-${(monthTime + 1) < 10 ? '0${monthTime + 1}' : (monthTime + 1)}-00';
    var endMonthTimeStamp = turnTimestamp(endMonth);
    endMonth = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(endMonthTimeStamp),
        format: 'yyyy-MM-dd');
    dateMap['endDate'] = endMonth;
    //这里是为了公司后台接口 需加时间段的时间戳 但不显示在格式化实践中
    dateMap['startDateStamp'] =
        turnTimestamp('${dateMap['startDate']} 00:00:00').toString();
    dateMap['endDateStamp'] =
        turnTimestamp('${dateMap['endDate']} 23:59:59').toString();
    // print('过去未来某个月初月末：$dateMap');
    return dateMap;
  }

  /// 转时间戳
  static int turnTimestamp(String timestamp) {
    return DateTime.parse(timestamp).millisecondsSinceEpoch;
  }

  /// 当前时间 过去/未来 某个周的周一和周日
  static Map<String, String> getWeeksDate(int weeks) {
    Map<String, String> mapTime = {};
    DateTime now = DateTime.now();
    int weekday = now.weekday; //今天周几

    var sunDay = getTimestampLatest(false, 7 - weekday + weeks * 7); //周末
    var monDay = getTimestampLatest(true, -weekday + 1 + weeks * 7); //周一

    mapTime['monDay'] = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(monDay),
        format: 'yyyy-MM-dd'); //周一 时间格式化
    mapTime['sunDay'] = DateUtil.formatDate(
        DateTime.fromMillisecondsSinceEpoch(sunDay),
        format: 'yyyy-MM-dd'); //周一 时间格式化
    mapTime['monDayStamp'] = '$monDay'; //周一 时间戳
    mapTime['sunDayStamp'] = '$sunDay'; //周日 时间戳
    // print('某个周的周一和周日：$mapTime');
    return mapTime;
  }

  /// phase : 是零点还是23:59:59
  static int getTimestampLatest(bool phase, int day) {
    String newHours;
    DateTime now = DateTime.now();
    DateTime sixtyDaysFromNow = now.add(Duration(days: day));
    String formattedDate =
        DateUtil.formatDate(sixtyDaysFromNow, format: 'yyyy-MM-dd');
    if (phase) {
      newHours = '$formattedDate 00:00:00';
    } else {
      newHours = '$formattedDate 23:59:59';
    }

    DateTime newDate = DateTime.parse(newHours);
    // String newFormattedDate =
    //     DateUtil.formatDate(newDate, format: 'yyyy-MM-dd HH:mm:ss');
    int timeStamp = newDate.millisecondsSinceEpoch;
    // print('时间' + newFormattedDate);
    return timeStamp;
  }
}
