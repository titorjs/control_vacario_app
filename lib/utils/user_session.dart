import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSession {
  // Instancia única de la clase
  static final UserSession _instance = UserSession._internal();

  // Constructor privado para evitar la creación de múltiples instancias
  UserSession._internal();

  // Factory constructor que devuelve la instancia única
  factory UserSession() => _instance;

  // Almacenamiento seguro para guardar datos de usuario como el token
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  String? _token;
  int? _userId;
  String? _userName;
  String? _userLastname;

  // Métodos para manejar los datos de usuario
  Future<void> setToken(String token) async {
    _token = token;
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    _token ??= await _storage.read(key: 'token');
    return _token;
  }

  Future<void> setUserId(int id) async {
    _userId = id;
    await _storage.write(key: 'userId', value: id.toString());
  }

  Future<int?> getUserId() async {
    if (_userId == null) {
      final id = await _storage.read(key: 'userId');
      _userId = id != null ? int.parse(id) : null;
    }
    return _userId;
  }

  Future<void> setUserName(String name) async {
    _userName = name;
    await _storage.write(key: 'userName', value: name);
  }

  Future<String?> getUserName() async {
    _userName ??= await _storage.read(key: 'userName');
    return _userName;
  }

  Future<void> setUserLastname(String lastname) async {
    _userLastname = lastname;
    await _storage.write(key: 'userLastname', value: lastname);
  }

  Future<String?> getUserLastname() async {
    _userLastname ??= await _storage.read(key: 'userLastname');
    return _userLastname;
  }

  Future<void> clearSession() async {
    _token = null;
    _userId = null;
    _userName = null;
    _userLastname = null;
    await _storage.deleteAll();
  }
}
