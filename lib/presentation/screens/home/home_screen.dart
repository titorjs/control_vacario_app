import 'package:flutter/material.dart';
import '../../../utils/user_session.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  String? userLastname;
  String? roleId;

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  Future<void> _loadUserInfo() async {
    final session = UserSession();
    userName = await session.getUserName();
    userLastname = await session.getUserLastname();
    roleId = await session.getRoleId();
    setState(() {}); // Actualiza la interfaz con los datos obtenidos
  }

  Future<void> _logout() async {
    final session = UserSession();
    await session.clearSession(); // Elimina los datos de la sesión
    Navigator.pushReplacementNamed(context, '/login'); // Navega a la pantalla de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Quitar el botón de ir hacia atrás
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(); // Llama al método para cerrar sesión
            },
          ),
        ],
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
              child: menuBuilding(context),
            ),
          ],
        ),
      ),
    );
  }

  ListView menuBuilding(BuildContext context) {
    final isAdmin = roleId == 'ROLE_ADMIN';
    List<Widget> list;

    if(isAdmin){
      list = [
        _buildMenuItem(context, 'Usuarios', Icons.person, '/users'),
                _buildMenuItem(context, 'Vacas', Icons.pets, '/cows'),
                _buildMenuItem(context, 'Remedios', Icons.healing, '/remedies'),
                _buildMenuItem(context, 'TotalProduction', Icons.summarize, '/total_production'),
                _buildMenuItem(context, 'Venta Queso', Icons.calculate, '/venta_queso'),
                _buildMenuItem(context, 'Venta Leche', Icons.cloud, '/venta_leche'),
                _buildMenuItem(context, 'Estadísticas', Icons.timeline, '/statistic'),
      ];
    } else {
      list = [
        _buildMenuItem(context, 'Remedios', Icons.healing, '/remedies'),
        _buildMenuItem(context, 'Venta Leche', Icons.cloud, '/venta_leche'),
      ];
    }

    return ListView(
              children: list,
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
