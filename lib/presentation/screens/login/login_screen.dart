import 'package:flutter/material.dart';
import 'package:control_vacario_app/utils/user_session.dart';
import '../../../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus(); // Verificar si el usuario ya está logueado
  }

  void _checkLoggedInStatus() async {
    final userSession = UserSession();
    final token = await userSession.getToken();

    if (token != null && token.isNotEmpty) {
      // Si el token existe, navega directamente al home
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final user = await _apiService.login(username, password);
    final userSession = UserSession();

    if (user != null) {
      // Guardar información de sesión
      await userSession.clearSession();
      await userSession.setToken(user.token!);
      await userSession.setUserId(user.id!);
      await userSession.setUserName(user.name!);
      await userSession.setUserLastname(user.lastname!);
      await userSession.setRoleId(user.roleId!);

      Navigator.pushReplacementNamed(context, '/home'); // Navegar al home
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credenciales incorrectas")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/vaca-logo.jpg',
              height: 100,
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
