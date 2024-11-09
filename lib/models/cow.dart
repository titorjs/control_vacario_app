class CowType {
  final int id;
  final String description;

  CowType({required this.id, required this.description});

  factory CowType.fromJson(Map<String, dynamic> json) {
    return CowType(
      id: json['id'],
      description: json['description'],
    );
  }
}

class CowStatus {
  final int id;
  final String description;

  CowStatus({required this.id, required this.description});

  factory CowStatus.fromJson(Map<String, dynamic> json) {
    return CowStatus(
      id: json['id'],
      description: json['description'],
    );
  }
}

class Cow {
  final int id;
  final String code;
  final String name;
  final String description;
  final CowType type;
  final CowStatus status;

  Cow({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
  });

  factory Cow.fromJson(Map<String, dynamic> json) {
    return Cow(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      description: json['description'],
      type: CowType.fromJson(json['type']),
      status: CowStatus.fromJson(json['status']),
    );
  }
}
