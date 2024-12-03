import 'package:flutter/material.dart';
import 'package:flutter_wlk_customer/calendarcalendar/custom_calendar_range_picker_widget.dart';
import 'package:flutter_wlk_customer/calendarcalendar/custom_date_picker.dart';
import 'package:flutter_wlk_customer/utils/date_utils.dart';
import 'package:flutter_wlk_customer/utils/toast_utils.dart';

///公用区间日期选选择组件
class CalendarChooseWidget extends StatefulWidget {
  final Function? tapAction;
  final int? intervalDays; //间隔天数 (包括选中第一天和选中的最后一天)
  final DateTime? selectedDate; //默认选中日期
  final int? chooseIndex;
  final double? fontSize;
  final DateTimeUtilsType? dateTimeUtilsType;
  final FontWeight? fontWeight;
  final bool? onlyShow;
  final Color? textColor;
  final bool? isScafforrd;

  const CalendarChooseWidget({
    super.key,
    this.tapAction,
    this.intervalDays,
    this.selectedDate,
    this.chooseIndex = 0,
    this.fontSize,
    this.onlyShow,
    this.fontWeight,
    this.dateTimeUtilsType,
    this.textColor,
    this.isScafforrd,
  });

  @override
  _CalendarChooseWidgetState createState() => _CalendarChooseWidgetState();
}

class _CalendarChooseWidgetState extends State<CalendarChooseWidget> {
  ///开始时间
  DateTime? startTime = DateTime.now();

  ///结束时间
  DateTime? endTime;

  ///选择的时间区间
  DateTime? rangeStartTime = DateTime.now();
  DateTime? rangeEndTime;

  ///日期选择方法
  onDateSelected(DateTime? startDate, DateTime? endDate) {
    setState(() {
      rangeStartTime = startDate;
      rangeEndTime = endDate;
    });
  }

  ///确定按钮
  onConfirm() {
    if (widget.intervalDays != null && rangeEndTime != null) {
      var difference = rangeEndTime!.difference(rangeStartTime!);
      if (difference.inDays + 1 > widget.intervalDays!) {
        ToastUtils.showToast(msg: "时间差不能大于${widget.intervalDays}天");
      } else {
        changeDate();
      }
    } else {
      changeDate();
    }
  }

  ///把选中的时间数据赋值给initialStartDate、initialEndDate，并且返回选中的时间
  changeDate() {
    setState(() {
      startTime = rangeStartTime;
      endTime = rangeEndTime;
    });
    widget.tapAction
        ?.call({"startTime": startTime, "endTime": endTime ?? startTime});
    // Navigator.of(context).pop();
  }

  ///日期显示
  String get dealTimeString {
    String? time = "";
    if (endTime == null) {
      time = DateTimeUtils.dateTimeUtilsTool(
        dateTime: startTime.toString(),
        dateTimeUtilsType:
            widget.dateTimeUtilsType ?? DateTimeUtilsType.yearMonthDay,
      );
    } else if (endTime == startTime) {
      time = DateTimeUtils.dateTimeUtilsTool(
        dateTime: startTime.toString(),
        dateTimeUtilsType:
            widget.dateTimeUtilsType ?? DateTimeUtilsType.yearMonthDay,
      );
    } else {
      time = "${DateTimeUtils.dateTimeUtilsTool(
        dateTime: startTime.toString(),
        dateTimeUtilsType:
            widget.dateTimeUtilsType ?? DateTimeUtilsType.yearMonthDay,
      )} - ${DateTimeUtils.dateTimeUtilsTool(
        dateTime: endTime.toString(),
        dateTimeUtilsType:
            widget.dateTimeUtilsType ?? DateTimeUtilsType.yearMonthDay,
      )}";
    }
    return time;
  }

  ///日历弹窗
  onTapDate() {
    if (widget.chooseIndex == 1) {
      ToastUtils.showBottomSheet(
        context: context,
        title: '选择时间',
        height: MediaQuery.of(context).size.height / 2,
        isShowConfirm: true,
        contentWidget: CustomDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 2),
          lastDate: DateTime(DateTime.now().year + 2),
          onDateChanged: (dateTime) {
            rangeStartTime = dateTime;
            rangeEndTime = dateTime;
          },
        ),
        onConfirm: onConfirm,
      );
    } else {
      ToastUtils.showBottomSheet(
        context: context,
        title: '选择时间',
        height: MediaQuery.of(context).size.height / 2,
        isShowConfirm: true,
        contentWidget: CustomCalendarRangePickerWidget(
          firstDate: DateTime(DateTime.now().year - 2),
          lastDate: DateTime(DateTime.now().year + 2),
          initialStartDate: startTime,
          initialEndDate: endTime,
          selectedDateDecoration: BoxDecoration(
            color: const Color(0xff4D6FD5),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4),
          ),
          rangeBackgroundColor: const Color(0xffEDF0FF),
          weekendTextStyle: const TextStyle(
            color: Color(0xff4D6FD5),
            fontSize: 12,
          ),
          weekTextStyle: const TextStyle(
            color: Color(0xff333333),
            fontSize: 12,
          ),
          yearTextStyle: const TextStyle(
            color: Color(0xff333333),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          onDateSelected: onDateSelected,
        ),
        onConfirm: onConfirm,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      startTime = widget.selectedDate;
      rangeStartTime = widget.selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isScafforrd == true
        ? Scaffold(
            body: InkWell(
              onTap: widget.onlyShow == true ? null : onTapDate,
              child: Row(
                children: [
                  Text(
                    dealTimeString,
                    style: TextStyle(
                      color: widget.textColor ?? const Color(0xff1A1A1A),
                      fontSize: widget.fontSize ?? 16,
                      fontWeight: widget.fontWeight,
                    ),
                  ),
                  widget.onlyShow == true
                      ? const SizedBox()
                      : const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 15,
                        )
                ],
              ),
            ),
          )
        : InkWell(
            onTap: widget.onlyShow == true ? null : onTapDate,
            child: Row(
              children: [
                Text(
                  dealTimeString,
                  style: TextStyle(
                    color: widget.textColor ?? const Color(0xff1A1A1A),
                    fontSize: widget.fontSize ?? 16,
                    fontWeight: widget.fontWeight,
                  ),
                ),
                widget.onlyShow == true
                    ? const SizedBox()
                    : const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 15,
                      )
              ],
            ),
          );
  }
}
