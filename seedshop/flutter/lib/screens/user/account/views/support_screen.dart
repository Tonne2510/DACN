import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: greenBgColor,
          foregroundColor: whiteColor,
          title: const Text("Trợ Giúp & Hỗ Trợ"),
          centerTitle: true,
        ),
        body: Container(
          color: Color(0xFFF4F4F4),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSupportSection(
                title: "Liên Hệ",
                items: [
                  _buildSupportItem(
                    icon: Icons.phone_outlined,
                    title: "Hotline",
                    subtitle: "1900-xxxx (8:00 - 22:00)",
                    onTap: () {},
                  ),
                  _buildSupportItem(
                    icon: Icons.email_outlined,
                    title: "Email",
                    subtitle: "support@seedshop.vn",
                    onTap: () {},
                  ),
                  _buildSupportItem(
                    icon: Icons.chat_bubble_outline,
                    title: "Live Chat",
                    subtitle: "Chat trực tuyến với tư vấn viên",
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSupportSection(
                title: "Câu Hỏi Thường Gặp",
                items: [
                  _buildSupportItem(
                    icon: Icons.shopping_bag_outlined,
                    title: "Đặt Hàng",
                    subtitle: "Hướng dẫn đặt hàng và thanh toán",
                    onTap: () {},
                  ),
                  _buildSupportItem(
                    icon: Icons.local_shipping_outlined,
                    title: "Giao Hàng",
                    subtitle: "Chính sách và thời gian giao hàng",
                    onTap: () {},
                  ),
                  _buildSupportItem(
                    icon: Icons.assignment_return_outlined,
                    title: "Đổi Trả",
                    subtitle: "Chính sách đổi trả sản phẩm",
                    onTap: () {},
                  ),
                  _buildSupportItem(
                    icon: Icons.payment_outlined,
                    title: "Thanh Toán",
                    subtitle: "Các hình thức thanh toán",
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSupportSection(
                title: "Hướng Dẫn",
                items: [
                  _buildSupportItem(
                    icon: Icons.help_outline,
                    title: "Hướng Dẫn Sử Dụng",
                    subtitle: "Cách sử dụng ứng dụng",
                    onTap: () {},
                  ),
                  _buildSupportItem(
                    icon: Icons.agriculture_outlined,
                    title: "Chăm Sóc Cây Trồng",
                    subtitle: "Hướng dẫn trồng và chăm sóc",
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFE8F5E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: greenBgColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.support_agent,
                      size: 50,
                      color: greenBgColor,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Chúng Tôi Luôn Sẵn Sàng Hỗ Trợ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Đội ngũ hỗ trợ của chúng tôi sẵn sàng giải đáp mọi thắc mắc của bạn 24/7",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportSection({
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

  Widget _buildSupportItem({
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
