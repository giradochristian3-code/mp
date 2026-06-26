import 'package:flutter/material.dart';
import 'package:mp/pertemuan13/pages/maps_page.dart';
import 'package:mp/pertemuan13/pages/media_page.dart';
import 'package:mp/pertemuan13/pages/optioncontext_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _page = [Optioncontext(), MediaPage(), MapsPage()];

  var curentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[curentPage],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: curentPage,
        onTap: (i) => setState(() => curentPage = i),
        items: [
          // Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.red,
          ),
          // Media
          SalomonBottomBarItem(
            icon: const Icon(Icons.smart_display),
            title: const Text("Media"),
            selectedColor: Colors.blueAccent,
          ),
          // Maps
          SalomonBottomBarItem(
            icon: const Icon(Icons.map),
            title: const Text("Maps"),
            selectedColor: Colors.green,
          ),
        ],
      ),
    );
  }
}