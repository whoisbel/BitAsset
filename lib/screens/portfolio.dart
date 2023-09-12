import 'package:flutter/material.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 44, 45, 44),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Text("You are in Portfolio page"),
        ],
      )),
    );
  }
}
