import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odoo_common_code_latest/common/api_factory/models/base_list.dart';
import 'package:odoo_common_code_latest/common/api_factory/modules/authentication_module.dart';
import 'package:odoo_common_code_latest/common/config/app_colors.dart';
import 'package:odoo_common_code_latest/common/config/app_fonts.dart';
import 'package:odoo_common_code_latest/common/config/app_images.dart';
import 'package:odoo_common_code_latest/common/config/config.dart';
import 'package:odoo_common_code_latest/common/config/localization/localize.dart';
import 'package:odoo_common_code_latest/common/config/prefs/pref_utils.dart';
import 'package:odoo_common_code_latest/common/widgets/log.dart';

Future<void> ackAlert(
  BuildContext context,
  String title,
  String content,
  VoidCallback onPressed,
) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        titleTextStyle: TextStyle(
          fontFamily: AppFont.Roboto_Regular,
          fontSize: 21,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        content: Text(content),
        contentTextStyle: TextStyle(
          fontFamily: AppFont.Roboto_Regular,
          fontSize: 17,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              Localize.done.tr,
              style: TextStyle(
                fontFamily: AppFont.Roboto_Regular,
                fontSize: 17,
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onPressed,
          ),
        ],
      );
    },
  );
}

showLoading() {
  Get.dialog(
    Center(
      child: SizedBox(
        child: FittedBox(child: CircularProgressIndicator()),
        height: 50.0,
        width: 50.0,
      ),
    ),
    barrierDismissible: false,
  );
}

hideLoading() {
  Get.back();
}

void showSnackBar(
    {title,
    message,
    SnackPosition? snackPosition,
    Color? backgroundColor,
    Duration? duration}) {
  Get.showSnackbar(
    GetBar(
      title: title,
      message: message,
      duration: duration ?? Duration(seconds: 2),
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      backgroundColor: backgroundColor ?? Colors.black87,
    ),
  );
}

handleApiError(errorMessage) {
  showSnackBar(backgroundColor: Colors.redAccent, message: errorMessage);
}

showWarning(message) {
  showSnackBar(backgroundColor: Colors.blueAccent, message: message);
}

bool validatePassword(String password) {
  return RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~?]).{8,}$')
      .hasMatch(password);
}

bool validateEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

bool validURL(String url) {
  return Uri.parse(url).isAbsolute;
}

typedef OnItemsSelected(BaseListModel data);
typedef OnMultiItemSelected(List<BaseListModel> data);
typedef OnFilterSelected(String salary);

//MARK - Open single select bottomsheet -
//-----------------------------------
showCustomBottomSheet({
  @required List<BaseListModel>? list,
  @required String? title,
  @required OnItemsSelected? onItemsSelected,
  bool isMultiSelect = false,
}) {
  Get.bottomSheet(
    BottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.0),
          topLeft: Radius.circular(30.0),
        ),
      ),
      onClosing: () {
        Log("on Close bottom sheet");
      },
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                color: AppColors.greyDotColor,
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Image.asset(AppImages.ic_back),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    title ?? "",
                    style: AppFont.Title_H6_Medium(),
                  ),
                  isMultiSelect
                      ? Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 41,
                              width: 75,
                              child: MaterialButton(
                                elevation: 0.0,
                                color: AppColors.blueButtonColor,
                                onPressed: () {
                                  var isSelectedItems =
                                      list!.where((e) => e.isSelected).toList();
                                  if (isSelectedItems.length == 0) {
                                    // showWarning(Localize.selectAnyItem.tr);
                                  } else {
                                    Get.back(result: isSelectedItems);
                                  }
                                },
                                child: Text(
                                  Localize.done.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 17,
                                  ),
                                ),
                                textColor: AppColors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2 - 170,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: list!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 50,
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                list[index].name!,
                                style: AppFont.Body1_Regular(),
                              ),
                              list[index].isSelected
                                  ? Icon(Icons.done)
                                  : SizedBox()
                            ],
                          ),
                          onTap: () {
                            if (isMultiSelect) {
                              list[index].isSelected = !list[index].isSelected;
                            } else {
                              list[index].isSelected = !list[index].isSelected;
                              Get.back(result: list[index]);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    ),
  ).then((value) {
    FocusManager.instance.primaryFocus!.unfocus();
    onItemsSelected!(value);
    Log(value);
  });
}

showSessionDialog() {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Text(
        "Session Time out",
        style: AppFont.Title_H4_Medium(),
      ),
      content: Text(
        "Sorry! your session is expired, Please login again",
        style: AppFont.Body2_Regular(),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            PrefUtils.clearPrefs();
          },
          child: Text(
            Localize.signin.tr,
            style: AppFont.Body2_Regular(),
          ),
        ),
      ],
    ),
  );
}

showLogoutDialog() {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Text(
        "Logout",
        style: AppFont.Title_H4_Medium(),
      ),
      content: Text(
        "Are you sure you want to logout?",
        style: AppFont.Body2_Regular(),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Get.back();
          },
          child: Text(
            Localize.cancel.tr,
            style: AppFont.Body2_Regular(),
          ),
        ),
        TextButton(
          onPressed: () async {
            Get.back();
            logoutApi();
          },
          child: Text(
            "Logout",
            style: AppFont.Body2_Regular(),
          ),
        ),
      ],
    ),
  );
}

Future<String> getImageUrl(
    {required String model, required String field, required String id}) async {
  String session = await PrefUtils.getToken();
  return Config.OdooDevURL +
      "/web/image?model=$model&field=$field&$session&id=$id";
}
