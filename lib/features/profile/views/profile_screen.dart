import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_routes.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository _authRepository = AuthRepository();

  final SupabaseClient _client = Supabase.instance.client;

  late Future<UserModel?> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = _authRepository.getCurrentUser();
  }

  Future<void> _reloadUser() async {
    setState(() {
      _futureUser = _authRepository.getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030A16),
      body: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: _futureUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF5CE1E6),
                ),
              );
            }

            final user = snapshot.data;

            if (user == null) {
              return _notLoggedInView();
            }

            return RefreshIndicator(
              onRefresh: _reloadUser,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _profileHeader(user),
                    const SizedBox(height: 20),
                    _infoCard(user),
                    const SizedBox(height: 20),

                    // 🔥 NÚT CHỈNH SỬA
                    _editProfileButton(user),

                    const SizedBox(height: 12),

                    _logoutButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _notLoggedInView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1528),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF5CE1E6).withAlpha(80),
                ),
              ),
              child: const Icon(
                Icons.person_outline,
                size: 70,
                color: Color(0xFF5CE1E6),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bạn chưa đăng nhập',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đăng nhập để xem thông tin tài khoản.',
              style: TextStyle(
                color: Colors.white.withAlpha(140),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                icon: const Icon(Icons.login),
                label: const Text('Đăng nhập ngay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5CE1E6),
                  foregroundColor: const Color(0xFF030A16),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader(UserModel user) {
    final String userAvatar = user.avatar ?? '';

    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: const Color(0xFF102A45),
          backgroundImage:
          userAvatar.isNotEmpty ? NetworkImage(userAvatar) : null,
          child: userAvatar.isEmpty
              ? const Icon(
            Icons.person,
            size: 50,
            color: Color(0xFF5CE1E6),
          )
              : null,
        ),
        const SizedBox(height: 12),
        Text(
          user.fullName ?? 'Người dùng',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.role,
          style: const TextStyle(
            color: Color(0xFF5CE1E6),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _infoCard(UserModel user) {
    final String userPhone = user.phone ?? '';
    final String userAddress = user.address ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528).withAlpha(180),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withAlpha(20),
        ),
      ),
      child: Column(
        children: [
          _infoItem(
            icon: Icons.email_outlined,
            title: 'Email',
            value: user.email ?? 'Chưa cập nhật',
          ),
          const Divider(color: Colors.white12),
          _infoItem(
            icon: Icons.phone_outlined,
            title: 'Số điện thoại',
            value: userPhone.isNotEmpty
                ? userPhone
                : 'Chưa cập nhật',
          ),
          const Divider(color: Colors.white12),
          _infoItem(
            icon: Icons.location_on_outlined,
            title: 'Địa chỉ',
            value: userAddress.isNotEmpty
                ? userAddress
                : 'Chưa cập nhật',
          ),
          const Divider(color: Colors.white12),
          _infoItem(
            icon: Icons.verified_user_outlined,
            title: 'Vai trò',
            value: user.role,
          ),
        ],
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF5CE1E6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withAlpha(120),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =====================================================
  // 🔥 NÚT CHỈNH SỬA
  // =====================================================

  Widget _editProfileButton(UserModel user) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          _showEditProfileDialog(user);
        },
        icon: const Icon(Icons.edit),
        label: const Text('Chỉnh sửa thông tin'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5CE1E6),
          foregroundColor: const Color(0xFF030A16),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // 🔥 DIALOG CHỈNH SỬA
  // =====================================================

  Future<void> _showEditProfileDialog(
      UserModel user,
      ) async {
    final rootContext = context;

    final nameController =
    TextEditingController(
      text: user.fullName ?? '',
    );

    final phoneController =
    TextEditingController(
      text: user.phone ?? '',
    );

    final addressController =
    TextEditingController(
      text: user.address ?? '',
    );

    bool isSaving = false;

    await showDialog(
      context: rootContext,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
              dialogContext,
              setDialogState,
              ) {
            return AlertDialog(
              backgroundColor:
              const Color(0xFF0B1528),

              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20),
              ),

              title: const Text(
                'Chỉnh sửa thông tin',
                style:
                TextStyle(color: Colors.white),
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _editInput(
                      controller: nameController,
                      label: 'Họ và tên',
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 14),

                    _editInput(
                      controller: phoneController,
                      label: 'Số điện thoại',
                      icon: Icons.phone_outlined,
                    ),

                    const SizedBox(height: 14),

                    _editInput(
                      controller:
                      addressController,
                      label: 'Địa chỉ',
                      icon: Icons
                          .location_on_outlined,
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () {
                    Navigator.of(
                        dialogContext)
                        .pop();
                  },
                  child: const Text(
                    'Hủy',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                    setDialogState(() {
                      isSaving = true;
                    });

                    try {
                      final authUser =
                          _client.auth.currentUser;

                      if (authUser == null ||
                          authUser.email ==
                              null) {
                        throw Exception(
                            'Chưa đăng nhập');
                      }

                      await _client
                          .from('taikhoan')
                          .update({
                        'hoten':
                        nameController.text
                            .trim(),
                        'sodienthoai':
                        phoneController.text
                            .trim(),
                        'diachi':
                        addressController.text
                            .trim(),
                      }).eq(
                        'email',
                        authUser.email!,
                      );

                      await _client.auth
                          .updateUser(
                        UserAttributes(
                          data: {
                            'full_name':
                            nameController
                                .text
                                .trim(),
                            'phone':
                            phoneController
                                .text
                                .trim(),
                            'address':
                            addressController
                                .text
                                .trim(),
                            'role':
                            user.role,
                          },
                        ),
                      );

                      if (!mounted) return;

                      Navigator.of(dialogContext)
                          .pop();

                      ScaffoldMessenger.of(
                          rootContext)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Cập nhật thông tin thành công',
                          ),
                        ),
                      );

                      await _reloadUser();
                    } catch (e) {
                      if (!mounted) return;

                      setDialogState(() {
                        isSaving = false;
                      });

                      ScaffoldMessenger.of(
                          rootContext)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            'Lỗi cập nhật: $e',
                          ),
                        ),
                      );
                    }
                  },

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFF5CE1E6),
                    foregroundColor:
                    const Color(0xFF030A16),
                  ),

                  child: isSaving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color:
                      Color(0xFF030A16),
                    ),
                  )
                      : const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }

  Widget _editInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
        const TextStyle(color: Colors.white70),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF5CE1E6),
        ),
        filled: true,
        fillColor: const Color(0xFF102A45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await _authRepository.logout();

          if (!mounted) return;

          ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content: Text('Đã đăng xuất'),
            ),
          );

          setState(() {
            _futureUser = Future.value(null);
          });
        },

        icon: const Icon(Icons.logout),

        label: const Text('Đăng xuất'),

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          padding:
          const EdgeInsets.symmetric(
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}