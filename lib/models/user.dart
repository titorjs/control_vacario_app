class Role {
  final int id;
  final String name;
  final String authority;

  Role({required this.id, required this.name, required this.authority});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      authority: json['authority'],
    );
  }
}

class User {
  final int id;
  final String username;
  final String name;
  final String lastname;
  final DateTime birth;
  final Role role;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.lastname,
    required this.birth,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      lastname: json['lastname'],
      birth: DateTime.parse(json['birth']),
      role: Role.fromJson(json['role']),
    );
  }
}
