import 'package:flutter/material.dart';

const Color mainGreen = Color(0xFF1ABC9C);

//////////////////////////////////////////////////////////////////////////////
// ABOUT US SCREEN
//////////////////////////////////////////////////////////////////////////////

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // خلفية الشاشة كلها بيضاء
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: mainGreen),
        title: const Text("Time Banking", style: TextStyle(color: mainGreen)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            AboutUsHeader(),
            BigSection(),
            TeamSection(),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
// HEADER SECTION
//////////////////////////////////////////////////////////////////////////////

class AboutUsHeader extends StatelessWidget {
  const AboutUsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      color: mainGreen,
      child: Column(
        children: const [
          Text(
            "About Us",
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14),
          Text(
            "Connecting people through time and skills",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
// BIG SECTION
//////////////////////////////////////////////////////////////////////////////

class BigSection extends StatelessWidget {
  const BigSection({super.key});

  Widget card(String title, String text, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18),
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 34, color: mainGreen),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Text(
            text,
            style: const TextStyle(fontSize: 17, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          card(
            "Our Story",
            "We believe time is the most valuable thing we own. Every moment spent with others is an opportunity to build relationships, share knowledge, and contribute to our communities.",
            Icons.flash_on,
          ),
          card(
            "Our Mission",
            "Empowering communities through shared services. We aim to create a network where people can exchange skills and time to help each other, fostering collaboration and trust.",
            Icons.check_circle_outline,
          ),
          card(
            "Our Vision",
            "A world where time is currency. We envision a society where every individual can exchange skills and time to help one another, fostering collaboration, trust, and mutual growth.",
            Icons.visibility,
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
// TEAM SECTION
//////////////////////////////////////////////////////////////////////////////

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  final List<String> names = const [
    "Asmaa Sahloul",
    "Ghazal Alaktaa",
    "Arwa Elmashad",
    "Mohamed Ayman",
    "Ammar El-Deeb",
    "Mohamed Yasser",
    "Hany",
    "Youssef",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Our Team",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: names.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 18,
              crossAxisSpacing: 18,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (_, i) => TeamCard(names[i]),
          ),
        ],
      ),
    );
  }
}

class TeamCard extends StatelessWidget {
  final String name;
  const TeamCard(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: mainGreen,
            child: Text(
              name[0],
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          const SizedBox(height: 14),
          Text(name, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}













