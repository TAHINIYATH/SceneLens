import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:majorproscenelens/screens/homepage.dart';
import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';

import 'package:majorproscenelens/screens/splashscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = const [
    Icon(
      Icons.search_off_rounded,
      color: Colors.black,
      size: 40,
    ),
    Icon(
      Icons.list_alt_rounded,
      color: Colors.black,
      size: 40,
    ),
    Icon(
      Icons.analytics_rounded,
      color: Colors.black,
      size: 40,
    ),
  ];

  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromARGB(236, 1, 71, 84),

        items: [
          CurvedNavigationBarItem(
              icon: Icon(Icons.scatter_plot, size: 30), label: "Classify"),
          CurvedNavigationBarItem(
              icon: Icon(Icons.search_outlined, size: 30), label: "Detection"),
          CurvedNavigationBarItem(
              icon: Icon(Icons.list_sharp, size: 30), label: "List"),
          CurvedNavigationBarItem(
              icon: Icon(Icons.timeline_outlined, size: 30),
              label: "Prediction"),
        ],
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },

        // body: Container(color: Colors.blueAccent),

        // bottomNavigationBar: CurvedNavigationBar(
        //   color: Colors.white,

        //   items: items,
        //   index: index,
        //   onTap: (selectedIndex) {
        //     setState(() {
        //       index = selectedIndex;
        //     });
        //   },
        height: 60.0,
        animationDuration: const Duration(milliseconds: 200),
        // animationCurve: ,
      ),
      body: Container(
        color: Colors.blueAccent,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        // decoration: const BoxDecoration(
        //   color: Colors.transparent,
        // ),
        child: getSelectedWidget(index: index),
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = const MyHomePage();
        break;
      case 1:
        widget = const MyHomePage();
        break;
      case 2:
        widget = const MyHomePage();
        break;

      default:
        widget = const Splashscreen();
        break;
    }
    return widget;
  }
}
