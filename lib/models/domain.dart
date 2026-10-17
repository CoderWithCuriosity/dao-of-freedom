class Domain {
  final String name;
  final double radius;
  final double effectStrength;

  const Domain({
    required this.name,
    this.radius = 50,
    this.effectStrength = 1.0,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'radius': radius,
        'effectStrength': effectStrength,
      };

  factory Domain.fromJson(Map<String, dynamic> json) => Domain(
        name: json['name'] as String,
        radius: (json['radius'] as num?)?.toDouble() ?? 50,
        effectStrength: (json['effectStrength'] as num?)?.toDouble() ?? 1.0,
      );
}