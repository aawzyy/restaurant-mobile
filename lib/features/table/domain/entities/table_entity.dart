class TableEntity {
  final int id;
  final String tableNumber;
  final String status; // 'available' | 'occupied'

  TableEntity({
    required this.id,
    required this.tableNumber,
    required this.status,
  });
}
