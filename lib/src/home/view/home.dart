import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              return ListTile(
                // leading: CircleAvatar(
                //   child: CachedNetworkImage(
                //     imageUrl: '',
                //
                //   ),
                // ),
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
