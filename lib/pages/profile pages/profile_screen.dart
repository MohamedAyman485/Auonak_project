import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
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
              const ProfileHeader(),
              const SizedBox(height: 20),

              /// 🔥 Tabs
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
              if (selectedIndex == 0) const PersonalInfoCard(),
              if (selectedIndex == 1) const RequestedServicesWidget(),
              if (selectedIndex == 2) const VolunteeringServicesWidget(),

              const SizedBox(height: 20),
              const BalanceSection(),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UpdateProfileScreen(),
                    ),
                  );
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
// HEADER
//////////////////////////////////////////////////////////////

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: mainGreen.withOpacity(0.3), width: 4),
          ),
          child: const CircleAvatar(
            radius: 45,
            backgroundImage: AssetImage("assets/profile.jpg"),
          ),
        ),
        const SizedBox(height: 8),
        const Text("Level: 0", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////
// TABS (UPDATED)
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
      padding: const EdgeInsets.all(4), // 👈 مهم
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
          margin: const EdgeInsets.symmetric(horizontal: 4), // 👈 spacing
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
// PERSONAL INFO (UNCHANGED)
//////////////////////////////////////////////////////////////

class PersonalInfoCard extends StatelessWidget {
  const PersonalInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Personal Information",
            style: TextStyle(
              color: mainGreen,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(height: 20),
          InfoRow(left: "Name", right: "User Name"),
          InfoRow(left: "National ID", right: "123456789"),
          InfoRow(left: "Age", right: "30"),
          InfoRow(left: "Country", right: "Egypt"),
          InfoRow(left: "City", right: "Cairo"),
          InfoRow(left: "Area", right: "Mokattam"),
          InfoRow(left: "Phone", right: "+201234567890"),
          InfoRow(left: "Email", right: "user@example.com"),
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
// NEW WIDGETS
//////////////////////////////////////////////////////////////

class RequestedServicesWidget extends StatelessWidget {
  const RequestedServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.request_page, color: mainGreen),
              SizedBox(width: 8),
              Text(
                "Requested Services",
                style: TextStyle(
                  color: mainGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "No services yet",
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}

class VolunteeringServicesWidget extends StatelessWidget {
  const VolunteeringServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.volunteer_activism, color: mainGreen),
              SizedBox(width: 8),
              Text(
                "Volunteering Services",
                style: TextStyle(
                  color: mainGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "No services yet",
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// BALANCE SECTION (UNCHANGED)
//////////////////////////////////////////////////////////////

class BalanceSection extends StatelessWidget {
  const BalanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            showBalanceDetails(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: mainGreen.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Current Balance  \$150",
              style: TextStyle(
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
void showBalanceDetails(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Balance Details",
                    style: TextStyle(
                      color: mainGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Text("Details here"),
            ],
          ),
        ),
      );
    },
  );
}

