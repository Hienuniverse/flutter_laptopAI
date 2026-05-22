import 'package:flutter/material.dart';

import '../../../shared/layouts/admin_layout.dart';
import '../../../shared/widgets/admin_pagination.dart';
import '../controllers/admin_order_controller.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  late final AdminOrderController _controller;

  int _currentPage = 1;
  final int _itemsPerPage = 8;

  @override
  void initState() {
    super.initState();
    _controller = AdminOrderController();
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
      title: 'Quản lý đơn hàng',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildFilterBar(),
            const SizedBox(height: 16),
            if (_controller.orderErrorMessage != null) _buildErrorBox(),
            if (_controller.orderErrorMessage != null)
              const SizedBox(height: 12),
            Expanded(child: _buildOrderList()),
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
            'Danh sách đơn hàng',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          tooltip: 'Tải lại',
          onPressed: () {
            setState(() => _currentPage = 1);
            _controller.loadOrders();
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 700) {
          return Row(
            children: [
              Expanded(child: _buildSearchBox()),
              const SizedBox(width: 12),
              SizedBox(width: 220, child: _buildStatusDropdown()),
            ],
          );
        }

        return Column(
          children: [
            _buildSearchBox(),
            const SizedBox(height: 12),
            _buildStatusDropdown(),
          ],
        );
      },
    );
  }

  Widget _buildSearchBox() {
    return TextField(
      onChanged: (value) {
        setState(() => _currentPage = 1);
        _controller.searchOrder(value);
      },
      decoration: InputDecoration(
        hintText: 'Tìm kiếm theo mã đơn, tên khách hàng, số điện thoại...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _controller.selectedStatus,
      decoration: InputDecoration(
        labelText: 'Trạng thái',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: ['Tất cả', ..._controller.orderStatuses].map((status) {
        return DropdownMenuItem(value: status, child: Text(status));
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _currentPage = 1);
          _controller.filterOrderStatus(value);
        }
      },
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
        _controller.orderErrorMessage!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildOrderList() {
    if (_controller.isLoadingOrders) {
      return const Center(child: CircularProgressIndicator());
    }

    final orders = _controller.orders;
    final pagedOrders = _getPagedOrders(orders);

    if (orders.isEmpty) {
      return const Center(child: Text('Không tìm thấy đơn hàng phù hợp'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: pagedOrders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _buildOrderCard(pagedOrders[index]),
          ),
        ),
        const SizedBox(height: 8),
        AdminPagination(
          currentPage: _currentPage,
          totalItems: orders.length,
          itemsPerPage: _itemsPerPage,
          onPageChanged: (page) {
            setState(() => _currentPage = page);
          },
        ),
      ],
    );
  }

  List<AdminOrder> _getPagedOrders(List<AdminOrder> orders) {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= orders.length) {
      return [];
    }

    return orders.sublist(
      startIndex,
      endIndex > orders.length ? orders.length : endIndex,
    );
  }

  Widget _buildOrderCard(AdminOrder order) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderTop(order),
            const Divider(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                Text('Khách hàng: ${order.customerName}'),
                Text('Số điện thoại: ${order.phone}'),
                Text('Ngày đặt: ${order.createdAt}'),
              ],
            ),
            const SizedBox(height: 8),
            Text('Địa chỉ: ${order.address}'),
            const SizedBox(height: 8),
            Text(
              'Tổng tiền: ${_controller.formatCurrency(order.totalAmount)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            _buildOrderItems(order.items),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showOrderDetail(order),
                  icon: const Icon(Icons.visibility),
                  label: const Text('Chi tiết'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showUpdateStatusDialog(order),
                  icon: const Icon(Icons.edit),
                  label: const Text('Cập nhật'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTop(AdminOrder order) {
    return Row(
      children: [
        Expanded(
          child: Text(
            order.id,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _buildStatusBadge(order.status),
      ],
    );
  }

  Widget _buildOrderItems(List<AdminOrderItem> items) {
    if (items.isEmpty) {
      return const Text('Chưa có chi tiết sản phẩm');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '- ${item.productName} x${item.quantity} '
              '(${_controller.formatCurrency(item.price)})',
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;

    switch (status) {
      case 'Hoàn thành':
        color = Colors.green;
        break;
      case 'Đang xử lý':
        color = Colors.orange;
        break;
      case 'Đang giao':
        color = Colors.blue;
        break;
      case 'Đã hủy':
        color = Colors.red;
        break;
      default:
        color = Colors.purple;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  void _showOrderDetail(AdminOrder order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chi tiết đơn hàng ${order.id}'),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Khách hàng: ${order.customerName}'),
                  Text('Số điện thoại: ${order.phone}'),
                  Text('Địa chỉ: ${order.address}'),
                  Text('Ngày đặt: ${order.createdAt}'),
                  const SizedBox(height: 12),
                  _buildOrderItems(order.items),
                  const SizedBox(height: 12),
                  Text(
                    'Tổng tiền: ${_controller.formatCurrency(order.totalAmount)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Trạng thái: ${order.status}'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateStatusDialog(AdminOrder order) {
    String selectedStatus = _normalizeStatus(order.status);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Cập nhật trạng thái ${order.id}'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return DropdownButtonFormField<String>(
                initialValue: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Trạng thái đơn hàng',
                  border: OutlineInputBorder(),
                ),
                items: _controller.orderStatuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => selectedStatus = value);
                  }
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await _controller.updateOrderStatus(
                  order.id,
                  selectedStatus,
                );

                if (!mounted) {
                  return;
                }

                if (success) {
                  Navigator.pop(dialogContext);
                  _showSnackBar('Cập nhật trạng thái thành công');
                } else {
                  _showSnackBar(
                    _controller.orderErrorMessage ?? 'Cập nhật thất bại',
                  );
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  String _normalizeStatus(String status) {
    if (_controller.orderStatuses.contains(status)) {
      return status;
    }

    return 'Chờ xác nhận';
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
