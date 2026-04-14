import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  String? selectedCategory;
  String serviceType = "Offer Service";

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  final List<String> categories = [
    "Delivery",
    "Education",
    "Medicine",
    "Home Service",
    "Others",
    "Programming",
    "Design",
    "Translation",
    "Consultation",
  ];

  //////////////////////////////////////////////////////
  // ✅ API CALL (CREATE SERVICE)
  //////////////////////////////////////////////////////
  Future<void> createService() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    /// 🔥 map category name → id
    Map<String, int> categoryMap = {
      "Programming": 6,
      "Design": 7,
      "Translation": 8,
      "Consultation": 9,
      "Others": 10,
    };

    int categoryId = categoryMap[selectedCategory] ?? 6;

    var response = await http.post(
      Uri.parse("http://10.0.2.2:8000/api/services"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "name": titleController.text, // 🔥 بدل title
        "description": descriptionController.text,
        "category_id": categoryId.toString(), // 🔥 مهم
        "type": serviceType == "Offer Service" ? "offer" : "request", // 🔥 مهم
        "timesalary": "50", // 🔥 مؤقت (تقدر تعمله input بعدين)
        "service_location": locationController.text,
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service added successfully ✅")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error ❌: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Service"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Service Name
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Service Name",
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Description
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Description",
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Time
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                labelText: "Time",
                prefixIcon: const Icon(Icons.access_time),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Location
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: "Location",
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Category Dropdown
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Category",
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Service Type
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Service Type",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text("Offer Service"),
                    value: "Offer Service",
                    groupValue: serviceType,
                    onChanged: (value) {
                      setState(() {
                        serviceType = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("Request Service"),
                    value: "Request Service",
                    groupValue: serviceType,
                    onChanged: (value) {
                      setState(() {
                        serviceType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("من فضلك املأ كل البيانات")),
                    );
                    return;
                  }

                  await createService(); // ✅ API CALL

                  Navigator.pop(context); // رجوع بعد النجاح
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}