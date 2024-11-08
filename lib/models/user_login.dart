class UserLogin {
  final String? token;
  final int? id;
  final String? name;
  final String? lastname;

  UserLogin({this.token, this.id, this.name, this.lastname});

  // Método para mapear JSON a un objeto User
  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      token: json['token'] as String?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      lastname: json['lastname'] as String?,
    );
  }
}
