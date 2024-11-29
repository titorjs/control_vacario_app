import 'package:flutter/material.dart';
import '../../../utils/user_session.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  String? userLastname;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final session = UserSession();
    userName = await session.getUserName();
    userLastname = await session.getUserLastname();
    setState(() {}); // Actualiza la interfaz con los datos obtenidos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la vaca
            Center(
              child: Image.asset(
                'assets/images/vaca-logo.jpg', // Cambia por el nombre de tu imagen de la vaca
                height: 100,
              ),
            ),
            SizedBox(height: 16),
            // Información del usuario
            Text(
              'Bienvenido, ${userName ?? ''} ${userLastname ?? ''}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            // Menú de opciones
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(context, 'Usuarios', Icons.person, '/users'),
                  _buildMenuItem(context, 'Vacas', Icons.pets, '/cows'),
                  //_buildMenuItem(context, 'Producción Diaria', Icons.calendar_today, '/daily_production'),
                  _buildMenuItem(context, 'Remedios', Icons.healing, '/remedies'),
                  _buildMenuItem(context, 'TotalProduction', Icons.summarize, '/total_production'),
                  _buildMenuItem(context, 'Estadísticas', Icons.timeline, '/statistic'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title, style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.pushNamed(context, route); // Navega a la ruta especificada
        },
      ),
    );
  }
}
