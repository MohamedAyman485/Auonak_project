import 'package:android/pages/Home.dart';
import 'package:flutter/material.dart';
import '../pages/Home.dart';
import 'package:android/pages/php_services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android/log & reg/register_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const Color mainGreen = Color(0xFF1ABC9C);



//////////////////////////////////////////////////////////////////////////////
// BACKGROUND
//////////////////////////////////////////////////////////////////////////////

Widget buildBackground({required Widget child}) {
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("images/bg.png"),
        fit: BoxFit.cover,
      ),
    ),
    child: child,
  );
}

Widget buildContainer({required Widget child}) {
  return Center(
    child: Container(
      width: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 12),
        ],
      ),
      child: child,
    ),
  );
}
//////////////////////////////////////////////////////////////////////////////
// STEP INDICATOR
//////////////////////////////////////////////////////////////////////////////
Widget stepIndicator(int step) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(7, (index) {

      // الخط بين الدواير
      if (index % 2 == 1) {
        int lineIndex = index ~/ 2;
        bool isActiveLine = lineIndex < step - 1;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 35, // 👈 خط أطول شويه
          height: 3,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          color: isActiveLine ? mainGreen : Colors.grey[400],
        );
      }

      // الدواير
      int circleNum = (index ~/ 2) + 1;
      bool isDone = circleNum < step;
      bool isCurrent = circleNum == step;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isCurrent ? 40 : 32, // 👈 كبر بسيط فقط
        height: isCurrent ? 40 : 32,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCurrent || isDone ? mainGreen : Colors.grey[300],
          boxShadow: isCurrent
              ? [
            BoxShadow(
              color: mainGreen.withOpacity(0.4),
              blurRadius: 6,
              spreadRadius: 1,
            )
          ]
              : [],
        ),
        child: Center(
          child: isDone
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : Text(
            "$circleNum",
            style: TextStyle(
              fontSize: isCurrent ? 16 : 14,
              fontWeight: FontWeight.bold,
              color:
              isCurrent ? Colors.white : Colors.black54,
            ),
          ),
        ),
      );
    }),
  );
}
//////////////////////////////////////////////////////////////////////////////
// SMOOTH NAVIGATION
//////////////////////////////////////////////////////////////////////////////

void smoothNavigation(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, a, b) => FadeTransition(opacity: a, child: screen),
    ),
  );
}

//////////////////////////////////////////////////////////////////////////////
// STEP SCREEN (REGISTRATION FLOW)
//////////////////////////////////////////////////////////////////////////////
Widget stepScreen({
  required int step,
  required BuildContext context,
  required List<Widget> fields,
  required VoidCallback next,
  bool showBack = true,
}) {
  return buildBackground(
    child: Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: buildContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👈 Header: Back + Create Account في نفس السطر
            Row(
              children: [
                if (showBack)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.arrow_back, color: Colors.grey, size: 16),
                        SizedBox(width: 5),
                        Text(
                          "Back",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Spacer(flex: 3),
              ],
            ),
            const SizedBox(height: 20),

            // 👈 Step Indicator
            stepIndicator(step),
            const SizedBox(height: 25),

            // 👈 الـ Fields (Full Name + Gender)
            ...fields,
            const SizedBox(height: 25),

            // 👈 Next Button بعرض كامل تحت
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: next,
                child: Text(
                  "Next",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 👈 Link to Login في المنتصف
            Center(
              child: GestureDetector(
                onTap: () {
                  smoothNavigation(context, const LoginScreen());
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                            color: mainGreen, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
//////////////////////////////////////////////////////////////////////////////
// REGISTRATION SCREENS
//////////////////////////////////////////////////////////////////////////////
//step 1 screen

class Step1Screen extends StatefulWidget {
  final RegisterModel model;

  const Step1Screen({super.key, required this.model});

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  final TextEditingController nameController = TextEditingController();
  String? gender;

  bool get isValid {
    return nameController.text.isNotEmpty && gender != null;
  }

  @override
  Widget build(BuildContext context) {
    return stepScreen(
      step: 1,
      context: context,
      showBack: false,
      fields: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Full Name"),
          onChanged: (_) => setState(() {}),
        ),

        const SizedBox(height: 25),

        DropdownButtonFormField<String>(
          value: gender,
          decoration: InputDecoration(
            labelText: "Gender",


            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: mainGreen, width: 1.2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: const [
            DropdownMenuItem(value: "male", child: Text("Male")),
            DropdownMenuItem(value: "female", child: Text("Female")),
          ],
          onChanged: (value) {
            setState(() {
              gender = value;
            });
          },
        ),
      ],
        next: () {
          if (nameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please enter your full name")),
            );
            return;
          }

          if (gender == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select your gender")),
            );
            return;
          }

          widget.model.name = nameController.text;
          widget.model.gender = gender;

          smoothNavigation(
            context,
            Step2Screen(model: widget.model),
          );
        },
    );
  }
}

///////////step 2 screen
class Step2Screen extends StatefulWidget {
  final RegisterModel model;

  const Step2Screen({super.key, required this.model});

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  String? selectedCountry;
  final TextEditingController regionController = TextEditingController();
  final TextEditingController streetController = TextEditingController();

  bool countryError = false;
  bool regionError = false;
  bool streetError = false;

  final List<String> arabCountries = [
    "Egypt",
    "Saudi Arabia",
    "UAE",
    "Jordan",
    "Lebanon",
    "Morocco",
    "Algeria",
    "Tunisia",
    "Iraq",
    "Syria",
    "Kuwait",
    "Bahrain",
    "Qatar",
    "Oman",
    "Yemen",
  ];

  void validateAndNext() {
    setState(() {
      countryError = selectedCountry == null;
      regionError = regionController.text.trim().isEmpty;
      streetError = streetController.text.trim().isEmpty;
    });

    if (!countryError && !regionError && !streetError) {
      // 👇 تخزين البيانات
      widget.model.country = selectedCountry;
      widget.model.city = regionController.text;
      widget.model.street = streetController.text;

      // 👇 الانتقال للخطوة التالية
      smoothNavigation(
        context, Step3Screen(model: widget.model),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return stepScreen(
      step: 2,
      context: context,
      fields: [
        DropdownButtonFormField<String>(
          value: selectedCountry,
          decoration: InputDecoration(
            labelText: "Country",
            errorText: countryError ? "Please select a country" : null,
          ),
          items: arabCountries
              .map((country) => DropdownMenuItem(
            value: country,
            child: Text(country),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedCountry = value;
              countryError = false;
            });
          },
        ),
        const SizedBox(height: 10),

        TextField(
          controller: regionController,
          decoration: InputDecoration(
            labelText: "Region / City",
            errorText: regionError ? "This field is required" : null,
          ),
        ),
        const SizedBox(height: 10),

        TextField(
          controller: streetController,
          decoration: InputDecoration(
            labelText: "Street",
            errorText: streetError ? "This field is required" : null,
          ),
        ),
      ],
      next: validateAndNext, // 👈 أهم سطر
    );
  }
}
///////////step 3 screen
class Step3Screen extends StatefulWidget {
  final RegisterModel model;

  const Step3Screen({super.key, required this.model});

  @override
  State<Step3Screen> createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirm = false;

  String? emailError;
  String? passwordError;
  String? confirmError;

  void validateAndNext() {
    setState(() {
      emailError = null;
      passwordError = null;
      confirmError = null;

      // Email validation
      if (_emailController.text.isEmpty) {
        emailError = "Email is required";
      } else if (!_emailController.text.contains('@')) {
        emailError = "Email must contain @";
      }

      // Password validation
      final password = _passwordController.text;
      if (password.isEmpty) {
        passwordError = "Password is required";
      } else if (password.length < 8) {
        passwordError = "Password must be at least 8 characters";
      } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password)) {
        passwordError = "Password must contain letters and numbers";
      }

      // Confirm Password validation
      final confirm = _confirmController.text;
      if (confirm.isEmpty) {
        confirmError = "Please confirm your password";
      } else if (confirm != password) {
        confirmError = "Passwords do not match";
      }

      // ✅ لو كله صح
      if (emailError == null && passwordError == null && confirmError == null) {

        // 👇 خزّن البيانات
        widget.model.email = _emailController.text;
        widget.model.password = _passwordController.text;

        // 👇 روح للخطوة اللي بعدها
        smoothNavigation(
          context,
          Step4Screen(model: widget.model),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return stepScreen(
      step: 3,
      context: context,
      fields: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Email",
            errorText: emailError,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            labelText: "Password",
            errorText: passwordError,
            suffixIcon: IconButton(
              icon: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _confirmController,
          obscureText: !_showConfirm,
          decoration: InputDecoration(
            labelText: "Confirm Password",
            errorText: confirmError,
            suffixIcon: IconButton(
              icon: Icon(
                _showConfirm ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _showConfirm = !_showConfirm;
                });
              },
            ),
          ),
        ),
      ],
      next: validateAndNext,
    );
  }
}

///////////step 4 screen

class Step4Screen extends StatefulWidget {
  final RegisterModel model;

  const Step4Screen({super.key, required this.model});

  @override
  State<Step4Screen> createState() => _Step4ScreenState();
}

class _Step4ScreenState extends State<Step4Screen> {
  final TextEditingController phoneController = TextEditingController();
  bool phoneError = false;

  void validateAndNext() async {
    print("BUTTON CLICKED");

    setState(() {
      phoneError = phoneController.text.trim().isEmpty;
    });

    print("PHONE: ${phoneController.text}");

    if (phoneError) return;

    print("BEFORE REQUEST");

    try {
      var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/send-otp"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "phone": phoneController.text,
          "email": widget.model.email, // 👈 مهم جدًا
        },
      );

      print("AFTER REQUEST ✅");

      var data = jsonDecode(response.body);
      print(data);

      /// 🔥 الجزء المهم اللي ناقصك
      if (response.statusCode == 200) {
        print("GO TO OTP 🚀");

        // خزّن الرقم
        widget.model.phone = phoneController.text;

        // روح لصفحة OTP
        smoothNavigation(
          context,
          VerificationScreen(
            phoneNumber: phoneController.text,
            model: widget.model,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Error")),
        );
      }
    } catch (e) {
      print("ERROR ❌");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return stepScreen(
      step: 4,
      context: context,
      fields: [
        TextField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: "Phone Number",
            errorText:
            phoneError ? "Please enter your phone number" : null,
          ),
        ),
      ],
      next: validateAndNext,
    );
  }
}

///////////verification screen

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final RegisterModel model;

  const VerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.model,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController codeController = TextEditingController();
  bool codeError = false;
  bool isLoading = false;

  void validateCode() async {
    setState(() {
      codeError = codeController.text.trim().isEmpty;
    });

    if (codeError) return;

    setState(() {
      isLoading = true;
    });

    try {
      /// 1️⃣ verify OTP
      var verifyResponse = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/verify-otp"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": widget.model.email,
          "otp": codeController.text,
        },
      );

      print("VERIFY RAW: ${verifyResponse.body}");

      if (verifyResponse.body.startsWith("<")) {
        print("❌ HTML ERROR");
        return;
      }

      var verifyData = jsonDecode(verifyResponse.body);
      print("VERIFY: $verifyData");

      if (verifyResponse.statusCode == 200) {
        /// 2️⃣ register
        var registerResponse = await http.post(
          Uri.parse("http://10.0.2.2:8000/api/register"),
          headers: {
            "Accept": "application/json",
          },
          body: {
            "name": widget.model.name,
            "email": widget.model.email,
            "password": widget.model.password,
            "phone": widget.model.phone,
            "gender": widget.model.gender,
            "nationality": widget.model.country,
            "city": widget.model.city,
            "street": widget.model.street,
          },
        );

        print("REGISTER RAW: ${registerResponse.body}");

        if (registerResponse.body.startsWith("<")) {
          print("❌ HTML ERROR IN REGISTER");
          return;
        }

        var registerData = jsonDecode(registerResponse.body);
        print("REGISTER: $registerData");

        if (registerResponse.statusCode == 200) {
          print("✅ REGISTER DONE");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePage(
                isDark: false,
                toggleTheme: () {},
              ),
            ),
          );
        }else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(registerData['message'] ?? "Register error")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(verifyData['message'] ?? "Invalid OTP")),
        );
      }
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connection error")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: buildContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter code sent to ${widget.phoneNumber}",
                  errorText: codeError ? "Please enter the code" : null,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : validateCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Next",
                    style:
                    TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//////////////////////////////////////////////////////////////////////////////
// LOGIN SCREEN
//////////////////////////////////////////////////////////////////////////////
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  void validateAndLogin() async {
    // ✅ الأول validation
    setState(() {
      emailError = null;
      passwordError = null;

      if (emailController.text.isEmpty) {
        emailError = "Email is required";
      } else if (!emailController.text.contains('@')) {
        emailError = "Email must contain @";
      }

      if (passwordController.text.isEmpty) {
        passwordError = "Password is required";
      }
    });

    // ✅ بعد كده نكلم الـ API برا setState
    if (emailError == null && passwordError == null) {
      try {
        var data = await ApiService.login(
          emailController.text,
          passwordController.text,
        );

        print(data);

        var token = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        print("TOKEN: $token");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(
              isDark: false,
              toggleTheme: () {},
            ),
          ),
        );
      } catch (e) {
        print(e.toString());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: buildContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Email TextField
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: emailError,
                ),
              ),
              const SizedBox(height: 10),

              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: passwordError,
                ),
              ),
              const SizedBox(height: 25),

              // Login Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainGreen,
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: validateAndLogin,
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 15),

              // Link to create account
              GestureDetector(
                onTap: () {
                  smoothNavigation(
                    context,
                    Step1Screen(model: RegisterModel()),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    children: [
                      TextSpan(
                        text: "Create one",
                        style: TextStyle(
                            color: mainGreen, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
