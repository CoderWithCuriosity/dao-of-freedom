import 'element.dart';

class Weapon {
  final String id;
  final String name;
  final double attackBonus;
  final Element? element;
  final bool isLifeBound;

  const Weapon({
    required this.id,
    required this.name,
    this.attackBonus = 0,
    this.element,
    this.isLifeBound = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'attackBonus': attackBonus,
        'element': element?.name,
        'isLifeBound': isLifeBound,
      };

  factory Weapon.fromJson(Map<String, dynamic> json) => Weapon(
        id: json['id'] as String,
        name: json['name'] as String,
        attackBonus: (json['attackBonus'] as num?)?.toDouble() ?? 0,
        element: json['element'] != null
            ? Element.values.byName(json['element'] as String)
            : null,
        isLifeBound: json['isLifeBound'] as bool? ?? false,
      );
}