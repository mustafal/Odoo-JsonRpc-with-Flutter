import 'package:flutter/material.dart';
import 'package:odoo_common_code_latest/common/config/app_colors.dart';

class AppFont {
  AppFont._();

  static const Roboto_Black = 'RobotoBlack';
  static const Roboto_BlackItalic = 'RobotoBlackItalic';
  static const Roboto_Bold = 'RobotoBold';
  static const Roboto_BoldItalic = 'RobotoBoldItalic';
  static const Roboto_Italic = 'RobotoItalic';
  static const Roboto_Light = 'RobotoLight';
  static const Roboto_LightItalic = 'RobotoLightItalic';
  static const Roboto_Medium = 'RobotoMedium';
  static const Roboto_MediumItalic = 'RobotoMediumItalic';
  static const Roboto_Regular = 'RobotoRegular';
  static const Roboto_Thin = 'RobotoThin';
  static const Roboto_ThinItalic = 'RobotoThinItalic';

  static TextStyle Title_H2_Medium({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Medium,
      //fontStyle: FontStyle.normal,
      //fontWeight: FontWeight.w500,
      fontSize: size ?? 60,
    );
  }

  static TextStyle Title_H3_Medium({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Medium,
      //fontStyle: FontStyle.normal,
      //fontWeight: FontWeight.w500,
      fontSize: size ?? 48,
    );
  }

  static TextStyle Title_H4_Medium({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Medium,
      //fontStyle: FontStyle.normal,
      //fontWeight: FontWeight.w500,
      fontSize: size ?? 30,
    );
  }

  static TextStyle Title_H4_Regular({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Light,
      //fontStyle: FontStyle.normal,
      //fontWeight: FontWeight.w500,
      fontSize: size ?? 30,
    );
  }

  static TextStyle Title_H5_Medium({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Medium,
      //fontStyle: FontStyle.normal,
      //fontWeight: FontWeight.w500,
      fontSize: size ?? 24,
    );
  }

  static TextStyle Title_H6_Medium({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Medium,
      //fontStyle: FontStyle.normal,
      //fontWeight: FontWeight.w500,
      fontSize: size ?? 20,
    );
  }

  static TextStyle SubTitle1_Medium({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Medium,
      //fontStyle: FontStyle.normal,
      //fontWeight: FontWeight.w500,
      fontSize: size ?? 17,
    );
  }

  static TextStyle SubTitle2_Medium({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Medium,
      //fontStyle: FontStyle.normal,
      //fontWeight: FontWeight.w500,
      fontSize: size ?? 15,
    );
  }

  static TextStyle Body1_Regular({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Regular,
      //fontStyle: FontStyle.normal,
      //fontWeight: FontWeight.normal,
      fontSize: size ?? 17,
    );
  }

  static TextStyle Body2_Regular({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Regular,
      // fontStyle: FontStyle.normal,
      // fontWeight: FontWeight.normal,
      fontSize: size ?? 15,
    );
  }

  static TextStyle Caption1_Body({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Regular,
      //fontStyle: FontStyle.normal,
      //fontWeight: FontWeight.normal,
      fontSize: size ?? 13,
    );
  }

  static TextStyle Caption2_Title({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Medium,
      //fontStyle: FontStyle.normal,
      //fontWeight: FontWeight.normal,
      fontSize: size ?? 12,
    );
  }

  static TextStyle Caption2_Body({Color? color, double? size}) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontFamily: Roboto_Regular,
      //fontStyle: FontStyle.normal,
      //fontWeight: FontWeight.normal,
      fontSize: size ?? 12,
    );
  }
}
