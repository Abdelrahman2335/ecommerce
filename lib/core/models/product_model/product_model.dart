import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'product.dart';

class ProductModel extends Equatable {
  final Product? product;
  final int? total;
  final int? skip;
  final int? limit;

  const ProductModel({this.product, this.total, this.skip, this.limit});

  factory ProductModel.fromMap(Map<String, dynamic> data) => ProductModel(
        product: data['product'] != null
            ? Product.fromMap(data['product'] as Map<String, dynamic>)
            : null,
        total: data['total'] as int?,
        skip: data['skip'] as int?,
        limit: data['limit'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'product': product?.toMap(),
        'total': total,
        'skip': skip,
        'limit': limit,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProductModel].
  factory ProductModel.fromJson(String data) {
    return ProductModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ProductModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ProductModel copyWith({
    Product? product,
    int? total,
    int? skip,
    int? limit,
  }) {
    return ProductModel(
      product: product ?? this.product,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [product, total, skip, limit];
}
