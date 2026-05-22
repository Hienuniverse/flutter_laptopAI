import 'package:flutter/material.dart';

import '../../../shared/layouts/admin_layout.dart';
import '../../../shared/widgets/admin_pagination.dart';
import '../controllers/admin_account_controller.dart';

class ManageAccountsScreen extends StatefulWidget {
  const ManageAccountsScreen({super.key});

  @override
  State<ManageAccountsScreen> createState() => _ManageAccountsScreenState();
}

class _ManageAccountsScreenState extends State<ManageAccountsScreen> {
  late final AdminAccountController _controller;

  int _currentPage = 1;
  final int _itemsPerPage = 10;

  final List<String> _roles = const [
    'Admin',
    'Customer',
    'Staff',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AdminAccountController();
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
      title: 'Quản lý tài khoản',
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
            Expanded(
              child: _buildAccountList(),
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
            'Danh sách tài khoản',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Tải lại',
          onPressed: () {
            setState(() {
              _currentPage = 1;
            });
            _controller.loadAccounts();
          },
          icon: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: () => _showAccountForm(),
          icon: const Icon(Icons.add),
          label: const Text('Thêm tài khoản'),
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
        _controller.searchAccount(value);
      },
      decoration: InputDecoration(
        hintText: 'Tìm kiếm theo tên, email, số điện thoại, vai trò...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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

  Widget _buildAccountList() {
    if (_controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final accounts = _controller.accounts;
    final pagedAccounts = _getPagedAccounts(accounts);

    if (accounts.isEmpty) {
      return const Center(
        child: Text('Không có tài khoản hoặc không tìm thấy kết quả phù hợp'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 850) {
                return _buildAccountTable(pagedAccounts);
              }

              return _buildAccountCards(pagedAccounts);
            },
          ),
        ),
        const SizedBox(height: 8),
        AdminPagination(
          currentPage: _currentPage,
          totalItems: accounts.length,
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

  List<AdminAccount> _getPagedAccounts(List<AdminAccount> accounts) {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= accounts.length) {
      return [];
    }

    return accounts.sublist(
      startIndex,
      endIndex > accounts.length ? accounts.length : endIndex,
    );
  }

  Widget _buildAccountTable(List<AdminAccount> accounts) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                  ),
                  child: DataTable(
                    columnSpacing: 32,
                    headingRowHeight: 56,
                    dataRowMinHeight: 56,
                    dataRowMaxHeight: 56,
                    columns: const [
                      DataColumn(label: Text('Mã')),
                      DataColumn(label: Text('Họ tên')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('SĐT')),
                      DataColumn(label: Text('Vai trò')),
                      DataColumn(label: Text('Trạng thái')),
                      DataColumn(label: Text('')),
                    ],
                    rows: accounts.map((account) {
                      return DataRow(
                        cells: [
                          DataCell(Text(account.maTK?.toString() ?? '')),
                          DataCell(
                            SizedBox(
                              width: 180,
                              child: Text(
                                account.hoTen,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 260,
                              child: Text(
                                account.email,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 130,
                              child: Text(
                                account.soDienThoai ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(_buildRoleBadge(account.vaiTro)),
                          DataCell(_buildStatusBadge(account.trangThai)),
                          DataCell(
                            PopupMenuButton<String>(
                              tooltip: 'Thao tác',
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showAccountForm(account: account);
                                }

                                if (value == 'delete') {
                                  _confirmDeleteAccount(account);
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
                                      Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      ),
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
        },
      ),
    );
  }

  Widget _buildAccountCards(List<AdminAccount> accounts) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: accounts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final account = accounts[index];

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
                        account.hoTen,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildStatusBadge(account.trangThai),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Mã TK: ${account.maTK ?? ''}'),
                Text('Email: ${account.email}'),
                Text('Số điện thoại: ${account.soDienThoai ?? ''}'),
                const SizedBox(height: 8),
                _buildRoleBadge(account.vaiTro),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showAccountForm(account: account),
                      icon: const Icon(Icons.edit),
                      label: const Text('Sửa'),
                    ),
                    TextButton.icon(
                      onPressed: account.maTK == null
                          ? null
                          : () => _confirmDeleteAccount(account),
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

  Widget _buildRoleBadge(String role) {
    final normalizedRole = _normalizeRole(role);
    Color color;

    switch (normalizedRole) {
      case 'Admin':
        color = Colors.red;
        break;
      case 'Staff':
        color = Colors.orange;
        break;
      case 'Customer':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        normalizedRole,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    final color = isActive ? Colors.green : Colors.grey;
    final text = isActive ? 'Hoạt động' : 'Khóa';

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

  void _showAccountForm({AdminAccount? account}) {
    final isEditing = account != null;

    final hoTenController = TextEditingController(text: account?.hoTen ?? '');
    final emailController = TextEditingController(text: account?.email ?? '');
    final phoneController = TextEditingController(
      text: account?.soDienThoai ?? '',
    );

    String selectedRole = _normalizeRole(account?.vaiTro);
    bool trangThai = account?.trangThai ?? true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Sửa tài khoản' : 'Thêm tài khoản'),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildInput(hoTenController, 'Họ tên *'),
                      _buildInput(
                        emailController,
                        'Email *',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildInput(
                        phoneController,
                        'Số điện thoại',
                        keyboardType: TextInputType.phone,
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Vai trò',
                          border: OutlineInputBorder(),
                        ),
                        items: _roles.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedRole = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
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
                    final hoTen = hoTenController.text.trim();
                    final email = emailController.text.trim();
                    final phone = phoneController.text.trim();

                    if (hoTen.isEmpty || email.isEmpty) {
                      _showSnackBar('Vui lòng nhập họ tên và email');
                      return;
                    }

                    bool success;

                    if (isEditing) {
                      final maTK = account.maTK;

                      if (maTK == null) {
                        _showSnackBar('Không tìm thấy mã tài khoản');
                        return;
                      }

                      success = await _controller.updateAccount(
                        maTK: maTK,
                        hoTen: hoTen,
                        email: email,
                        soDienThoai: phone.isEmpty ? null : phone,
                        vaiTro: selectedRole,
                        trangThai: trangThai,
                      );
                    } else {
                      success = await _controller.addAccount(
                        hoTen: hoTen,
                        email: email,
                        soDienThoai: phone.isEmpty ? null : phone,
                        vaiTro: selectedRole,
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
                            ? 'Cập nhật tài khoản thành công'
                            : 'Thêm tài khoản thành công',
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

  void _confirmDeleteAccount(AdminAccount account) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa vĩnh viễn'),
          content: Text(
            'Bạn có chắc muốn xóa vĩnh viễn tài khoản "${account.hoTen}" khỏi database không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final maTK = account.maTK;

                if (maTK == null) {
                  _showSnackBar('Không tìm thấy mã tài khoản để xóa');
                  return;
                }

                final success = await _controller.deleteAccount(maTK);

                if (!mounted) {
                  return;
                }

                if (success) {
                  Navigator.pop(dialogContext);
                  _showSnackBar('Đã xóa tài khoản khỏi database');
                } else {
                  _showSnackBar(
                    _controller.errorMessage ?? 'Xóa tài khoản thất bại',
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

  String _normalizeRole(String? role) {
    final text = role?.trim().toLowerCase();

    switch (text) {
      case 'admin':
        return 'Admin';
      case 'staff':
        return 'Staff';
      case 'customer':
      case 'user':
      default:
        return 'Customer';
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}