import '../../../table/domain/entities/table_entity.dart';

class TableModel extends TableEntity {
  TableModel({
    required super.id,
    required super.tableNumber,
    required super.status,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] ?? 0,
      tableNumber: json['table_number'] ?? 'Unknown',
      status: json['status'] ?? 'available',
    );
  }
}
