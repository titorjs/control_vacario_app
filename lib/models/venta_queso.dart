class VentaQueso {
  final int ventaQuesoId;
  final String ventaQuesoInit;
  final String ventaQuesoEnd;
  final double ventaQuesoPounds;
  final double ventaQuesoLeft;
  final bool ventaQuesoFalto;

  VentaQueso({
    required this.ventaQuesoId,
    required this.ventaQuesoInit,
    required this.ventaQuesoEnd,
    required this.ventaQuesoPounds,
    required this.ventaQuesoLeft,
    required this.ventaQuesoFalto,
  });

  factory VentaQueso.fromJson(Map<String, dynamic> json) {
    return VentaQueso(
      ventaQuesoId: json['ventaQuesoId'],
      ventaQuesoInit: json['ventaQuesoInit'],
      ventaQuesoEnd: json['ventaQuesoEnd'],
      ventaQuesoPounds: json['ventaQuesoPounds'],
      ventaQuesoLeft: json['ventaQuesoLeft'],
      ventaQuesoFalto: json['ventaQuesoFalto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ventaQuesoId': ventaQuesoId,
      'ventaQuesoInit': ventaQuesoInit,
      'ventaQuesoEnd': ventaQuesoEnd,
      'ventaQuesoPounds': ventaQuesoPounds,
      'ventaQuesoLeft': ventaQuesoLeft,
      'ventaQuesoFalto': ventaQuesoFalto,
    };
  }
}
