import 'package:flutter/material.dart';

import '../../../data/models/category_model.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSearchBox(),
            const SizedBox(height: 16),
            if (_controller.errorMessage != null) _buildErrorBox(),
            if (_controller.errorMessage != null) const SizedBox(height: 12),
            Expanded(child: _buildCategoryList()),
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          tooltip: 'Tải lại',
          onPressed: _controller.loadCategories,
          icon: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 8),
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
        hintText: 'Tìm kiếm theo tên hoặc mô tả danh mục...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildErrorBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        _controller.errorMessage!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildCategoryList() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final categories = _controller.categories;

    if (categories.isEmpty) {
      return const Center(
        child: Text('Không có danh mục hoặc không tìm thấy kết quả phù hợp'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 850) {
          return _buildCategoryTable(categories);
        }

        return _buildCategoryCards(categories);
      },
    );
  }

  Widget _buildCategoryTable(List<CategoryModel> categories) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Mã DM')),
            DataColumn(label: Text('Tên danh mục')),
            DataColumn(label: Text('Mô tả')),
            DataColumn(label: Text('Slug')),
            DataColumn(label: Text('Icon')),
            DataColumn(label: Text('Màu')),
            DataColumn(label: Text('Thao tác')),
          ],
          rows: categories.map((category) {
            return DataRow(
              cells: [
                DataCell(Text(category.maDM?.toString() ?? '')),
                DataCell(
                  SizedBox(
                    width: 180,
                    child: Text(
                      category.tenDM,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 320,
                    child: Text(
                      category.moTa ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(category.slug ?? '')),
                DataCell(Text(category.icon)),
                DataCell(Text(category.colorClass)),
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
                        onPressed: category.maDM == null
                            ? null
                            : () => _confirmDeleteCategory(category),
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

  Widget _buildCategoryCards(List<CategoryModel> categories) {
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
                  category.tenDM,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Mã DM: ${category.maDM ?? ''}'),
                Text('Mô tả: ${category.moTa ?? ''}'),
                Text('Slug: ${category.slug ?? ''}'),
                Text('Icon: ${category.icon}'),
                Text('Màu: ${category.colorClass}'),
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
                      onPressed: category.maDM == null
                          ? null
                          : () => _confirmDeleteCategory(category),
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

  void _showCategoryForm({CategoryModel? category}) {
    final isEditing = category != null;

    final tenDMController = TextEditingController(text: category?.tenDM ?? '');
    final moTaController = TextEditingController(text: category?.moTa ?? '');
    final slugController = TextEditingController(text: category?.slug ?? '');
    final iconController = TextEditingController(
      text: category?.icon ?? 'FolderTree',
    );
    final colorClassController = TextEditingController(
      text: category?.colorClass ?? 'cyan',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isEditing ? 'Sửa danh mục' : 'Thêm danh mục'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInput(tenDMController, 'Tên danh mục *'),
                  _buildInput(moTaController, 'Mô tả', maxLines: 3),
                  _buildInput(slugController, 'Slug'),
                  _buildInput(iconController, 'Icon'),
                  _buildInput(colorClassController, 'Color class'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final tenDM = tenDMController.text.trim();

                if (tenDM.isEmpty) {
                  _showSnackBar('Vui lòng nhập tên danh mục');
                  return;
                }

                if (isEditing) {
                  final maDM = category.maDM;

                  if (maDM == null) {
                    _showSnackBar('Không tìm thấy mã danh mục để cập nhật');
                    return;
                  }

                  await _controller.updateCategory(
                    maDM: maDM,
                    tenDM: tenDM,
                    moTa: _emptyToNull(moTaController.text),
                    slug: _emptyToNull(slugController.text),
                    icon: _emptyToDefault(iconController.text, 'FolderTree'),
                    colorClass: _emptyToDefault(
                      colorClassController.text,
                      'cyan',
                    ),
                  );
                } else {
                  await _controller.addCategory(
                    tenDM: tenDM,
                    moTa: _emptyToNull(moTaController.text),
                    slug: _emptyToNull(slugController.text),
                    icon: _emptyToDefault(iconController.text, 'FolderTree'),
                    colorClass: _emptyToDefault(
                      colorClassController.text,
                      'cyan',
                    ),
                  );
                }

                if (!mounted) {
                  return;
                }

                Navigator.pop(dialogContext);
                _showSnackBar(
                  isEditing
                      ? 'Cập nhật danh mục thành công'
                      : 'Thêm danh mục thành công',
                );
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
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _confirmDeleteCategory(CategoryModel category) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc muốn ẩn danh mục "${category.tenDM}" không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final maDM = category.maDM;

                if (maDM == null) {
                  _showSnackBar('Không tìm thấy mã danh mục để xóa');
                  return;
                }

                await _controller.deleteCategory(maDM);

                if (!mounted) {
                  return;
                }

                Navigator.pop(dialogContext);
                _showSnackBar('Đã ẩn danh mục');
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

  String? _emptyToNull(String value) {
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  String _emptyToDefault(String value, String defaultValue) {
    final text = value.trim();
    return text.isEmpty ? defaultValue : text;
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
