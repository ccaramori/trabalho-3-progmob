// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService apiService = ApiService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String token = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    const storage = FlutterSecureStorage();
    final storedToken = await storage.read(key: 'USER_TOKEN');
    if (storedToken != null) {
      setState(() {
        token = storedToken;
      });

      Navigator.pushNamed(context, '/home'); // Navegue para a tela da home
    }
  }

  void login() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      final token = await apiService.login(email, password);

      setState(() {
        this.token = token;
      });

      Navigator.pushNamed(context, '/home'); // Navegue para a tela da home
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Falhou'),
            content: const Text('Falha ao logar. Por favor tente novamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
      ),
      body: Column(
        children: [
          if (token.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: 'E-mail'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(hintText: 'Senha'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      login();
                    },
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Cadastrar'),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
