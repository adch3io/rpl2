import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final Color primaryRed = const Color(0xFFC2000E);

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();

  String? selectedRole; // Mahasiswa atau Dosen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 60),
              const Text(
                'Sign Up!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silahkan Buat Akun Terlebih Dahulu',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 40),

              // Name
              const Text('Name'),
              TextField(controller: nameCtrl),
              const SizedBox(height: 20),

              // Email
              const Text('Email'),
              TextField(controller: emailCtrl),
              const SizedBox(height: 20),

              // Password
              const Text('Password'),
              TextField(controller: passCtrl, obscureText: true),
              const SizedBox(height: 20),

              // Confirm Password
              const Text('Confirm password'),
              TextField(controller: confirmPassCtrl, obscureText: true),
              const SizedBox(height: 20),

              // Role
              const Text('Role'),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                value: selectedRole,
                items: const [
                  DropdownMenuItem(
                    value: 'Mahasiswa',
                    child: Text('Mahasiswa'),
                  ),
                  DropdownMenuItem(value: 'Dosen', child: Text('Dosen')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Aksi register
                    debugPrint("Nama: ${nameCtrl.text}");
                    debugPrint("Email: ${emailCtrl.text}");
                    debugPrint("Role: $selectedRole");
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Sign In link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an Account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // balik ke login
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
