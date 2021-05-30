import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension MyString on String {
  String get first => this[0];

  String get last => this[this.length - 1];

  String get capitalize => "${this[0].toUpperCase()}${this.substring(1)}";

  String get trimMobile => this.replaceAll(" ", "");

  String get setDefaultVal =>
      (this.trim() == "") ? "..." : this;

  String get setPerc => this.trim() == "" ? "" : '$this%';

  String get setNAVal => this.trim() == "" ? "N/A" : this;

  bool get isNullOrEmpty => (this.trim() == "") ? true : false;

  String get setChatId => (this.trim() == "") ? this : 'c$this';

  int? get toInt => this.trim() == "" ? null : int.parse(this);

  Image image({color: Color}) {
    return Image.asset(
      this,
      color: color,
    );
  }

  CachedNetworkImage cachedImage(
          {double? height, double? width, BoxFit? fit, String? placeholder}) =>
      CachedNetworkImage(
        fit: fit ?? BoxFit.fill,
        height: height ?? 20.0,
        width: width ?? 20.0,
        imageUrl: this,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => placeholder != null
            ? Image.asset(placeholder, fit: BoxFit.fill)
            : Icon(Icons.error),
      );

  String setKVal() {
    return '$this k';
  }

  String withCompany(String company) {
    if (!this.isNullOrEmpty && !company.isNullOrEmpty) {
      return this + ' at ' + company;
    } else if (!this.isNullOrEmpty) {
      return this;
    } else if (!company.isNullOrEmpty) {
      return company;
    } else {
      return this.setDefaultVal;
    }
  }
}

extension MyInt on int {
  bool get boolType => this == 0 ? false : true;

  String get setDigit => NumberFormat.compactCurrency(
        decimalDigits: 0,
        symbol:
            '', // if you want to add currency symbol then pass that in this else leave it empty.
      ).format(this ?? 0);

  String get setMonths => (this != null)
      ? this.toString() + ' months'
      : this.toString().setDefaultVal;

  String setFormatted(int val) {
    return NumberFormat.currency(symbol: "", decimalDigits: 0).format(val);
  }

  String setKVal() {
    var val = this ?? 0;
    return '$val\k';
  }

  String setPayscale() {
    var val = this ?? 0;
    return '${setFormatted(this)}/pm';
  }
}

extension MyDateTime on DateTime {
  String get getAgeInYears {
    int ageInteger = 0;

    if (this != null) {
      DateTime today = DateTime.now();
      today = DateTime(today.year, today.month, today.day);
      DateTime dob = DateTime(this.year, this.month, this.day);

      ageInteger = today.year - dob.year;

      if (today.month == dob.month) {
        if (today.day < dob.day) {
          ageInteger = ageInteger - 1;
        }
      } else if (today.month < dob.month) {
        ageInteger = ageInteger - 1;
      }
    }
    return ageInteger.toString() + ' yr';
  }
}
