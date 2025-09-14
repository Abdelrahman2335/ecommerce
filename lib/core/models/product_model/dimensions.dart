import 'dart:convert';

import 'package:equatable/equatable.dart';

class Dimensions extends Equatable {
  final double? width;
  final double? height;
  final double? depth;

  const Dimensions({this.width, this.height, this.depth});

  factory Dimensions.fromMap(Map<String, dynamic> data) => Dimensions(
        width: (data['width'] as num?)?.toDouble(),
        height: (data['height'] as num?)?.toDouble(),
        depth: (data['depth'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'width': width,
        'height': height,
        'depth': depth,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Dimensions].
  factory Dimensions.fromJson(String data) {
    return Dimensions.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Dimensions] to a JSON string.
  String toJson() => json.encode(toMap());

  Dimensions copyWith({
    double? width,
    double? height,
    double? depth,
  }) {
    return Dimensions(
      width: width ?? this.width,
      height: height ?? this.height,
      depth: depth ?? this.depth,
    );
  }

  @override
  List<Object?> get props => [width, height, depth];
}
