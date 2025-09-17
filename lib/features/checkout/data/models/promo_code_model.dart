class PromoCodeModel {
  final String code;
  final num discountAmount;
  final bool isValid;

  PromoCodeModel({
    required this.code,
    required this.discountAmount,
    required this.isValid,
  });

  PromoCodeModel copyWith({
    String? code,
    num? discountAmount,
    bool? isValid,
  }) {
    return PromoCodeModel(
      code: code ?? this.code,
      discountAmount: discountAmount ?? this.discountAmount,
      isValid: isValid ?? this.isValid,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discountAmount': discountAmount,
      'isValid': isValid,
    };
  }

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) {
    return PromoCodeModel(
      code: json['code'] ?? '',
      discountAmount: json['discountAmount'] ?? 0,
      isValid: json['isValid'] ?? false,
    );
  }
}
