import 'package:flutter/material.dart';
import '../app.drawer.dart';

const Color mainGreen = Color(0xFF1ABC9C);
const Color darkText = Color(0xFF2C3E50);

class HomePage extends StatelessWidget {
  final bool isDark;
  final VoidCallback toggleTheme;

  const HomePage({
    super.key,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkText),
        title: const Text(
          'Awnak',
          style: TextStyle(
            color: mainGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: AppDrawer(
        isDark: isDark,
        toggleTheme: toggleTheme,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// ================= OLD CONTENT =================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),

                  const Text(
                    ': قال رسول الله',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: 'والله في عون العبد ما دام '),
                        TextSpan(
                          text: 'العبد ',
                          style: TextStyle(color: mainGreen),
                        ),
                        TextSpan(text: 'فى عون اخيه'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'Welcome to ',
                      style: TextStyle(
                        fontSize: 28,
                        color: darkText,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Awnak',
                          style: TextStyle(color: mainGreen),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Looking for services delivered by trusted professionals?\n'
                        'Request your service now and benefit from expertise ready '
                        'to meet your needs with top quality.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 150),
                ],
              ),
            ),

            /// ================= NEW SECTION (من نخدم) =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              color: isDark ? Colors.black : const Color(0xFFF8F9FA), // 👈 شبه اللي فوق
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    /// TITLE
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          text: "من ",
                          style: TextStyle(
                            color: darkText,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: "نخدم",
                              style: TextStyle(color: mainGreen),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// IMAGE (Full Width + Height أكبر)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        "images/1.png",
                        width: double.infinity,
                        height: 260, // 👈 زودنا الارتفاع
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// CARD (شكل أنضف)
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            // العملاء مع الخط تحتها
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "العملاء",
                                    style: TextStyle(
                                      color: mainGreen,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5), // 👈 المسافة بين الكلمة والخط
                                  Container(
                                    width: 40,
                                    height: 2,
                                    color: mainGreen,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              "الباحثون عن من يقومون بخدمتهم أو مساعدتهم أو حل مشاكلهم",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),

                            SizedBox(height: 25),

                            // المتطوعون مع الخط تحتها
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "المتطوعون",
                                    style: TextStyle(
                                      color: mainGreen,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5), // 👈 المسافة بين الكلمة والخط
                                  Container(
                                    width: 70,
                                    height: 2,
                                    color: mainGreen,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              "الأشخاص الذين يريدون استغلال أوقاتهم بطريقة صحيحة بالتعاون مع العملاء",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),


            /// ================= HOW IT WORKS =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              color: const Color(0xFF0F172A),
              child: Column(
                children: [

                  const Text(
                    "How It Works",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildStep(
                    number: "1",
                    icon: Icons.person,
                    title: "Choose your role",
                    desc: "Select whether you want to offer help or request a service.",
                    isLast: false,
                  ),

                  _buildStep(
                    number: "2",
                    icon: Icons.flash_on,
                    title: "Fast Response",
                    desc: "Get quick support from volunteers ready to assist you.",
                    isLast: false,
                  ),

                  _buildStep(
                    number: "3",
                    icon: Icons.sentiment_satisfied_alt,
                    title: "Enjoy",
                    desc: "Receive the help you need and enjoy a smooth experience.",
                    isLast: true,
                  ),
                ],
              ),
            ),


            /// ================= TESTIMONIALS =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              color: const Color(0xFF0F172A),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  /// TITLE
                  const Text(
                    "آراء عملائنا",
                    style: TextStyle(
                      color: mainGreen,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "اكتشف تجارب عملائنا السعداء",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// HORIZONTAL CARDS
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      children: [
                        _buildReviewCard("أحمد محمود", "خدمة رائعة أنصح بها بشدة"),
                        _buildReviewCard("سارة علي", "منتجات عالية الجودة وسعر ممتاز"),
                        _buildReviewCard("محمد حسن", "شحن سريع ودعم فني ممتاز"),
                        _buildReviewCard("فاطمة خالد", "تجربة رائعة، سأتعامل معهم مرة أخرى"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// STATS (CENTERED)
                  _buildStat("1000+", "مستخدم"),
                  _buildStat("4.9", "تقييم"),
                  _buildStat("99.9%", "رضا العملاء"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= STEP WIDGET =================
  Widget _buildStep({
    required String number,
    required IconData icon,
    required String title,
    required String desc,
    required bool isLast,
  }) {
    return Column(
      children: [

        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: mainGreen, width: 2),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: mainGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        if (!isLast)
          Container(
            width: 2,
            height: 40,
            color: Colors.white24,
          ),

        const SizedBox(height: 15),

        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 25),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(icon, color: mainGreen),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
Widget _buildReviewCard(String name, String text) {
  return Container(
    width: 250,
    margin: const EdgeInsets.only(right: 15),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: mainGreen,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        const Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 16),
            Icon(Icons.star, color: Colors.amber, size: 16),
            Icon(Icons.star, color: Colors.amber, size: 16),
            Icon(Icons.star, color: Colors.amber, size: 16),
            Icon(Icons.star, color: Colors.amber, size: 16),
          ],
        ),

        const SizedBox(height: 10),

        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

Widget _buildStat(String number, String label) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.symmetric(vertical: 25),
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: mainGreen,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    ),
  );
}
