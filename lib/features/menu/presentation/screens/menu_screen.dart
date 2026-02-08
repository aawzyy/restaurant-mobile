import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../core/di/injection_container.dart';
import '../mobx/menu_store.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final menuStore = sl<MenuStore>();

  @override
  void initState() {
    super.initState();
    menuStore.fetchMenus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Digital Menu")),
      body: Observer(
        builder: (_) {
          if (menuStore.isLoading)
            return const Center(child: CircularProgressIndicator());

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: menuStore.menus.length,
            itemBuilder: (context, index) {
              final menu = menuStore.menus[index];
              return Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(menu.imageUrl, fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        menu.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text("Rp ${menu.price}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
