import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:mp/pertemuan7/pages/radiobutton_page.dart';
import 'package:mp/pertemuan7/pages/profile_page.dart';


void main() {
  runApp(const MyApp1());
}

class MyApp1 extends StatefulWidget {
  const MyApp1({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  final List<Widget> _page = const [ProfilePage(), RadiobuttonPage()];

  var currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: _page[currentPage],
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: currentPage,
          onTap: (i) => setState(() => currentPage = i),
          items: [
            /// Profile
            SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
              selectedColor: Colors.blue,
            ),

            /// Radio Button
            SalomonBottomBarItem(
              icon: const Icon(Icons.radio_button_checked),
              title: const Text("Radio Button"),
              selectedColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}