import 'package:flutter/material.dart';
import 'package:android/pages/services.dart';

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
                onPressed: () {
                  if (titleController.text.isEmpty || selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("من فضلك املأ كل البيانات")),
                    );
                    return;
                  }

                  // ✅ إضافة الطلب
                  RequestStorage.requests.add(
                    Request(
                      title: titleController.text,
                      description: descriptionController.text,
                      time: timeController.text,
                      location: locationController.text,
                      type: selectedCategory!,
                      serviceType: serviceType,// 🔥 دي أهم حاجة
                    ),
                  );

                  // 🔙 رجوع للصفحة اللي فيها الطلبات
                  Navigator.pop(context);
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