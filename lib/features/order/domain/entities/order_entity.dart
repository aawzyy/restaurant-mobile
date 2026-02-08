// Entity untuk Item di dalam Order (misal: 2x Nasi Goreng)
class OrderItemEntity {
  final int id;
  final String menuName;
  final int quantity;
  final int price; // Harga saat beli
  final String? notes;

  OrderItemEntity({
    required this.id,
    required this.menuName,
    required this.quantity,
    required this.price,
    this.notes,
  });
}

// Entity untuk Order Utama
class OrderEntity {
  final int id;
  final String tableNumber; // Kita simpan nomor meja biar gampang ditampilkan
  final int totalPrice;
  final String status; // pending, processing, done
  final List<OrderItemEntity> items;
  final String createdAt;

  OrderEntity({
    required this.id,
    required this.tableNumber,
    required this.totalPrice,
    required this.status,
    required this.items,
    required this.createdAt,
  });
}
