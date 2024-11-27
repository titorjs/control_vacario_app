class ProductionTotal {
  final int productoId;
  final String productoNombre;
  final String produccionDate;
  final double produccionReal;
  final double produccionEsperada;

  ProductionTotal({
    required this.productoId,
    required this.productoNombre,
    required this.produccionDate,
    required this.produccionReal,
    required this.produccionEsperada,
  });

  factory ProductionTotal.fromJson(Map<String, dynamic> json) {
    return ProductionTotal(
      productoId: json['producto']['productoId'],
      productoNombre: json['producto']['nombre'],
      produccionDate: json['produccionDate'],
      produccionReal: json['produccionReal'],
      produccionEsperada: json['produccionEsperada'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'producto': {'productoId': productoId},
      'produccionDate': produccionDate,
      'produccionReal': produccionReal,
      'produccionEsperada': produccionEsperada,
    };
  }
}
