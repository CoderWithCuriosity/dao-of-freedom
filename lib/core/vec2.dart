/// A pure data 2D vector — used by models, not by the game world.
///
/// This is intentionally separate from Flame's `Vector2`.
/// Models should never depend on Flame.
class Vec2 {
  final double x;
  final double y;

  const Vec2(this.x, this.y);

  static const Vec2 zero = Vec2(0, 0);

  Vec2 copyWith({double? x, double? y}) => Vec2(x ?? this.x, y ?? this.y);

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  factory Vec2.fromJson(Map<String, dynamic> json) => Vec2(
        (json['x'] as num).toDouble(),
        (json['y'] as num).toDouble(),
      );

  @override
  String toString() => 'Vec2($x, $y)';

  @override
  bool operator ==(Object other) =>
      other is Vec2 && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}