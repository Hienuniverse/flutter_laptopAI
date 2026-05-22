import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_routes.dart';
import '../../../shared/layouts/admin_layout.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final SupabaseClient _client = Supabase.instance.client;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _roleController;

  bool _isSaving = false;

  User? get _user => _client.auth.currentUser;

  @override
  void initState() {
    super.initState();

    final metadata = _user?.userMetadata ?? {};

    _nameController = TextEditingController(
      text: metadata['full_name']?.toString() ?? 'Admin',
    );
    _phoneController = TextEditingController(
      text: metadata['phone']?.toString() ?? '',
    );
    _roleController = TextEditingController(
      text: metadata['role']?.toString() ?? 'Admin',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Cài đặt quản trị',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            const SizedBox(height: 16),
            _buildAccountCard(),
            const SizedBox(height: 16),
            _buildSystemCard(),
            const SizedBox(height: 16),
            _buildActionCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cài đặt Admin',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Quản lý thông tin quản trị viên và trạng thái kết nối hệ thống.',
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              icon: Icons.account_circle_outlined,
              title: 'Thông tin tài khoản',
            ),
            const SizedBox(height: 16),
            _buildReadOnlyInfo(
              label: 'Email đăng nhập',
              value: _user?.email ?? 'Chưa đăng nhập Supabase Auth',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tên quản trị viên',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _roleController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Vai trò',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _updateAdminProfile,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Đang lưu...' : 'Lưu thông tin'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemCard() {
    final isLoggedIn = _user != null;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              icon: Icons.storage_outlined,
              title: 'Trạng thái hệ thống',
            ),
            const SizedBox(height: 16),
            _buildStatusRow(
              title: 'Supabase',
              description: 'Ứng dụng đã khởi tạo Supabase client',
              isOk: true,
            ),
            const Divider(),
            _buildStatusRow(
              title: 'Auth',
              description: isLoggedIn
                  ? 'Đã có người dùng đăng nhập'
                  : 'Chưa có người dùng đăng nhập',
              isOk: isLoggedIn,
            ),
            const Divider(),
            _buildStatusRow(
              title: 'Database',
              description:
                  'Dashboard đang đọc bảng sanpham, donhang và taikhoan',
              isOk: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle(
              icon: Icons.admin_panel_settings_outlined,
              title: 'Thao tác nhanh',
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.adminDashboard,
                );
              },
              icon: const Icon(Icons.dashboard_outlined),
              label: const Text('Về Dashboard'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.adminProducts,
                );
              },
              icon: const Icon(Icons.laptop_mac_outlined),
              label: const Text('Quản lý sản phẩm'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Đăng xuất'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildReadOnlyInfo({required String label, required String value}) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: Text(value),
    );
  }

  Widget _buildStatusRow({
    required String title,
    required String description,
    required bool isOk,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: isOk
              ? Colors.green.withValues(alpha: 0.12)
              : Colors.red.withValues(alpha: 0.12),
          child: Icon(
            isOk ? Icons.check : Icons.close,
            color: isOk ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(description),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _updateAdminProfile() async {
    if (_user == null) {
      _showSnackBar('Bạn chưa đăng nhập, không thể cập nhật thông tin');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _client.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': _nameController.text.trim(),
            'phone': _phoneController.text.trim(),
            'role': _roleController.text.trim().isEmpty
                ? 'Admin'
                : _roleController.text.trim(),
          },
        ),
      );

      _showSnackBar('Cập nhật thông tin admin thành công');
    } catch (e) {
      _showSnackBar('Không thể cập nhật thông tin admin: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    try {
      await _client.auth.signOut();

      if (!mounted) {
        return;
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } catch (e) {
      _showSnackBar('Đăng xuất thất bại: $e');
    }
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
