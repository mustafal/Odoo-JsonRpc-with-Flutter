import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odoo_common_code_latest/common/config/localization/localize.dart';

typedef void OnDateChange(DateTime dateTime);
typedef void OnTimeChange(TimeOfDay dateTime);

class DatePicker {
  DatePicker();

  var selectedDate = DateTime.now();
  OnDateChange? onDateChange;
  var datePickerMode;

  show(BuildContext context,
      {minimumDate,
      maximumDate,
      onDateChange,
      onTimeChange,
      selectedDate,
      datePickerMode}) async {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return _buildMaterialDatePicker(context, onDateChange, onTimeChange,
            minimumDate, maximumDate, selectedDate, datePickerMode);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return _buildCupertinoDatePicker(context, onDateChange, minimumDate,
            maximumDate, selectedDate, datePickerMode);
    }
  }

  /// This builds material date picker in Android
  _buildMaterialDatePicker(
      BuildContext context,
      OnDateChange onDateChange,
      OnTimeChange onTimeChange,
      DateTime? minimumDate,
      DateTime? maximumDate,
      DateTime? selectedDate,
      var datePickerMode) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? this.selectedDate,
      firstDate: minimumDate ?? DateTime(2000),
      lastDate: maximumDate ?? DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child ?? Container(),
        );
      },
    );
    if (picked != null) {
      this.selectedDate = picked;
      if (datePickerMode == true) {
        onDateChange(picked);
        _buildTimePicker(context, onTimeChange);
      } else {
        onDateChange(picked);
      }
    }
  }

  _buildTimePicker(BuildContext context, OnTimeChange onTimeChange) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now()) ??
            TimeOfDay.now();
    onTimeChange(picked);
  }

  /// This builds cupertion date picker in iOS
  _buildCupertinoDatePicker(
      BuildContext context,
      OnDateChange onDateChange,
      DateTime? minimumDate,
      DateTime? maximumDate,
      DateTime? selectedDate,
      var datePickerMode) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          onDateChange(this.selectedDate);
                          Navigator.pop(context);
                        },
                        child: Text(Localize.done.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(Localize.cancel.tr),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: datePickerMode ?? CupertinoDatePickerMode.date,
                  onDateTimeChanged: (picked) {
                    this.selectedDate = picked;
                    onDateChange(picked);
                  },
                  initialDateTime: selectedDate ?? this.selectedDate,
                  minimumDate: minimumDate ?? DateTime(2000),
                  maximumDate: maximumDate ?? DateTime(2050),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
