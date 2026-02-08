import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/di/injection_container.dart';
import '../../../menu/domain/entities/menu_entity.dart';
import '../mobx/order_store.dart';
import '../../../kitchen/presentation/mobx/kitchen_store.dart';
// PENTING: Import TableStore agar bisa direfresh
import '../../../table/presentation/mobx/table_store.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final OrderStore _orderStore = sl<OrderStore>();

  @override
  void initState() {
    super.initState();
    _orderStore.fetchTables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Review Order",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Observer(
        builder: (_) {
          if (_orderStore.cartItems.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              _buildTableSelector(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _orderStore.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _orderStore.cartItems[index];
                    final MenuEntity menu = item['menu'];
                    final int qty = item['qty'];
                    return _buildCartItem(index, menu, qty);
                  },
                ),
              ),
              _buildCheckoutSection(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 80,
            color: Colors.grey[200],
          ),
          const SizedBox(height: 20),
          Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableSelector() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          hint: const Text(
            "Select Table",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          value: _orderStore.selectedTableId,
          icon: const Icon(Icons.expand_more_rounded, color: Colors.black45),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),
          items: _orderStore.tables.map((table) {
            final isAvailable = table.status == 'available';
            return DropdownMenuItem<int>(
              value: table.id,
              enabled: isAvailable || table.id == _orderStore.selectedTableId,
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: isAvailable ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Table ${table.tableNumber}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) =>
              value != null ? _orderStore.selectTable(value) : null,
        ),
      ),
    );
  }

  Widget _buildCartItem(int index, MenuEntity menu, int qty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F1F1), width: 1),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              imageUrl: menu.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(color: Colors.grey[100]),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp ${menu.price.toInt()}",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _qtyBtn(Icons.remove, () => _orderStore.decreaseItem(index)),
                Text(
                  "$qty",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                _qtyBtn(Icons.add, () => _orderStore.addToCart(menu)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Order",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Observer(
                  builder: (_) => Text(
                    "Rp ${_orderStore.totalPrice.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: _orderStore.isLoading ? null : _handleCheckout,
                child: _orderStore.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "PLACE ORDER",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCheckout() async {
    bool success = await _orderStore.submitOrder();
    if (mounted && success) {
      // 1. Refresh Kitchen (KDS)
      try {
        sl<KitchenStore>().fetchKitchenOrders();
      } catch (_) {}

      // 2. Refresh Table (Meja) - INI PERBAIKANNYA
      try {
        sl<TableStore>().fetchTables();
      } catch (_) {}

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Order sent to kitchen! 🔥"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.black87,
        ),
      );
      Navigator.pop(context);
    }
  }
}
