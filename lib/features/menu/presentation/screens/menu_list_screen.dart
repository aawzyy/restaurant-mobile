import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:cached_network_image/cached_network_image.dart';

// --- DEPENDENCIES INJECTION ---
import '../../../../core/di/injection_container.dart';

// --- STORES ---
import '../mobx/menu_store.dart';
import '../../../order/presentation/mobx/order_store.dart';
import '../../../auth/presentation/mobx/auth_store.dart'; // Import AuthStore

// --- SCREENS ---
import '../../../order/presentation/screens/cart_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart'; // Import LoginScreen

class MenuListScreen extends StatefulWidget {
  const MenuListScreen({super.key});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  // Inject semua Store yang dibutuhkan
  final MenuStore _menuStore = sl<MenuStore>();
  final OrderStore _orderStore = sl<OrderStore>();
  final AuthStore _authStore = sl<AuthStore>();

  @override
  void initState() {
    super.initState();
    // Ambil data awal saat layar dibuka
    _menuStore.fetchMenus();
    _menuStore.fetchCategories();
  }

  // --- LOGIC LOGOUT ---
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Batal
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Tutup Dialog

              // 1. Hapus Token di HP
              await _authStore.logout();

              // 2. Lempar ke Login Screen (Hapus semua history page sebelumnya)
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text(
              "Ya, Keluar",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // --- APP BAR (JUDUL & LOGOUT) ---
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pondok Nusantara",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Text(
              "Lapar? Pesan sekarang!",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.red),
            tooltip: "Logout",
            onPressed: _handleLogout,
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: Column(
        children: [
          // --- 1. SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: (val) => _menuStore.setSearchQuery(val),
              decoration: InputDecoration(
                hintText: "Cari Nasi Goreng, Es Teh...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          // --- 2. CATEGORY FILTER (HORIZONTAL) ---
          _buildCategoryList(),

          // --- 3. GRID MENU (DENGAN PULL TO REFRESH) ---
          Expanded(
            child: Observer(
              builder: (_) {
                // Loading State
                if (_menuStore.isLoading && _menuStore.menus.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.deepOrange),
                  );
                }

                // Ambil data yang sudah difilter oleh Store
                final listMenu = _menuStore.filteredMenus;

                // Empty State (Jika tidak ada menu atau hasil pencarian nihil)
                if (listMenu.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.fastfood_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Menu tidak ditemukan",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                // Grid View + Pull to Refresh
                return RefreshIndicator(
                  color: Colors.deepOrange,
                  onRefresh: () async {
                    // Paksa ambil data baru dari Server (melewati cache lokal app)
                    await _menuStore.fetchMenus(isRetry: true);
                  },
                  child: GridView.builder(
                    // physics ini Wajib agar bisa ditarik walau item sedikit
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: listMenu.length,
                    itemBuilder: (context, index) =>
                        _buildMenuCard(listMenu[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // --- FLOATING CART BUTTON ---
      floatingActionButton: Observer(
        builder: (_) {
          if (_orderStore.totalItems == 0) return const SizedBox();
          return FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
            backgroundColor: Colors.black,
            elevation: 4,
            label: Text(
              "Cart • ${_orderStore.totalItems} Items",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            icon: const Icon(Icons.shopping_basket, color: Colors.white),
          );
        },
      ),
    );
  }

  // --- WIDGET LIST KATEGORI (FIXED COLOR LOGIC) ---
  Widget _buildCategoryList() {
    return SizedBox(
      height: 50, // Tinggi area scroll
      child: Observer(
        builder: (_) {
          if (_menuStore.categories.isEmpty) return const SizedBox();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _menuStore.categories.length + 1, // +1 untuk "All Menu"
            itemBuilder: (context, index) {
              final isAll = index == 0;
              final catId = isAll ? 0 : _menuStore.categories[index - 1].id;
              final catName = isAll
                  ? "All Menu"
                  : _menuStore.categories[index - 1].name;

              // PENTING: Bungkus item dengan Observer lagi
              // Ini agar setiap tombol "sadar" kalau dirinya sedang dipilih/tidak
              return Observer(
                builder: (_) {
                  final isSelected = _menuStore.selectedCategoryId == catId;

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        // Debugging kecil untuk memastikan klik masuk
                        print("Kategori dipilih: $catName (ID: $catId)");
                        _menuStore.setCategory(catId);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          // WARNA TEGAS: Hitam jika dipilih, Putih jika tidak
                          color: isSelected ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.black
                                : Colors.grey[300]!,
                            width: 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          catName,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.w900
                                : FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // --- WIDGET CARD MENU ---
  Widget _buildMenuCard(menu) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GAMBAR MENU
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: menu.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    // Placeholder saat loading gambar
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[100]),
                    // Widget error jika gambar gagal load
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                // Badge Kategori (Pemanis)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      menu.category.name,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // INFO MENU
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rp ${menu.price.toInt()}",
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    // Tombol Add Mini
                    InkWell(
                      onTap: () => _orderStore.addToCart(menu),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
