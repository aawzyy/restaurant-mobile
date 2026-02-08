import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injection_container.dart';
import '../mobx/menu_store.dart';

class AddMenuScreen extends StatefulWidget {
  const AddMenuScreen({super.key});

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  final _menuStore = sl<MenuStore>();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  int? _selectedCategoryId;
  File? _selectedImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Mengambil daftar kategori saat layar dibuka agar dropdown terisi
    _menuStore.fetchCategories();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Kompresi gambar untuk efisiensi upload
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data dan pilih kategori")),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mohon pilih foto menu terlebih dahulu")),
      );
      return;
    }

    // Eksekusi use case createMenu melalui Store
    await _menuStore.addMenu(
      name: _nameController.text,
      description: _descController.text,
      price: double.parse(_priceController.text),
      categoryId: _selectedCategoryId!,
      imageFile: _selectedImage,
    );

    if (_menuStore.errorMessage == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Menu berhasil ditambahkan!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(
        context,
      ); // Kembali dan memicu refresh di halaman sebelumnya
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Menu Baru"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Picker Gambar Menu
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              Text("Ketuk untuk memilih foto"),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Dropdown Kategori
              const Text(
                "Kategori",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Observer(
                builder: (_) => DropdownButtonFormField<int>(
                  value: _selectedCategoryId,
                  hint: const Text("Pilih Kategori"),
                  items: _menuStore.categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat.id,
                      child: Text(cat.name),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                  validator: (val) =>
                      val == null ? "Kategori wajib dipilih" : null,
                ),
              ),
              const SizedBox(height: 20),

              // Input Nama
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Menu",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant),
                ),
                validator: (val) =>
                    val!.isEmpty ? "Nama menu wajib diisi" : null,
              ),
              const SizedBox(height: 20),

              // Input Harga
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga (Rp)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (val) =>
                    val!.isEmpty ? "Harga menu wajib diisi" : null,
              ),
              const SizedBox(height: 20),

              // Input Deskripsi
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Deskripsi (Opsional)",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              Observer(
                builder: (_) => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _menuStore.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _menuStore.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "SIMPAN KE DAFTAR MENU",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
