class UserLogin {
  final String? token;
  final int? id;
  final String? name;
  final String? lastname;
  final String? roleId;

  UserLogin({this.token, this.id, this.name, this.lastname, this.roleId});

  // Método para mapear JSON a un objeto User
  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      token: json['token'] as String?,
      id: json['id'] as int?,
      name: json['name'] as String?,
      lastname: json['lastname'] as String?,
      roleId: json['roleId'] as String?,
    );
  }
}
