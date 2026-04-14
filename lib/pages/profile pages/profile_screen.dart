import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Recharge balance.dart';
import 'updateprofile.dart';

const Color mainGreen = Color(0xFF00A60B);
const Color darkGreen = Color(0xFF00A60B);
const Color lightGrey = Color(0xFFF5F6F7);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 0;

  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  /////////////////////////////////////////////
  /// 🔥 GET USER DATA
  /////////////////////////////////////////////
  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print("TOKEN: $token");

    var response = await http.get(
      Uri.parse("http://10.0.2.2:8000/api/user"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );
    print("TOKEN: $token");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    var data = jsonDecode(response.body);

    setState(() {
      userData = data; // 👈 مؤقتًا كده
      isLoading = false;
    });
  }

  /////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "My Profile",
                style: TextStyle(
                  color: mainGreen,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              /// 🔥 HEADER (نفس التصميم بس dynamic)
              ProfileHeader(userData: userData),

              const SizedBox(height: 20),

              /// 🔥 Tabs (زي ما هي)
              ProfileTabs(
                selectedIndex: selectedIndex,
                onTabSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// 🔥 Dynamic Content
              if (selectedIndex == 0)
                PersonalInfoCard(userData: userData),
              if (selectedIndex == 1)
                const RequestedServicesWidget(),
              if (selectedIndex == 2)
                const VolunteeringServicesWidget(),

              const SizedBox(height: 20),
              BalanceSection(userData: userData),
              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const UpdateProfileScreen(),
                    ),
                  );

                  /// 🔥 REFRESH بعد التعديل
                  getUserData();
                },
                child: const Text(
                  "Update Profile",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// HEADER (نفس الشكل بس صورة من السيرفر)
//////////////////////////////////////////////////////////////

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const ProfileHeader({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    String? image = userData?['id_image'];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: (userData?['level'] ?? 0) >= 5
                  ? Colors.purple
                  : (userData?['level'] ?? 0) >= 3
                  ? Colors.orange
                  : mainGreen.withOpacity(0.3),
              width: 4,
            ),
          ),
          child: CircleAvatar(
            radius: 45,
            backgroundImage: image != null
                ? NetworkImage("http://10.0.2.2:8000/storage/$image")
                : const AssetImage("assets/profile.jpg") as ImageProvider,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Level ${userData?['level'] ?? 0}",
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////
// PERSONAL INFO (نفس UI بس dynamic)
//////////////////////////////////////////////////////////////

class PersonalInfoCard extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const PersonalInfoCard({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    if (userData == null) return const Text("No Data");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Personal Information",
            style: TextStyle(
              color: mainGreen,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(height: 20),

          InfoRow(left: "Name", right: userData!['name'] ?? ""),
          InfoRow(left: "National ID", right: userData!['national_id'] ?? ""),
          InfoRow(left: "Age", right: userData!['age']?.toString() ?? ""),
          InfoRow(left: "Country", right: userData!['nationality'] ?? ""),
          InfoRow(left: "City", right: userData!['city'] ?? ""),
          InfoRow(left: "Area", right: userData!['street'] ?? ""),
          InfoRow(left: "Phone", right: userData!['phone'] ?? ""),
          InfoRow(left: "Email", right: userData!['email'] ?? ""),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String left;
  final String right;

  const InfoRow({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              left,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              right,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// 🔥 باقي الWidgets زي ما هي (من غير تغيير)
//////////////////////////////////////////////////////////////

class ProfileTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const ProfileTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          tabItem("Personal", 0),
          tabItem("Requested", 1),
          tabItem("Volunteering", 2),
        ],
      ),
    );
  }

  Widget tabItem(String title, int index) {
    final bool isActive = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? mainGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////

class RequestedServicesWidget extends StatelessWidget {
  const RequestedServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(child: Text("No services yet")),
    );
  }
}

class VolunteeringServicesWidget extends StatelessWidget {
  const VolunteeringServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(child: Text("No services yet")),
    );
  }
}

//////////////////////////////////////////////////////////////

class BalanceSection extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const BalanceSection({super.key, required this.userData});

  void showBalanceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // HEADER
              Row(
                children: const [
                  Expanded(child: Center(child: Text("Balance", style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text("Min", style: TextStyle(fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text("Currency", style: TextStyle(fontWeight: FontWeight.bold)))),
                ],
              ),

              const Divider(),

              const SizedBox(height: 10),

              buildRow("Basic Balance",
                  userData?['basic_balance'] ?? 0,
                  "EGP"),

              const SizedBox(height: 10),

              buildRow("Volunteering Balance",
                  userData?['volunteering_balance'] ?? 0,
                  "EGP"),

              const SizedBox(height: 10),

              buildRow("Total",
                  userData?['balance'] ?? 0,
                  "EGP"),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget buildRow(String title, dynamic value, String currency) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        Expanded(
          child: Center(
            child: Text(
              "$value",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(currency, style: const TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => showBalanceSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: mainGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Balance ${userData?['balance'] ?? 0}",
              style: const TextStyle(
                color: mainGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RechargeBalanceScreen(),
              ),
            );
          },
          child: const Text(
            "Recharge Balance",
            style: TextStyle(color: mainGreen),
          ),
        )
      ],
    );
  }
}