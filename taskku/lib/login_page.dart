import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'register_page.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();

  Future login() async {

    if (username.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Username dan Password wajib diisi",
          ),
        ),
      );
      return;
    }

    var response = await http.post(
      Uri.parse(
        "http://10.0.2.2/taskku_api/login.php",
      ),
      body: {
        "username": username.text,
        "password": password.text,
      },
    );

    var data = jsonDecode(response.body);

    if (data["success"] == true) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardPage(
            userId: data["id"].toString(),
          ),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["message"]),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),

          child: Column(
            children: [

              const Icon(
                Icons.task_alt,
                size: 100,
                color: Colors.blue,
              ),

              const SizedBox(height: 10),

              const Text(
                "TaskKu",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const Text(
                "Manajemen Tugas Kuliah",
              ),

              const SizedBox(height: 40),

              TextField(
                controller: username,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),

                  onPressed: login,

                  child: const Text(
                    "LOGIN",
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const RegisterPage(),
                    ),
                  );

                },
                child: const Text(
                  "Belum punya akun? Registrasi",
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}