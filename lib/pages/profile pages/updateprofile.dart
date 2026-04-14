import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

const Color mainGreen = Color(0xFF00A60B);
const Color lightGrey = Color(0xFFF5F6F7);

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final gpsController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  File? selectedImage;
  File? idCardImage;
  File? passportImage;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var response = await http.get(
      Uri.parse("http://10.0.2.2:8000/api/user"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      setState(() {
        nameController.text = data['name'] ?? "";
        cityController.text = data['city'] ?? "";
        phoneController.text = data['phone'] ?? "";
        countryController.text =
            data['country'] ?? data['nationality'] ?? "";
        emailController.text = data['email'] ?? "";

        ageController.text = data['age'] ?? "";
        areaController.text = data['area'] ?? "";
      });
    }
  }

  Future<void> updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() => isLoading = true);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://10.0.2.2:8000/api/update/user"),
    );

    request.headers['Authorization'] = "Bearer $token";
    request.headers['Accept'] = "application/json";

    // TEXT FIELDS
    request.fields['name'] = nameController.text;
    request.fields['phone'] = phoneController.text;
    request.fields['city'] = cityController.text;
    request.fields['country'] = countryController.text;
    request.fields['email'] = emailController.text;
    request.fields['age'] = ageController.text;
    request.fields['area'] = areaController.text;

    // PROFILE IMAGE
    if (selectedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_image',
          selectedImage!.path,
        ),
      );
    }

    // ID CARD
    if (idCardImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'id_card',
          idCardImage!.path,
        ),
      );
    }

    // PASSPORT
    if (passportImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'passport',
          passportImage!.path,
        ),
      );
    }

    var response = await request.send();
    var body = await response.stream.bytesToString();

    setState(() => isLoading = false);

    print("STATUS: ${response.statusCode}");
    print("BODY: $body");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Updated successfully ✅")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Update failed ❌")),
      );
    }
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

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

            // PROFILE IMAGE (UNCHANGED UI)
            Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: mainGreen, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: selectedImage != null
                            ? FileImage(selectedImage!)
                            : const AssetImage("assets/profile.jpg")
                        as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: pickProfileImage,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: mainGreen,
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                const Text("Profile Picture",
                    style: TextStyle(color: Colors.grey))
              ],
            ),

            const SizedBox(height: 25),

            buildRowField(
              leftLabel: "Full Name",
              leftController: nameController,
              rightLabel: "Age",
              rightController: ageController,
            ),

            const SizedBox(height: 14),

            buildRowField(
              leftLabel: "Country",
              leftController: countryController,
              rightLabel: "City",
              rightController: cityController,
            ),

            const SizedBox(height: 14),

            buildRowField(
              leftLabel: "Area",
              leftController: areaController,
              rightLabel: "GPS Coordinates",
              rightController: gpsController,
            ),

            const SizedBox(height: 14),

            buildRowField(
              leftLabel: "Phone Number",
              leftController: phoneController,
              rightLabel: "Email",
              rightController: emailController,
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Official Documents",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: DocumentCard(
                    title: "ID Card",
                    icon: Icons.badge_outlined,
                    onPick: () async {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(
                          source: ImageSource.gallery);
                      if (picked != null) {
                        setState(() {
                          idCardImage = File(picked.path);
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DocumentCard(
                    title: "Passport",
                    icon: Icons.public,
                    onPick: () async {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(
                          source: ImageSource.gallery);
                      if (picked != null) {
                        setState(() {
                          passportImage = File(picked.path);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

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
                onPressed: isLoading ? null : updateProfile,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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
class DocumentCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPick;

  const DocumentCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onPick,
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
              Icon(icon, size: 48, color: mainGreen.withOpacity(0.7)),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
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
            onPressed: onPick,
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
Widget buildRowField({
  required String leftLabel,
  required TextEditingController leftController,
  required String rightLabel,
  required TextEditingController rightController,
}) {
  return Row(
    children: [
      Expanded(
        child: buildTextField(
          label: leftLabel,
          controller: leftController,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: buildTextField(
          label: rightLabel,
          controller: rightController,
        ),
      ),
    ],
  );
}
Widget buildTextField({
  required String label,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        decoration: InputDecoration(
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