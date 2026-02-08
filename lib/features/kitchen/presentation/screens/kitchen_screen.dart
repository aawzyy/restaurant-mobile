import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../core/di/injection_container.dart';
import '../mobx/kitchen_store.dart';
import '../../../order/domain/entities/order_entity.dart';
// IMPORT TableStore untuk sinkronisasi status meja
import '../../../table/presentation/mobx/table_store.dart';

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  final KitchenStore _store = sl<KitchenStore>();

  @override
  void initState() {
    super.initState();
    _store.startAutoRefresh();
  }

  @override
  void dispose() {
    _store.stopAutoRefresh();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Kitchen Hub",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () => _store.fetchKitchenOrders(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(), // Section Filter & Search

          Expanded(
            child: Observer(
              builder: (_) {
                // LOGIC: Jika kosong (tapi search aktif) vs Kosong total
                if (_store.filteredOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _store.activeOrders.isEmpty
                              ? Icons.check_circle_outline
                              : Icons.search_off,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _store.activeOrders.isEmpty
                              ? "All orders completed!"
                              : "No matching orders found.",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                // Render List
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _store.filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = _store.filteredOrders[index];
                    return _buildOrderCard(order);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET 1: Search Bar & Filter Chips ---
  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: (val) => _store.setSearchQuery(val),
            decoration: InputDecoration(
              hintText: "Search Table No. or Menu Name...",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('All Orders', 'all'),
                const SizedBox(width: 8),
                _filterChip('Pending', 'pending', color: Colors.red),
                const SizedBox(width: 8),
                _filterChip('Cooking', 'processing', color: Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String statusKey, {Color? color}) {
    return Observer(
      builder: (_) {
        final isSelected = _store.filterStatus == statusKey;
        final activeColor = color ?? Colors.black;

        return GestureDetector(
          onTap: () => _store.setFilterStatus(statusKey),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? activeColor : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? activeColor : Colors.grey[300]!,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET 2: Order Card (LENGKAP) ---
  Widget _buildOrderCard(OrderEntity order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F1F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Card: Nomor Meja & Status
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.table_restaurant,
                      size: 20,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "TABLE ${order.tableNumber}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                _buildStatusTag(order.status),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F1F1)),

          // List Items
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: order.items.map((item) {
                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    item.menuName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: item.notes != null && item.notes != "-"
                      ? Text(
                          "Note: ${item.notes}",
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                          ),
                        )
                      : null,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "x${item.quantity}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Action Button
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  // Logic: Pending -> Processing -> Done
                  final nextStatus = order.status == 'pending'
                      ? 'processing'
                      : 'done';

                  // Panggil Store Kitchen
                  await _store.updateStatus(order.id, nextStatus);

                  // JIKA STATUS SELESAI -> Update Status Meja jadi Available
                  if (nextStatus == 'done') {
                    try {
                      await sl<TableStore>().fetchTables();
                    } catch (e) {
                      debugPrint("Failed to sync table status: $e");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: order.status == 'pending'
                      ? Colors.blue[700] // Warna Tombol Masak
                      : Colors.green[700], // Warna Tombol Selesai
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      order.status == 'pending'
                          ? Icons.soup_kitchen
                          : Icons.check_circle,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      order.status == 'pending'
                          ? "START COOKING"
                          : "MARK AS SERVED",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color bgColor = status == 'pending' ? Colors.red[50]! : Colors.orange[50]!;
    Color textColor = status == 'pending'
        ? Colors.red[700]!
        : Colors.orange[700]!;

    // Icon Logic
    IconData icon = status == 'pending'
        ? Icons.timer
        : Icons.local_fire_department;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
