class VentaLeche {
  final String ventaLecheraDate;
  final double ventaLecheraLiters;
  final double ventaLecheraPpl;

  VentaLeche({
    required this.ventaLecheraDate,
    required this.ventaLecheraLiters,
    required this.ventaLecheraPpl,
  });

  factory VentaLeche.fromJson(Map<String, dynamic> json) {
    return VentaLeche(
      ventaLecheraDate: json['ventaLecheraDate'],
      ventaLecheraLiters: json['ventaLecheraLiters'],
      ventaLecheraPpl: json['ventaLecheraPpl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ventaLecheraDate': ventaLecheraDate,
      'ventaLecheraLiters': ventaLecheraLiters,
      'ventaLecheraPpl': ventaLecheraPpl,
    };
  }
}
