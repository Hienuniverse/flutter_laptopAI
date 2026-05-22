import 'package:flutter/material.dart';

import '../../../data/models/category_model.dart';
import '../../../shared/layouts/admin_layout.dart';
import '../../../shared/widgets/admin_pagination.dart';
import '../controllers/admin_category_controller.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  late final AdminCategoryController _controller;

  int _currentPage = 1;
  final int _itemsPerPage = 10;

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
          onPressed: () {
            setState(() {
              _currentPage = 1;
            });
            _controller.loadCategories();
          },
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
      onChanged: (value) {
        setState(() {
          _currentPage = 1;
        });
        _controller.searchCategory(value);
      },
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
    final pagedCategories = _getPagedCategories(categories);

    if (categories.isEmpty) {
      return const Center(
        child: Text('Không có danh mục hoặc không tìm thấy kết quả phù hợp'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 850) {
                return _buildCategoryTable(pagedCategories);
              }

              return _buildCategoryCards(pagedCategories);
            },
          ),
        ),
        const SizedBox(height: 8),
        AdminPagination(
          currentPage: _currentPage,
          totalItems: categories.length,
          itemsPerPage: _itemsPerPage,
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
        ),
      ],
    );
  }

  List<CategoryModel> _getPagedCategories(List<CategoryModel> categories) {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= categories.length) {
      return [];
    }

    return categories.sublist(
      startIndex,
      endIndex > categories.length ? categories.length : endIndex,
    );
  }

  Widget _buildCategoryTable(List<CategoryModel> categories) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 28,
              headingRowHeight: 56,
              dataRowMinHeight: 52,
              dataRowMaxHeight: 52,
              columns: const [
                DataColumn(label: Text('Mã DM')),
                DataColumn(label: Text('Tên danh mục')),
                DataColumn(label: Text('Mô tả')),
                DataColumn(label: Text('Slug')),
                DataColumn(label: Text('Icon')),
                DataColumn(label: Text('Màu')),
                DataColumn(label: Text('TT')),
                DataColumn(label: Text('')),
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
                        width: 260,
                        child: Text(
                          category.moTa ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(Text(category.slug ?? '')),
                    DataCell(Text(category.icon)),
                    DataCell(Text(category.colorClass)),
                    DataCell(_buildStatusBadge(category.trangThai)),
                    DataCell(
                      PopupMenuButton<String>(
                        tooltip: 'Thao tác',
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showCategoryForm(category: category);
                          }

                          if (value == 'delete') {
                            _confirmDeleteCategory(category);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Sửa'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_forever, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Xóa vĩnh viễn'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCards(List<CategoryModel> categories) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final category = categories[index];

        return Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.tenDM,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusBadge(category.trangThai),
                  ],
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
                      icon: const Icon(Icons.delete_forever),
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

  Widget _buildStatusBadge(bool isActive) {
    final color = isActive ? Colors.green : Colors.grey;
    final text = isActive ? 'Hoạt động' : 'Ngưng';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
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

    bool trangThai = category?.trangThai ?? true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
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
                      SwitchListTile(
                        value: trangThai,
                        title: const Text('Hoạt động'),
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          setDialogState(() {
                            trangThai = value;
                          });
                        },
                      ),
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

                    bool success;

                    if (isEditing) {
                      final maDM = category.maDM;

                      if (maDM == null) {
                        _showSnackBar('Không tìm thấy mã danh mục để cập nhật');
                        return;
                      }

                      success = await _controller.updateCategory(
                        maDM: maDM,
                        tenDM: tenDM,
                        moTa: _emptyToNull(moTaController.text),
                        slug: _emptyToNull(slugController.text),
                        icon: _emptyToDefault(
                          iconController.text,
                          'FolderTree',
                        ),
                        colorClass: _emptyToDefault(
                          colorClassController.text,
                          'cyan',
                        ),
                        trangThai: trangThai,
                      );
                    } else {
                      success = await _controller.addCategory(
                        tenDM: tenDM,
                        moTa: _emptyToNull(moTaController.text),
                        slug: _emptyToNull(slugController.text),
                        icon: _emptyToDefault(
                          iconController.text,
                          'FolderTree',
                        ),
                        colorClass: _emptyToDefault(
                          colorClassController.text,
                          'cyan',
                        ),
                        trangThai: trangThai,
                      );
                    }

                    if (!mounted) {
                      return;
                    }

                    if (success) {
                      Navigator.pop(dialogContext);
                      _showSnackBar(
                        isEditing
                            ? 'Cập nhật danh mục thành công'
                            : 'Thêm danh mục thành công',
                      );
                    } else {
                      _showSnackBar(
                        _controller.errorMessage ?? 'Thao tác thất bại',
                      );
                    }
                  },
                  child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
                ),
              ],
            );
          },
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
          title: const Text('Xác nhận xóa vĩnh viễn'),
          content: Text(
            'Bạn có chắc muốn xóa vĩnh viễn danh mục "${category.tenDM}" khỏi database không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final maDM = category.maDM;

                if (maDM == null) {
                  _showSnackBar('Không tìm thấy mã danh mục để xóa');
                  return;
                }

                final success = await _controller.deleteCategory(maDM);

                if (!mounted) {
                  return;
                }

                if (success) {
                  Navigator.pop(dialogContext);
                  _showSnackBar('Đã xóa danh mục khỏi database');
                } else {
                  _showSnackBar(
                    _controller.errorMessage ?? 'Xóa danh mục thất bại',
                  );
                }
              },
              icon: const Icon(Icons.delete_forever),
              label: const Text('Xóa vĩnh viễn'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
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
