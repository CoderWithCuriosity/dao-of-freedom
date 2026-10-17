import 'element.dart';

class Technique {
  final String id;
  final String name;
  final String description;
  final Element? baseElement;
  final DerivedElement? derivedElement;
  final double qiCost;
  final double soulCost;
  final double cooldown;

  const Technique({
    required this.id,
    required this.name,
    this.description = '',
    this.baseElement,
    this.derivedElement,
    this.qiCost = 0,
    this.soulCost = 0,
    this.cooldown = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'baseElement': baseElement?.name,
        'derivedElement': derivedElement?.name,
        'qiCost': qiCost,
        'soulCost': soulCost,
        'cooldown': cooldown,
      };

  factory Technique.fromJson(Map<String, dynamic> json) => Technique(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        baseElement: json['baseElement'] != null
            ? Element.values.byName(json['baseElement'] as String)
            : null,
        derivedElement: json['derivedElement'] != null
            ? DerivedElement.values.byName(json['derivedElement'] as String)
            : null,
        qiCost: (json['qiCost'] as num?)?.toDouble() ?? 0,
        soulCost: (json['soulCost'] as num?)?.toDouble() ?? 0,
        cooldown: (json['cooldown'] as num?)?.toDouble() ?? 0,
      );
}