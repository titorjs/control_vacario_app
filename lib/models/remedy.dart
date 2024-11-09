class Remedy {
  final int id;
  final String name;
  final String description;

  Remedy({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Remedy.fromJson(Map<String, dynamic> json) {
    return Remedy(
      id: json['remedioId'],
      name: json['remedioName'],
      description: json['remedioDesc'],
    );
  }
}
