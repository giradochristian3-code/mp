import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mp/pertemuan13/pages/login_page.dart';
import 'package:mp/pertemuan13/pages/maps_page.dart';
import 'package:mp/pertemuan13/pages/profile_page.dart';

enum Menu { item1, item2, item3 }

class Optioncontext extends StatefulWidget {
  Optioncontext({super.key});

  @override
  State<Optioncontext> createState() => _OptioncontextState();
}

class _OptioncontextState extends State<Optioncontext> {
  Menu? seletedMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar custom
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pertemuan 13",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PopupMenuButton<Menu>(
                      icon: const Icon(Icons.more_vert,
                          color: Colors.white),
                      initialValue: seletedMenu,
                      color: const Color(0xFF16213E),
                      onSelected: (Menu item) {},
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<Menu>>[
                        PopupMenuItem<Menu>(
                          value: Menu.item1,
                          child: const Row(
                            children: [
                              Icon(Icons.person,
                                  size: 20, color: Colors.white70),
                              SizedBox(width: 12),
                              Text("Profile",
                                  style:
                                      TextStyle(color: Colors.white70)),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfilePage()));
                          },
                        ),
                        PopupMenuItem<Menu>(
                          value: Menu.item3,
                          child: const Row(
                            children: [
                              Icon(Icons.logout,
                                  size: 20, color: Colors.red),
                              SizedBox(width: 12),
                              Text("Logout",
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Logout Success!")),
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
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Banner
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Selamat Datang! 👋",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Girado Christian",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.school,
                                        color: Colors.white70, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      "Sistem Informasi - Unpam",
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Menu Utama",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.1,
                          children: [
                            _buildContextCard(
                              context,
                              icon: Icons.map,
                              label: "Maps",
                              color: Colors.green,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapsPage()),
                              ),
                            ),
                            _buildContextCard(
                              context,
                              icon: Icons.person,
                              label: "Profile",
                              color: Colors.orange,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfilePage()),
                              ),
                            ),
                            _buildContextCard(
                              context,
                              icon: Icons.notifications,
                              label: "Notifikasi",
                              color: Colors.red,
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Tidak ada notifikasi baru")),
                                );
                              },
                            ),
                            _buildContextCard(
                              context,
                              icon: Icons.settings,
                              label: "Pengaturan",
                              color: Colors.blueGrey,
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Pengaturan belum tersedia")),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Info Card
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      color: Colors.purple[200]),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Info",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.purple[200],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Tekan lama pada kartu menu untuk melihat opsi tambahan seperti Copy, Share, dan Delete.",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContextCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CupertinoContextMenu(
      actions: <Widget>[
        CupertinoContextMenuAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
          child: const Text("Copy"),
        ),
        CupertinoContextMenuAction(
          onPressed: () => Navigator.pop(context),
          trailingIcon: CupertinoIcons.share,
          child: const Text("Share"),
        ),
        CupertinoContextMenuAction(
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: true,
          trailingIcon: CupertinoIcons.delete,
          child: const Text("Delete"),
        ),
      ],
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 36, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}