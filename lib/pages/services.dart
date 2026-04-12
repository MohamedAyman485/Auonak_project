import 'package:flutter/material.dart';

//////////////////////////////////////////////////
// 🧩 Model
//////////////////////////////////////////////////
class Request {
  final String title;
  final String description;
  final String time;
  final String location;
  final String type;
  final String serviceType;
  String status;

  Request({
    required this.title,
    required this.description,
    required this.time,
    required this.location,
    required this.type,
    required this.serviceType,
    this.status = "pending",
  });
}
//////////////////////////////////////////////////
// 🔥 Storage مشترك
//////////////////////////////////////////////////
class RequestStorage {
  static List<Request> requests = [];
}

//////////////////////////////////////////////////
// 🟩 الصفحة الديناميك (عرض الطلبات)
//////////////////////////////////////////////////
class RequestsScreen extends StatelessWidget {
  final String serviceType;

  const RequestsScreen({
    super.key,
    required this.serviceType,
  });

  @override
  Widget build(BuildContext context) {
    final filteredRequests = RequestStorage.requests
        .where((req) =>
    req.type == serviceType &&
        req.serviceType == "Request Service") // أو Offer Service
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(serviceType),
        centerTitle: true,
      ),

      body: filteredRequests.isEmpty
          ? const Center(
        child: Text(
          "لا يوجد طلبات حالياً",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: filteredRequests.length,
        itemBuilder: (context, index) {
          final request = filteredRequests[index];

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

                /// 🔹 status + time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: request.status == "pending"
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        request.status,
                        style: TextStyle(
                          color: request.status == "pending"
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
                          request.time,
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// 🔹 title
                Text(
                  request.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// 🔹 description
                Text(
                  request.description,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 10),

                /// 🔹 location
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.red),
                    const SizedBox(width: 5),
                    Text(request.location),
                  ],
                ),

                const SizedBox(height: 15),

                const Divider(),

                const SizedBox(height: 10),

                /// 🔹 user + button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.green[200],
                          child: Text(
                            request.title.length >= 2
                                ? request.title.substring(0, 2).toUpperCase()
                                : request.title.toUpperCase(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "User Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        request.status = "accepted";

                        (context as Element).markNeedsBuild();
                      },
                      child: const Text("Accept"),
                    ),
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