import 'dart:async';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:android/pages/customer/customer_online.dart';
import 'package:android/pages/customer/customer_offline.dart';
class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final List<String> messages = [
    "Customer",
    "Start… Your Time Deserves Real Support.",
    "Start… Your Time Deserves Real Support",
    "Someone Can Help You Right Where You Are ",
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    startTextLoop();
  }

  void startTextLoop() {
    Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % messages.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white, // ✅ خلفية بيضا
      body: Column(
        children: [
          const SizedBox(height: 120), // ✅ مسافة من فوق

          /// 🔹 الصورة الكبيرة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                /// الصورة
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    "images/chomemain.jpg",
                    height: 350, // ✅ أكبر
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                /// overlay أخضر
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),

                /// النص المتغير
                Positioned.fill(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        transitionBuilder: (child, animation) {
                          final slideAnimation = Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(animation);

                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: slideAnimation,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          messages[currentIndex],
                          key: ValueKey(currentIndex),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// 🔹 الكارتات
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                /// Offline
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerOfffline(),
                        ),
                      );
                    },
                    child: buildCard(
                      image: "images/vofflinemain.jpg",
                      title: "Offline",
                      subtitle: "(On-site Services)",
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                /// Online
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerOnline(),
                        ),
                      );
                    },
                    child: buildCard(
                      image: "images/vonlinemain.jpg",
                      title: "Online",
                      subtitle: "(Digital / Technology Services)",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          /// الصورة
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            child: Image.asset(
              image,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// النص
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}