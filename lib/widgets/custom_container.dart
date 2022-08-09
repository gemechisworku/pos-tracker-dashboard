// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  Function onPressed;

  CustomContainer({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 204, 214, 226),
        border: Border.all(
          color: Color.fromARGB(255, 204, 214, 226),
          width: 8,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              onPressed();
            },
            icon: Icon(
              icon,
              color: Colors.blue,
            ),
            iconSize: 80,
          ),
          Container(
            height: 25.0,
          ),
          Container(
            child: Text(
              title,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}
