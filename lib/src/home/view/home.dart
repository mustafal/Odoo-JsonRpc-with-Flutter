import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odoo_common_code_latest/common/config/app_colors.dart';
import 'package:odoo_common_code_latest/common/utils/utils.dart';
import 'package:odoo_common_code_latest/common/widgets/log.dart';
import 'package:odoo_common_code_latest/common/widgets/main_container.dart';
import 'package:odoo_common_code_latest/src/home/controller/home_controller.dart';

class Home extends StatelessWidget {
  final _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      isAppBar: true,
      appBarTitle: "Home",
      padding: 20.0,
      child: Obx(
        () {
          return ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: _homeController.listOfPartners.length,
            itemBuilder: (context, index) {
              // String imageUrl = getImageUrl(
              //     model: "res.partner",
              //     field: "image_512",
              //     id: _homeController.listOfPartners[index].id.toString());
              // Log(imageUrl);
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: _homeController
                          .listOfPartners[index].image512!.isNotEmpty
                      ? Image.memory(
                          base64.decode(
                              _homeController.listOfPartners[index].image512!),
                          height: 40,
                          width: 40,
                        )
                      : Icon(
                          Icons.person,
                          color: AppColors.grey,
                          size: 40,
                        ),
                ),
                title: Text(_homeController.listOfPartners[index].name!),
                subtitle: Text(_homeController.listOfPartners[index].email!),
              );
            },
          );
        },
      ),
    );
  }
}
