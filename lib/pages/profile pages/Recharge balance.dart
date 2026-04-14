import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

const Color mainGreen = Color(0xFF00A60B);
const Color lightGreenBg = Color(0xFFF1FAF3);
const Color lightGrey = Color(0xFFF5F6F7);

class RechargeBalanceScreen extends StatefulWidget {
  const RechargeBalanceScreen({super.key});

  @override
  State<RechargeBalanceScreen> createState() => _RechargeBalanceScreenState();
}

class _RechargeBalanceScreenState extends State<RechargeBalanceScreen> {

  int? selectedAmount;
  File? receiptImage;
  bool isLoading = false;

  double currentBalance = 0;

  @override
  void initState() {
    super.initState();
    loadBalance();
  }

  Future<void> loadBalance() async {
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
        currentBalance = double.tryParse(data['balance'].toString()) ?? 0;
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        receiptImage = File(picked.path);
      });
    }
  }

  Future<void> submitRecharge() async {
    if (selectedAmount == null || receiptImage == null) return;

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() => isLoading = true);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://10.0.2.2:8000/api/recharge-balance"),
    );

    request.headers['Authorization'] = "Bearer $token";
    request.headers['Accept'] = "application/json";

    request.fields['amount'] = selectedAmount.toString();

    request.files.add(
      await http.MultipartFile.fromPath(
        'receipt',
        receiptImage!.path,
      ),
    );

    var response = await request.send();
    var body = await response.stream.bytesToString();

    setState(() => isLoading = false);

    print(response.statusCode);
    print(body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        currentBalance += selectedAmount!;
        selectedAmount = null;
        receiptImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recharge submitted ✅")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed ❌")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool canSubmit = selectedAmount != null && receiptImage != null && !isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Recharge Balance",
          style: TextStyle(color: mainGreen, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // BALANCE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightGreenBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Current Balance", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text(
                    "${currentBalance.toStringAsFixed(0)} EGP",
                    style: const TextStyle(
                      color: mainGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text("Choose Amount (EGP)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AmountChip(amount: 199, selected: selectedAmount == 199, onTap: () {
                  setState(() => selectedAmount = 199);
                }),
                AmountChip(amount: 499, selected: selectedAmount == 499, onTap: () {
                  setState(() => selectedAmount = 499);
                }),
                AmountChip(amount: 999, selected: selectedAmount == 999, onTap: () {
                  setState(() => selectedAmount = 999);
                }),
              ],
            ),

            const SizedBox(height: 25),

            const Text("Upload Transfer Screenshot", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: receiptImage == null
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined, size: 36, color: Colors.grey),
                    SizedBox(height: 8),
                    Text("Click to upload screenshot", style: TextStyle(color: Colors.grey))
                  ],
                )
                    : Image.file(receiptImage!, fit: BoxFit.cover),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSubmit ? mainGreen : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: canSubmit ? submitRecharge : null,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit Recharge"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class AmountChip extends StatelessWidget {
  final int amount;
  final bool selected;
  final VoidCallback onTap;

  const AmountChip({
    super.key,
    required this.amount,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? mainGreen : lightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          "$amount",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}