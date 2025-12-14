import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: greenBgColor,
          foregroundColor: whiteColor,
          title: const Text("Cài Đặt"),
          centerTitle: true,
        ),
        body: Container(
          color: Color(0xFFF4F4F4),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSettingsSection(
                title: "Tài Khoản",
                items: [
                  _buildSettingsItem(
                    icon: Icons.notifications_outlined,
                    title: "Thông Báo",
                    subtitle: "Quản lý thông báo đẩy",
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.lock_outline,
                    title: "Bảo Mật",
                    subtitle: "Đổi mật khẩu, xác thực 2 lớp",
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.privacy_tip_outlined,
                    title: "Quyền Riêng Tư",
                    subtitle: "Cài đặt quyền riêng tư",
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSettingsSection(
                title: "Ứng Dụng",
                items: [
                  _buildSettingsItem(
                    icon: Icons.language,
                    title: "Ngôn Ngữ",
                    subtitle: "Tiếng Việt",
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.dark_mode_outlined,
                    title: "Giao Diện",
                    subtitle: "Sáng / Tối",
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.storage_outlined,
                    title: "Bộ Nhớ",
                    subtitle: "Quản lý bộ nhớ cache",
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSettingsSection(
                title: "Về Ứng Dụng",
                items: [
                  _buildSettingsItem(
                    icon: Icons.info_outline,
                    title: "Phiên Bản",
                    subtitle: "1.0.0",
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.description_outlined,
                    title: "Điều Khoản",
                    subtitle: "Điều khoản sử dụng",
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: greenBgColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
