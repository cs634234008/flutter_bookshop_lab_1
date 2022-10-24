import 'package:flutter/material.dart';
import 'package:flutter_bookshop_lab_1/screens/books/booklist_screen.dart';
import 'package:flutter_bookshop_lab_1/screens/about/about_screen.dart';

class TabMenu extends StatelessWidget {
  final int currentTabIndex;
  TabMenu({
    Key? key,
    required this.currentTabIndex,
  }) : super(key: key);

  final List<Widget> tabs = [
    const Center(
      child: BookListScreen(),
    ),
    const Center(
      child: Text("Order List"),
    ),
    const Center(
      child: AboutScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return tabs[currentTabIndex];
  }
}
