import 'dart:io';

import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_building.dart';
import 'package:data_to_json/Model/m_event.dart';
import 'package:data_to_json/Model/m_family.dart';
import 'package:data_to_json/Model/m_fang.dart';
import 'package:data_to_json/Model/m_people.dart';
import 'package:data_to_json/Plugin/p_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VCommonFang extends StatelessWidget {
  final MFang? mFang;
  final Function(int, List<MPeople>)? peopleListOnTap;
  final Function(int, List<MPeople>)? peopleListOnLongTap;

  final Function(int, List<MFamily>)? familyListOnTap;
  final Function(int, List<MFamily>)? familyListOnLongTap;

  final Function(int, List<MEvent>)? eventListOnTap;
  final Function(int, List<MEvent>)? eventListOnLongTap;

  final Function(int, List<MBuilding>)? buildingListOnTap;
  final Function(int, List<MBuilding>)? buildingListOnLongTap;

  final bool floatActionButton;
  final List newTypes;

  VCommonFang({
    Key? key,
    required this.newTypes,
    required this.floatActionButton,
    required this.mFang,

    this.peopleListOnTap,
    this.peopleListOnLongTap,

    this.eventListOnTap,
    this.eventListOnLongTap,

    this.familyListOnTap,
    this.familyListOnLongTap,

    this.buildingListOnTap,
    this.buildingListOnLongTap,
  }) : super(key: key);

  final cRoot = Get.find<CRoot>();

  final List types = const ["People", "Family", "Event", "Building"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: newTypes.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(mFang?.fangName ?? ''),
          bottom: TabBar(
            tabs: newTypes.map((e) {
              return Tab(
                text: e,
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: newTypes.map<Widget>((e) {
            return _getListView(e);
          }).toList(),
        ),
      ),
    );
  }

  _getListView(String type) {
    if (type == types[0]) {
      return _peopleListView(mFang?.mPeopleList.mPeopleList ?? []);
    } else if (type == types[1]) {
      return _familyListView(mFang?.families.mFamilyList ?? []);
    } else if (type == types[2]) {
      return _eventListView(mFang?.events.mEventList ?? []);
    } else if (type == types[3]) {
      return _buildingListView(mFang?.buildings.mBuildingList ?? []);
    }
  }

  _myFloatingActionButton(VoidCallback onPressed) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: onPressed,
    );
  }

  _peopleListView(List<MPeople> data) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: SizedBox(
              width: Get.width*0.1,
              height: Get.width*0.1,
              child: data[index].images.isEmpty
                  ?const Icon(Icons.photo)
                  :Hero(tag: data[index].images[0].hashCode,
                child: Image.file(File(data[index].images[0]),fit: BoxFit.cover,),
              ),
            ),
            title: Text(data[index].nameList[0].lastName + ' ' +
                data[index].nameList[0].firstName),
            onTap: () {
              peopleListOnTap!(index, data);
            },
            onLongPress: () {
              peopleListOnLongTap!(index, data);
            },
          );
        },
      ),
      floatingActionButton: floatActionButton ? _myFloatingActionButton(() {
        _checkTypeEmpty(PS.addPeople);
      }) : Container(),
    );
  }

  _familyListView(List<MFamily> data) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: SizedBox(
              width: Get.width*0.1,
              height: Get.width*0.1,
              child: data[index].images.isEmpty
                  ?const Icon(Icons.photo)
                  :Hero(tag: data[index].images[0].hashCode,
                child: Image.file(File(data[index].images[0]),fit: BoxFit.cover,),
              ),
            ),
            title: Text(data[index].familyName),
            onTap: () {familyListOnTap!(index, data);},
            onLongPress: () {familyListOnLongTap!(index, data);},
          );
        },
      ),
      floatingActionButton: floatActionButton ? _myFloatingActionButton(() {
        _checkTypeEmpty(PS.addFamily);
      }) : Container(),
    );
  }

  _eventListView(List<MEvent> data) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: SizedBox(
              width: Get.width*0.1,
              height: Get.width*0.1,
              child: data[index].images.isEmpty
                  ?const Icon(Icons.photo)
                  :Hero(tag: data[index].images[0].hashCode,
                child: Image.file(File(data[index].images[0]),fit: BoxFit.cover,),
              ),
            ),
            title: Text(data[index].title),
            onTap: () {
              eventListOnTap!(index, data);
            },
            onLongPress: () {
              eventListOnLongTap!(index,data);
            },
          );
        },
      ),
      floatingActionButton: floatActionButton ? _myFloatingActionButton(() {
        _checkTypeEmpty(PS.addEvent);
      }) : Container(),
    );
  }

  _buildingListView(List<MBuilding> data) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: SizedBox(
              width: Get.width*0.1,
              height: Get.width*0.1,
              child: data[index].images.isEmpty
                  ?const Icon(Icons.photo)
                  :Hero(tag: data[index].images[0].hashCode,
                child: Image.file(File(data[index].images[0]),fit: BoxFit.cover,),
              ),
            ),
            title: Text(data[index].name),
            onTap: () {
              buildingListOnTap!(index, data);
            },
            onLongPress: () {
              buildingListOnLongTap!(index, data);
            },
          );
        },
      ),
      floatingActionButton: floatActionButton ? _myFloatingActionButton(() {
        _checkTypeEmpty(PS.addBuilding);
      }) : Container(),
    );
  }

  _checkTypeEmpty(String page) {
    if (cRoot.mProfessionList.value.mProfessionList.isEmpty ||
        cRoot.mFamilyRoleList.value.mFamilyRoleList.isEmpty) {
      Get.defaultDialog(title: 'Warning', content: const Text('关系，职业，种类不可以为空'));
    } else {
      Get.toNamed(page);
    }
  }
}
