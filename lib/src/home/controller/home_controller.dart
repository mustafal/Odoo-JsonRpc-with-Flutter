import 'package:get/get.dart';
import 'package:odoo_common_code_latest/common/api_factory/modules/home_api_module.dart';
import 'package:odoo_common_code_latest/common/utils/utils.dart';
import 'package:odoo_common_code_latest/src/home/model/res_partner_model.dart';

class HomeController extends GetxController {
  var listOfPartners = <Records>[].obs;

  getPartners() {
    resPartnerApi(
      onResponse: (response) {
        listOfPartners.assignAll(response.records!);
      },
    );
  }
}
