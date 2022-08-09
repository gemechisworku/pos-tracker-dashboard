// ignore_for_file: no_logic_in_create_state, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_element

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos_tracker/admin_pages/branch_admin.dart';
import 'package:pos_tracker/admin_pages/district_admin.dart';
import 'package:pos_tracker/admin_pages/head_office_admin.dart';
import 'package:pos_tracker/model/user.dart';
import 'package:pos_tracker/views/landing_page.dart';

class FilterAccess extends StatefulWidget {
  final MyUser myUser;
  const FilterAccess({Key? key, required this.myUser}) : super(key: key);

  @override
  State<FilterAccess> createState() => _FilterAccessState(myUser);
}

class _FilterAccessState extends State<FilterAccess> with TickerProviderStateMixin{
  final MyUser myUser;
  late AnimationController controller;

  _FilterAccessState(this.myUser);

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    _filterAccess();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Please wait while loading....',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(height: 30.0,),
            CircularProgressIndicator(
              value: controller.value,
              semanticsLabel: 'Loading...',
            ),
          ],
        ),
      ),
    );
  }

  _filterAccess() async {
    if (myUser.userType == 'Head office') {
      _headOfficeUser();
    } else if (myUser.userType == 'District') {
      _districtUser();
    } else if (myUser.userType == 'Branch') {
      _branchUser();
    } else {
      _guestUser();
    }
  }

  _headOfficeUser() {
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MyTracker(myUser: myUser)));
    });
  }

  _districtUser() {
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DistrictAdminView(myUser: myUser)));
    });
  }

  _branchUser() {
     Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BranchAdminView(myUser: myUser)));
    });
  }

  _guestUser() {}
}
