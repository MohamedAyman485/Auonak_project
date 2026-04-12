import 'package:flutter/material.dart';

const Color mainGreen = Color(0xFF00A60B);
const Color lightGrey = Color(0xFFF5F6F7);

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Update Profile",
          style: TextStyle(
            color: mainGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                        Border.all(color: mainGreen, width: 3),
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                        AssetImage("assets/profile.jpg"),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: mainGreen,
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Profile Picture",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),

            const SizedBox(height: 25),

            // Form Fields
            buildRowField(
              leftLabel: "Full Name",
              leftHint: "Enter your full name",
              rightLabel: "Age",
              rightHint: "18",
            ),

            const SizedBox(height: 14),

            buildRowField(
              leftLabel: "Country",
              leftHint: "Country",
              rightLabel: "City",
              rightHint: "City",
            ),

            const SizedBox(height: 14),

            buildRowField(
              leftLabel: "Area",
              leftHint: "Area",
              rightLabel: "GPS Coordinates",
              rightHint: "GPS",
            ),

            const SizedBox(height: 14),

            buildRowField(
              leftLabel: "Phone Number",
              leftHint: "+201234567890",
              rightLabel: "Email",
              rightHint: "user@example.com",
            ),

            const SizedBox(height: 25),

            // Official Documents
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Official Documents",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: const [
                Expanded(
                  child: DocumentCard(
                    title: "ID Card",
                    icon: Icons.badge_outlined,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DocumentCard(
                    title: "Passport",
                    icon: Icons.public,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Save Changes
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// HELPERS
//////////////////////////////////////////////////////////////

Widget buildRowField({
  required String leftLabel,
  required String leftHint,
  required String rightLabel,
  required String rightHint,
}) {
  return Row(
    children: [
      Expanded(
        child: buildTextField(label: leftLabel, hint: leftHint),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: buildTextField(label: rightLabel, hint: rightHint),
      ),
    ],
  );
}

Widget buildTextField({
  required String label,
  required String hint,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(
              fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 6),
      TextField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: lightGrey,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ],
  );
}

//////////////////////////////////////////////////////////////
// DOCUMENT CARD
//////////////////////////////////////////////////////////////

class DocumentCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const DocumentCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: mainGreen.withOpacity(0.7),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: mainGreen),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Replace",
              style: TextStyle(color: mainGreen),
            ),
          ),
        )
      ],
    );
  }
}

