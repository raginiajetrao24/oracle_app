import 'package:flutter/material.dart';
import 'package:flutter_app/screens/dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final staffController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {

  String staff = staffController.text;
  String password = passwordController.text;

  if (staff.isEmpty || password.isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Enter all fields'),
      ),
    );

    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const DashboardScreen(),
    ),
  );
}

  bool isPasswordHidden = true;

  @override
  void dispose() {
    staffController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // Logo
                  Image.asset(
                    'assets/images/mannai_logo.jpeg',
                    height: 90,
                  ),

                  const SizedBox(height: 20),

                  // Welcome Text
                  const Text(
                    'Welcome to Mannai',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D3D77),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Staff Number Label
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Staff Number',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),                  
                  // Staff Number Field
                  TextField(
                    controller: staffController,
                    decoration: InputDecoration(
                      hintText: 'Staff Number',
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Password Label
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Password Field
                  TextField(
                    controller: passwordController,
                    obscureText: isPasswordHidden,
                    decoration: InputDecoration(
                      hintText: 'Password',

                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),

                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed:login,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D3D77),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Please enter your HRMS Password to login.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}