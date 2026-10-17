class Item {
  final String id;
  final String name;
  final String description;
  final int quantity;

  const Item({
    required this.id,
    required this.name,
    this.description = '',
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'quantity': quantity,
      };

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        quantity: json['quantity'] as int? ?? 1,
      );
}