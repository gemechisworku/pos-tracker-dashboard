// ignore_for_file: no_logic_in_create_state, avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pos_tracker/model/user.dart';
import 'package:pos_tracker/views/filter_access.dart';

class UserRouter extends StatefulWidget {
  final User thisUser;
  const UserRouter({Key? key, required this.thisUser}) : super(key: key);

  @override
  State<UserRouter> createState() => _UserRouterState(thisUser);
}

class _UserRouterState extends State<UserRouter> with TickerProviderStateMixin {
  final User thisUser;
  MyUser? _myUser;
  late AnimationController controller;

  _UserRouterState(this.thisUser);

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    _getUser().whenComplete(() async {
      print(_myUser!.username);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FilterAccess(
                myUser: _myUser!,
              )));
    });
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

  Future<MyUser> _getUser() async {
    final theUSer = FirebaseFirestore.instance
        .collection('users')
        .doc(thisUser.uid)
        .withConverter(
            fromFirestore: MyUser.fromFirestore,
            toFirestore: (MyUser user, _) => user.toFirestore());

    final docSnapshot = await theUSer.get();
    final myUser = docSnapshot.data()!;
    setState(() {
      _myUser = myUser;
    });

    return myUser;
  }
}
