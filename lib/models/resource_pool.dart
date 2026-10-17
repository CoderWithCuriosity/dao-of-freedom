class ResourcePool {
  double current;
  double max;
  double regenPerSecond;

  ResourcePool({
    required this.current,
    required this.max,
    this.regenPerSecond = 0,
  });

  double get percent => max == 0 ? 0 : current / max;
  bool get isEmpty => current <= 0;
  bool get isFull => current >= max;

  void consume(double amount) {
    current = (current - amount).clamp(0, max);
  }

  void restore(double amount) {
    current = (current + amount).clamp(0, max);
  }

  void tick(double dt) {
    restore(regenPerSecond * dt);
  }

  Map<String, dynamic> toJson() => {
        'current': current,
        'max': max,
        'regenPerSecond': regenPerSecond,
      };

  factory ResourcePool.fromJson(Map<String, dynamic> json) => ResourcePool(
        current: (json['current'] as num).toDouble(),
        max: (json['max'] as num).toDouble(),
        regenPerSecond: (json['regenPerSecond'] as num?)?.toDouble() ?? 0,
      );
}