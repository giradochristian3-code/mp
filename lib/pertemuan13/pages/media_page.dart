import 'package:flutter/material.dart';
import 'package:mp/pertemuan13/component/musicplayer.dart';
import 'package:mp/pertemuan13/component/videoplayer.dart';
import 'package:mp/pertemuan13/pages/login_page.dart';
import 'package:mp/pertemuan13/pages/profile_page.dart';

enum Menu { item1, item2 }

class MediaPage extends StatefulWidget {
  MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  Menu? seletedMenu;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF1A1A2E),
          elevation: 0,
          title: const Text(
            "Pertemuan 13",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            PopupMenuButton<Menu>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: const Color(0xFF16213E),
              initialValue: seletedMenu,
              onSelected: (Menu item) {},
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                PopupMenuItem<Menu>(
                  value: Menu.item1,
                  child: const Row(
                    children: [
                      Icon(Icons.person, size: 20, color: Colors.white70),
                      SizedBox(width: 12),
                      Text("Profile",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage()));
                  },
                ),
                PopupMenuItem<Menu>(
                  value: Menu.item2,
                  child: const Row(
                    children: [
                      Icon(Icons.logout, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text("Logout",
                          style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Logout Success!")),
                    );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage()));
                  },
                ),
              ],
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.purple,
            indicatorWeight: 3,
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.white54,
            tabs: const [
              Tab(icon: Icon(Icons.headphones), text: "Audio"),
              Tab(icon: Icon(Icons.movie), text: "Video"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MusicPlayerPage(),
            VideoPlayerPage(),
          ],
        ),
      ),
    );
  }
}