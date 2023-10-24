import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Plugin/p_string.dart';
import 'package:data_to_json/Plugin/p_theme.dart';
import 'package:data_to_json/View/v_chang_an/v_building/v_add_building.dart';
import 'package:data_to_json/View/v_chang_an/v_building/v_detail_building.dart';
import 'package:data_to_json/View/v_chang_an/v_building/v_edit_building.dart';
import 'package:data_to_json/View/v_chang_an/v_detail_fang.dart';
import 'package:data_to_json/View/v_chang_an/v_event/v_add_event.dart';
import 'package:data_to_json/View/v_chang_an/v_event/v_detail_event.dart';
import 'package:data_to_json/View/v_chang_an/v_event/v_edit_event.dart';
import 'package:data_to_json/View/v_chang_an/v_family/v_add_family.dart';
import 'package:data_to_json/View/v_chang_an/v_family/v_detail_family.dart';
import 'package:data_to_json/View/v_chang_an/v_family/v_edit_family.dart';
import 'package:data_to_json/View/v_chang_an/v_family_role/v_add_family_role.dart';
import 'package:data_to_json/View/v_chang_an/v_people/v_add_people.dart';
import 'package:data_to_json/View/v_chang_an/v_people/v_detail_people.dart';
import 'package:data_to_json/View/v_chang_an/v_people/v_edit_people.dart';
import 'package:data_to_json/View/v_chang_an/v_profession/v_add_profession.dart';
import 'package:data_to_json/View/v_chang_an/v_profession_type/v_add_profession_type.dart';
import 'package:data_to_json/View/v_chang_an/v_prop/v_add-prop.dart';
import 'package:data_to_json/View/v_chang_an/v_prop/v_detail_prop.dart';
import 'package:data_to_json/View/v_chang_an/v_prop/v_edit_prop.dart';
import 'package:data_to_json/View/v_chang_an/v_prop/v_prop_list.dart';
import 'package:data_to_json/View/v_chang_an/v_prop_type/v_add_prop_type.dart';
import 'package:data_to_json/View/v_first.dart';
import 'package:data_to_json/View/v_home.dart';
import 'package:data_to_json/View/Setting/v_setting.dart';
import 'package:data_to_json/binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Data to Json',
      debugShowCheckedModeBanner: false,
      enableLog: true,
      initialBinding: CRootBinding(),
      initialRoute: PS.firstV,
      getPages: _getPages(),
      theme: PT.themeData,
      onInit: (){
        printInfo(info: "onInit-------");
        },
      onReady: (){
        printInfo(info: "onReady-------");
        },
      onDispose: (){
        printInfo(info: "onDispose");
        },
      routingCallback: (Routing? routing){
        if(routing?.current == PS.home){
          //Get.find<CRoot>().updateNowFangIndex(PS.home);
        }

      },
    );
  }

  List<GetPage> _getPages(){

    final List<GetPage> _pageList = [
      GetPage(name: PS.firstV, page: () => VFirst(key: key,)),

      GetPage(name: PS.home, page: () => VHome(key: key,)),

      GetPage(name: PS.setting, page: () => VSetting(key: key,)),

      GetPage(name: PS.addFamilyRole, page: () => VAddFamilyRole(key: key,)),

      GetPage(name: PS.addPropType, page: () => VAddPropType(key: key,)),

      GetPage(name: PS.propList, page: () => VPropList(key: key,)),

      GetPage(name: PS.addProp, page: () => VAddProp(key: key,)),

      GetPage(name: PS.detailProp, page: () => VDetailProp(key: key,)),

      GetPage(name: PS.editProp, page: () => VEditProp(key: key,)),

      GetPage(name: PS.addProfession, page: () => VAddProfession(key: key,)),

      GetPage(name: PS.addProfessionType, page: () => VAddProfessionType(key: key,)),

      GetPage(name: PS.detailFang, page: () => VDetailFang(key: key,)),

      GetPage(name: PS.addFamily, page: () => VAddFamily(key: key,)),

      GetPage(name: PS.detailFamily, page: () => VDetailFamily(key: key,)),

      GetPage(name: PS.editFamily, page: () => VEditFamily(key: key,)),

      GetPage(name: PS.addEvent, page: () => VAddEvent(key: key,)),

      GetPage(name: PS.detailEvent, page: () => VDetailEvent(key: key,)),

      GetPage(name: PS.editEvent, page: () => VEditEvent(key: key,)),

      GetPage(name: PS.addBuilding, page: () => VAddBuilding(key: key,)),

      GetPage(name: PS.detailBuilding, page: () => VDetailBuilding(key: key,)),

      GetPage(name: PS.editBuilding, page: () => VEditBuilding(key: key,)),

      GetPage(name: PS.addPeople, page: () => VAddPeople(key: key,)),

      GetPage(name: PS.detailPeople, page: () => VDetailPeople(key: key,)),

      GetPage(name: PS.editPeople, page: () => VEditPeople(key: key,)),
    ];
    return _pageList;
  }
}
