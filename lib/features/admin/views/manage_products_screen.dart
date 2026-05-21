import 'package:flutter/material.dart';

import '../../../shared/layouts/admin_layout.dart';
import '../controllers/admin_product_controller.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  late final AdminProductController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AdminProductController();
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Quản lý laptop',
      // 🛠️ ĐÃ SỬA: Thay đổi thuộc tính 'child:' thành 'body:' để tương thích chuẩn với AdminLayout
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSearchBox(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildProductList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Danh sách laptop',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showProductForm(),
          icon: const Icon(Icons.add),
          label: const Text('Thêm laptop'),
        ),
      ],
    );
  }

  Widget _buildSearchBox() {
    return TextField(
      onChanged: _controller.searchProduct,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm theo tên, hãng, CPU...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    final products = _controller.products;

    if (products.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy laptop phù hợp'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return _buildProductTable(products);
        }

        return _buildProductCards(products);
      },
    );
  }

  Widget _buildProductTable(List<AdminProduct> products) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Mã')),
            DataColumn(label: Text('Tên laptop')),
            DataColumn(label: Text('Hãng')),
            DataColumn(label: Text('CPU')),
            DataColumn(label: Text('RAM')),
            DataColumn(label: Text('Ổ cứng')),
            DataColumn(label: Text('GPU')),
            DataColumn(label: Text('Giá')),
            DataColumn(label: Text('Tồn kho')),
            DataColumn(label: Text('Thao tác')),
          ],
          rows: products.map((product) {
            return DataRow(
              cells: [
                DataRowCellThayThe(product.id),
                DataRowCellThayThe(product.name),
                DataRowCellThayThe(product.brand),
                DataRowCellThayThe(product.cpu),
                DataRowCellThayThe(product.ram),
                DataRowCellThayThe(product.storage),
                DataRowCellThayThe(product.gpu),
                DataRowCellThayThe(_controller.formatCurrency(product.price)),
                DataCell(
                  Text(
                    product.stock.toString(),
                    style: TextStyle(
                      color: product.stock <= 5 ? Colors.red : Colors.black,
                      fontWeight: product.stock <= 5
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Sửa',
                        onPressed: () => _showProductForm(product: product),
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        tooltip: 'Xóa',
                        onPressed: () => _confirmDeleteProduct(product),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProductCards(List<AdminProduct> products) {
    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final product = products[index];

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Mã: ${product.id}'),
                Text('Hãng: ${product.brand}'),
                Text('CPU: ${product.cpu}'),
                Text('RAM: ${product.ram}'),
                Text('Ổ cứng: ${product.storage}'),
                Text('GPU: ${product.gpu}'),
                Text('Giá: ${_controller.formatCurrency(product.price)}'),
                Text(
                  'Tồn kho: ${product.stock}',
                  style: TextStyle(
                    color: product.stock <= 5 ? Colors.red : Colors.black,
                    fontWeight:
                    product.stock <= 5 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showProductForm(product: product),
                      icon: const Icon(Icons.edit),
                      label: const Text('Sửa'),
                    ),
                    TextButton.icon(
                      onPressed: () => _confirmDeleteProduct(product),
                      icon: const Icon(Icons.delete),
                      label: const Text('Xóa'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProductForm({AdminProduct? product}) {
    final isEditing = product != null;

    final nameController = TextEditingController(text: product?.name ?? '');
    final brandController = TextEditingController(text: product?.brand ?? '');
    final cpuController = TextEditingController(text: product?.cpu ?? '');
    final ramController = TextEditingController(text: product?.ram ?? '');
    final storageController = TextEditingController(text: product?.storage ?? '');
    final gpuController = TextEditingController(text: product?.gpu ?? '');
    final priceController = TextEditingController(
      text: product == null ? '' : product.price.toStringAsFixed(0),
    );
    final stockController = TextEditingController(
      text: product == null ? '' : product.stock.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Sửa laptop' : 'Thêm laptop'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInput(nameController, 'Tên laptop'),
                  _buildInput(brandController, 'Hãng'),
                  _buildInput(cpuController, 'CPU'),
                  _buildInput(ramController, 'RAM'),
                  _buildInput(storageController, 'Ổ cứng'),
                  _buildInput(gpuController, 'GPU'),
                  _buildInput(
                    priceController,
                    'Giá',
                    keyboardType: TextInputType.number,
                  ),
                  _buildInput(
                    stockController,
                    'Tồn kho',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final brand = brandController.text.trim();
                final cpu = cpuController.text.trim();
                final ram = ramController.text.trim();
                final storage = storageController.text.trim();
                final gpu = gpuController.text.trim();
                final price = double.tryParse(priceController.text.trim()) ?? 0;
                final stock = int.tryParse(stockController.text.trim()) ?? 0;

                if (name.isEmpty || brand.isEmpty || price <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vui lòng nhập đủ tên, hãng và giá hợp lệ'),
                    ),
                  );
                  return;
                }

                final newProduct = AdminProduct(
                  id: product?.id ?? _controller.generateProductId(),
                  name: name,
                  brand: brand,
                  cpu: cpu,
                  ram: ram,
                  storage: storage,
                  gpu: gpu,
                  price: price,
                  stock: stock,
                );

                if (isEditing) {
                  _controller.updateProduct(newProduct);
                } else {
                  _controller.addProduct(newProduct);
                }

                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInput(
      TextEditingController controller,
      String label, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _confirmDeleteProduct(AdminProduct product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc muốn xóa laptop "${product.name}" không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.deleteProduct(product.id);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }
}

// Helper tránh lỗi vặt chuỗi trống của DataTable Cell
DataCell DataRowCellThayThe(String text) {
  return DataCell(Text(text.isNotEmpty ? text : '---'));
}