import 'package:flutter/material.dart';
import 'pages/profile pages/profile_screen.dart';
import 'pages/about us.dart';     // صفحة About Us
import 'pages/contact us.dart';   // صفحة Contact Us
import 'pages/settings.dart';
import 'pages/volunteer/volunteer_page.dart';
import 'pages/customer/customer_page.dart';
const Color mainGreen = Color(0xFF1ABC9C);

class AppDrawer extends StatelessWidget {
  final bool isDark;
  final VoidCallback toggleTheme;

  const AppDrawer({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: mainGreen),
            child: const Text(
              'Awnak',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // أيقونة البروفايل
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'), // ضع صورة البروفايل هنا
              radius: 16,
            ),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context); // يقفل الـ Drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),

          // أيقونة الوقت مع نص 120 min
          ListTile(
            leading: const Icon(Icons.access_time, color: mainGreen),
            title: const Text('120 min'),
            onTap: () {},
          ),

          // أيقونة الإعدادات
          ListTile(
            leading: const Icon(Icons.settings, color: mainGreen),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // يقفل الـ Drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    isDark: isDark,            // لازم تجيب isDark من الـ MyApp
                    onThemeToggle: toggleTheme, // نفس الفانكشن
                  ),
                ),
              );
            },
          ),


          const Divider(), // خط فاصل قبل بقية العناصر

          // باقي عناصر القائمة مع Navigation
          _drawerItem(
            context,
            Icons.home,
            'Home',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          _drawerItem(
            context,
            Icons.info,
            'About Us',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutUs(),
                ),
              );
            },
          ),
          _drawerItem(
            context,
            Icons.volunteer_activism,
            'Volunteer',
            onTap: () { Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const VolunteerPage(),
              ),
             );
            },
           ),
          _drawerItem(
            context,
            Icons.person,
            'Customer',
            onTap: () { Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CustomerPage(),
              ),
             );
            },
           ),
          _drawerItem(
            context,
            Icons.contact_mail,
            'Contact Us',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ContactUsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ListTile _drawerItem(BuildContext context, IconData icon, String title,
      {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: mainGreen),
      title: Text(title),
      onTap: onTap,
    );
  }
}


