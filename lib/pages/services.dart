import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestsScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String serviceType;

  const RequestsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.serviceType
  });

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  //////////////////////////////////////////////////////
  /// 🔥 GET ALL SERVICES
  //////////////////////////////////////////////////////
  Future<void> fetchServices() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("http://10.0.2.2:8000/api/services"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List allServices = data; // 🔥 مهم جدا

      final filtered = allServices.where((service) {
        return int.parse(service['category_id'].toString()) == widget.categoryId;
      }).toList();

      setState(() {
        requests = filtered;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  //////////////////////////////////////////////////////
  /// UI (متغيرش 👇)
  //////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const Center(
        child: Text(
          "لا يوجد خدمات حالياً",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];

          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// status + time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: request['status'] == "pending"
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        request['status'] ?? '',
                        style: TextStyle(
                          color: request['status'] == "pending"
                              ? Colors.orange
                              : Colors.green,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          request['time'] ?? '',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// title
                Text(
                  request['name'] ?? request['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// description
                Text(
                  request['description'] ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                /// location
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.red),
                    const SizedBox(width: 5),
                    Text(request['service_location'] ?? ''),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}