// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class EditUSer extends StatefulWidget {
  const EditUSer({Key? key}) : super(key: key);

  @override
  State<EditUSer> createState() => _EditUSerState();
}

class _EditUSerState extends State<EditUSer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Center(
        child:Text('Edit user here'),
      ),
    );
  }
}
