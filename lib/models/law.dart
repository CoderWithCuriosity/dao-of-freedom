import 'element.dart';

class Law {
  final String name;
  final HigherLaw type;
  final double masteryPercent; // 0.0 to 1.0

  const Law({
    required this.name,
    required this.type,
    this.masteryPercent = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.name,
        'masteryPercent': masteryPercent,
      };

  factory Law.fromJson(Map<String, dynamic> json) => Law(
        name: json['name'] as String,
        type: HigherLaw.values.byName(json['type'] as String),
        masteryPercent: (json['masteryPercent'] as num?)?.toDouble() ?? 0.0,
      );
}