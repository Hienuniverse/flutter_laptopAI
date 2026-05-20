import 'package:flutter/material.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository _authRepository = AuthRepository();

  late Future<UserModel?> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = _authRepository.getCurrentUser();
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
              return const Center(
                child: Text(
                  'Chưa có thông tin người dùng',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _profileHeader(user),
                  const SizedBox(height: 20),
                  _infoCard(user),
                  const SizedBox(height: 20),
                  _logoutButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _profileHeader(UserModel user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: const Color(0xFF102A45),
          backgroundImage: user.avatar.isNotEmpty
              ? NetworkImage(user.avatar)
              : null,
          child: user.avatar.isEmpty
              ? const Icon(
            Icons.person,
            size: 50,
            color: Color(0xFF5CE1E6),
          )
              : null,
        ),
        const SizedBox(height: 12),
        Text(
          user.fullName,
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
            value: user.email,
          ),
          const Divider(color: Colors.white12),
          _infoItem(
            icon: Icons.phone_outlined,
            title: 'Số điện thoại',
            value: user.phone.isNotEmpty ? user.phone : 'Chưa cập nhật',
          ),
          const Divider(color: Colors.white12),
          _infoItem(
            icon: Icons.location_on_outlined,
            title: 'Địa chỉ',
            value: user.address.isNotEmpty ? user.address : 'Chưa cập nhật',
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
            crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await _authRepository.logout();

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã đăng xuất'),
            ),
          );
        },
        icon: const Icon(Icons.logout),
        label: const Text('Đăng xuất'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
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
}