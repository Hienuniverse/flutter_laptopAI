import 'package:flutter/material.dart';

import '../../../shared/layouts/admin_layout.dart';
import '../controllers/admin_category_controller.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  late final AdminCategoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AdminCategoryController();
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
      title: 'Quản lý danh mục',
      // 🛠️ ĐÃ SỬA: Thay thế thuộc tính 'child:' thành 'body:' để khớp với cấu trúc AdminLayout của đồ án
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSearchBox(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildCategoryList(),
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
            'Danh sách danh mục',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showCategoryForm(),
          icon: const Icon(Icons.add),
          label: const Text('Thêm danh mục'),
        ),
      ],
    );
  }

  Widget _buildSearchBox() {
    return TextField(
      onChanged: _controller.searchCategory,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm danh mục...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    final categories = _controller.categories;

    if (categories.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy danh mục phù hợp'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          return _buildCategoryTable(categories);
        }

        return _buildCategoryCards(categories);
      },
    );
  }

  Widget _buildCategoryTable(List<AdminCategory> categories) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Mã')),
            DataColumn(label: Text('Tên danh mục')),
            DataColumn(label: Text('Mô tả')),
            DataColumn(label: Text('Số sản phẩm')),
            DataColumn(label: Text('Thao tác')),
          ],
          rows: categories.map((category) {
            return DataRow(
              cells: [
                DataCell(Text(category.id)),
                DataCell(Text(category.name)),
                DataCell(
                  SizedBox(
                    width: 320,
                    child: Text(
                      category.description,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(category.productCount.toString())),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Sửa',
                        onPressed: () => _showCategoryForm(category: category),
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        tooltip: 'Xóa',
                        onPressed: () => _confirmDeleteCategory(category),
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

  Widget _buildCategoryCards(List<AdminCategory> categories) {
    return ListView.separated(
      itemCount: categories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final category = categories[index];

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Mã: ${category.id}'),
                Text('Mô tả: ${category.description}'),
                Text('Số sản phẩm: ${category.productCount}'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showCategoryForm(category: category),
                      icon: const Icon(Icons.edit),
                      label: const Text('Sửa'),
                    ),
                    TextButton.icon(
                      onPressed: () => _confirmDeleteCategory(category),
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

  void _showCategoryForm({AdminCategory? category}) {
    final isEditing = category != null;

    final nameController = TextEditingController(text: category?.name ?? '');
    final descriptionController = TextEditingController(
      text: category?.description ?? '',
    );
    final productCountController = TextEditingController(
      text: category == null ? '0' : category.productCount.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Sửa danh mục' : 'Thêm danh mục'),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInput(nameController, 'Tên danh mục'),
                  _buildInput(
                    descriptionController,
                    'Mô tả',
                    maxLines: 3,
                  ),
                  _buildInput(
                    productCountController,
                    'Số sản phẩm',
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
                final description = descriptionController.text.trim();
                final productCount =
                    int.tryParse(productCountController.text.trim()) ?? 0;

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vui lòng nhập tên danh mục'),
                    ),
                  );
                  return;
                }

                final newCategory = AdminCategory(
                  id: category?.id ?? _controller.generateCategoryId(),
                  name: name,
                  description: description,
                  productCount: productCount,
                );

                if (isEditing) {
                  _controller.updateCategory(newCategory);
                } else {
                  _controller.addCategory(newCategory);
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
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _confirmDeleteCategory(AdminCategory category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc muốn xóa danh mục "${category.name}" không?',
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
                _controller.deleteCategory(category.id);
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