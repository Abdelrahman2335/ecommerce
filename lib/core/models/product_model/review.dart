import 'dart:convert';

import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final int? rating;
  final String? comment;
  final DateTime? date;
  final String? reviewerName;
  final String? reviewerEmail;

  const Review({
    this.rating,
    this.comment,
    this.date,
    this.reviewerName,
    this.reviewerEmail,
  });

  factory Review.fromMap(Map<String, dynamic> data) => Review(
        rating: data['rating'] as int?,
        comment: data['comment'] as String?,
        date: data['date'] == null
            ? null
            : DateTime.parse(data['date'] as String),
        reviewerName: data['reviewerName'] as String?,
        reviewerEmail: data['reviewerEmail'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'rating': rating,
        'comment': comment,
        'date': date?.toIso8601String(),
        'reviewerName': reviewerName,
        'reviewerEmail': reviewerEmail,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Review].
  factory Review.fromJson(String data) {
    return Review.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Review] to a JSON string.
  String toJson() => json.encode(toMap());

  Review copyWith({
    int? rating,
    String? comment,
    DateTime? date,
    String? reviewerName,
    String? reviewerEmail,
  }) {
    return Review(
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
      reviewerName: reviewerName ?? this.reviewerName,
      reviewerEmail: reviewerEmail ?? this.reviewerEmail,
    );
  }

  @override
  List<Object?> get props {
    return [
      rating,
      comment,
      date,
      reviewerName,
      reviewerEmail,
    ];
  }
}
