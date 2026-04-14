import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:android/pages/add service.dart';
import 'package:android/pages/services.dart';

class CustomerOnline extends StatelessWidget {
  const CustomerOnline({super.key});

  ////////////////////////////////////////////////
  /// 🔥 CREATE REQUEST API
  ////////////////////////////////////////////////
  Future<void> createServiceRequest(BuildContext context, int serviceId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/services/$serviceId/request"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "description": "Request from mobile app",
          "time": DateTime.now().toString(),
          "location": "unknown",
        },
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Request sent successfully ✅")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed ❌: ${response.body}")),
        );
      }
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection error ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddServicePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                        child: Image.asset(
                          "images/vonlinemain.jpg",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Boost your business with Online services",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Grow your business by offering real-world services and connecting directly with customers in your area.",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 12),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text("Explore Services"),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Choose Category",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    buildCard(context, 6, "Programming", "images/programming.jpg"),
                    buildCard(context, 7, "Design", "images/design.jpg"),
                    buildCard(context, 8, "Translation", "images/transaltion.jpg"),
                    buildCard(context, 9, "Consultation", "images/consultation.jpg"),
                    buildCard(context, 10, "Others", "images/others.jpg"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////
  /// 🔥 CARD
  ////////////////////////////////////////////////
  Widget buildCard(BuildContext context, int id, String title, String image) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RequestsScreen(
                categoryId: id,
                categoryName: title,
                  serviceType: "request"
              ),
            ),
          );
        },
      child: Container(
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.asset(
                image,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}