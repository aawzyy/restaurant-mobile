import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.tableNumber,
    required super.totalPrice,
    required super.status,
    required super.items,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      // Mengambil nomor meja dari relasi 'table' (pastikan API Laravel mengirim with('table'))
      tableNumber: json['table'] != null
          ? json['table']['table_number']
          : 'Unknown',
      totalPrice: int.tryParse(json['total_price'].toString()) ?? 0,
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
      // Mapping list items
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class OrderItemModel extends OrderItemEntity {
  OrderItemModel({
    required super.id,
    required super.menuName,
    required super.quantity,
    required super.price,
    super.notes,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? 0,
      // Mengambil nama menu dari relasi 'menu'
      menuName: json['menu'] != null ? json['menu']['name'] : 'Menu Terhapus',
      quantity: json['quantity'] ?? 0,
      price: int.tryParse(json['price_at_purchase'].toString()) ?? 0,
      notes: json['notes'],
    );
  }
}
