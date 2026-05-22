import 'package:flutter/material.dart';

import '../../../data/models/laptop_model.dart';
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
            Expanded(child: _buildProductList()),
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          tooltip: 'Tải lại',
          onPressed: _controller.loadProducts,
          icon: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 8),
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
        hintText: 'Tìm kiếm theo tên, CPU, RAM, ổ cứng, VGA...',
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

  Widget _buildProductList() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final products = _controller.products;

    if (products.isEmpty) {
      return const Center(
        child: Text('Không có laptop hoặc không tìm thấy kết quả phù hợp'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 950) {
          return _buildProductTable(products);
        }

        return _buildProductCards(products);
      },
    );
  }

  Widget _buildProductTable(List<LaptopModel> products) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Mã')),
            DataColumn(label: Text('Tên laptop')),
            DataColumn(label: Text('Mã hãng')),
            DataColumn(label: Text('Mã DM')),
            DataColumn(label: Text('CPU')),
            DataColumn(label: Text('RAM')),
            DataColumn(label: Text('Ổ cứng')),
            DataColumn(label: Text('VGA')),
            DataColumn(label: Text('Giá')),
            DataColumn(label: Text('Tồn kho')),
            DataColumn(label: Text('Trạng thái')),
            DataColumn(label: Text('Thao tác')),
          ],
          rows: products.map((product) {
            return DataRow(
              cells: [
                DataCell(Text(product.maSP?.toString() ?? '')),
                DataCell(
                  SizedBox(
                    width: 220,
                    child: Text(product.tenSP, overflow: TextOverflow.ellipsis),
                  ),
                ),
                DataCell(Text(product.maHang?.toString() ?? '')),
                DataCell(Text(product.maDM?.toString() ?? '')),
                DataCell(Text(product.cpu ?? '')),
                DataCell(Text(product.ram ?? '')),
                DataCell(Text(product.oCung ?? '')),
                DataCell(Text(product.vga ?? '')),
                DataCell(Text(_controller.formatCurrency(product.giaBan))),
                DataCell(
                  Text(
                    product.soLuongTon.toString(),
                    style: TextStyle(
                      color: product.soLuongTon <= 5
                          ? Colors.red
                          : Colors.black,
                      fontWeight: product.soLuongTon <= 5
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                DataCell(_buildStatusBadge(product.trangThai)),
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
                        onPressed: product.maSP == null
                            ? null
                            : () => _confirmDeleteProduct(product),
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

  Widget _buildProductCards(List<LaptopModel> products) {
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.tenSP,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusBadge(product.trangThai),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Mã SP: ${product.maSP ?? ''}'),
                Text('Mã hãng: ${product.maHang ?? ''}'),
                Text('Mã danh mục: ${product.maDM ?? ''}'),
                Text('CPU: ${product.cpu ?? ''}'),
                Text('RAM: ${product.ram ?? ''}'),
                Text('Ổ cứng: ${product.oCung ?? ''}'),
                Text('VGA: ${product.vga ?? ''}'),
                Text('Màn hình: ${product.manHinh ?? ''}'),
                Text('Giá: ${_controller.formatCurrency(product.giaBan)}'),
                Text(
                  'Tồn kho: ${product.soLuongTon}',
                  style: TextStyle(
                    color: product.soLuongTon <= 5 ? Colors.red : Colors.black,
                    fontWeight: product.soLuongTon <= 5
                        ? FontWeight.bold
                        : FontWeight.normal,
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
                      onPressed: product.maSP == null
                          ? null
                          : () => _confirmDeleteProduct(product),
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

  Widget _buildStatusBadge(bool isActive) {
    final color = isActive ? Colors.green : Colors.grey;
    final text = isActive ? 'Đang bán' : 'Đã ẩn';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
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

  void _showProductForm({LaptopModel? product}) {
    final isEditing = product != null;

    final tenSPController = TextEditingController(text: product?.tenSP ?? '');
    final maHangController = TextEditingController(
      text: product?.maHang?.toString() ?? '',
    );
    final maDMController = TextEditingController(
      text: product?.maDM?.toString() ?? '',
    );
    final giaBanController = TextEditingController(
      text: product == null ? '' : product.giaBan.toStringAsFixed(0),
    );
    final soLuongTonController = TextEditingController(
      text: product == null ? '' : product.soLuongTon.toString(),
    );
    final hinhAnhController = TextEditingController(
      text: product?.hinhAnh ?? '',
    );
    final cpuController = TextEditingController(text: product?.cpu ?? '');
    final ramController = TextEditingController(text: product?.ram ?? '');
    final oCungController = TextEditingController(text: product?.oCung ?? '');
    final vgaController = TextEditingController(text: product?.vga ?? '');
    final manHinhController = TextEditingController(
      text: product?.manHinh ?? '',
    );
    final moTaController = TextEditingController(text: product?.moTa ?? '');

    bool trangThai = product?.trangThai ?? true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Sửa laptop' : 'Thêm laptop'),
              content: SizedBox(
                width: 620,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildInput(tenSPController, 'Tên laptop *'),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInput(
                              maHangController,
                              'Mã hãng',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInput(
                              maDMController,
                              'Mã danh mục',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInput(
                              giaBanController,
                              'Giá bán *',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInput(
                              soLuongTonController,
                              'Số lượng tồn',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      _buildInput(hinhAnhController, 'Link hình ảnh'),
                      Row(
                        children: [
                          Expanded(child: _buildInput(cpuController, 'CPU')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInput(ramController, 'RAM')),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInput(oCungController, 'Ổ cứng'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInput(vgaController, 'VGA')),
                        ],
                      ),
                      _buildInput(manHinhController, 'Màn hình'),
                      _buildInput(moTaController, 'Mô tả', maxLines: 3),
                      SwitchListTile(
                        value: trangThai,
                        title: const Text('Đang bán'),
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
                    final tenSP = tenSPController.text.trim();
                    final maHang = int.tryParse(maHangController.text.trim());
                    final maDM = int.tryParse(maDMController.text.trim());
                    final giaBan = _parseDouble(giaBanController.text);
                    final soLuongTon =
                        int.tryParse(soLuongTonController.text.trim()) ?? 0;

                    if (tenSP.isEmpty || giaBan <= 0) {
                      _showSnackBar(
                        'Vui lòng nhập tên laptop và giá bán hợp lệ',
                      );
                      return;
                    }

                    if (isEditing) {
                      final maSP = product.maSP;

                      if (maSP == null) {
                        _showSnackBar('Không tìm thấy mã sản phẩm để cập nhật');
                        return;
                      }

                      await _controller.updateProduct(
                        maSP: maSP,
                        tenSP: tenSP,
                        giaBan: giaBan,
                        soLuongTon: soLuongTon,
                        maHang: maHang,
                        maDM: maDM,
                        cpu: _emptyToNull(cpuController.text),
                        ram: _emptyToNull(ramController.text),
                        oCung: _emptyToNull(oCungController.text),
                        vga: _emptyToNull(vgaController.text),
                        manHinh: _emptyToNull(manHinhController.text),
                        moTa: _emptyToNull(moTaController.text),
                        hinhAnh: _emptyToNull(hinhAnhController.text),
                        trangThai: trangThai,
                      );
                    } else {
                      await _controller.addProduct(
                        tenSP: tenSP,
                        giaBan: giaBan,
                        soLuongTon: soLuongTon,
                        maHang: maHang,
                        maDM: maDM,
                        cpu: _emptyToNull(cpuController.text),
                        ram: _emptyToNull(ramController.text),
                        oCung: _emptyToNull(oCungController.text),
                        vga: _emptyToNull(vgaController.text),
                        manHinh: _emptyToNull(manHinhController.text),
                        moTa: _emptyToNull(moTaController.text),
                        hinhAnh: _emptyToNull(hinhAnhController.text),
                      );
                    }

                    if (!mounted) {
                      return;
                    }

                    Navigator.pop(dialogContext);
                    _showSnackBar(
                      isEditing
                          ? 'Cập nhật laptop thành công'
                          : 'Thêm laptop thành công',
                    );
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

  void _confirmDeleteProduct(LaptopModel product) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text('Bạn có chắc muốn ẩn laptop "${product.tenSP}" không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final maSP = product.maSP;

                if (maSP == null) {
                  _showSnackBar('Không tìm thấy mã sản phẩm để xóa');
                  return;
                }

                await _controller.deleteProduct(maSP);

                if (!mounted) {
                  return;
                }

                Navigator.pop(dialogContext);
                _showSnackBar('Đã ẩn laptop');
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

  double _parseDouble(String value) {
    return double.tryParse(
          value.trim().replaceAll('.', '').replaceAll(',', ''),
        ) ??
        0;
  }

  String? _emptyToNull(String value) {
    final text = value.trim();
    return text.isEmpty ? null : text;
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
