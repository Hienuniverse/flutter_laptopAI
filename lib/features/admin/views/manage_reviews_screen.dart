import 'package:flutter/material.dart';

import '../../../shared/layouts/admin_layout.dart';
import '../controllers/admin_order_controller.dart';

class ManageReviewsScreen extends StatefulWidget {
  const ManageReviewsScreen({super.key});

  @override
  State<ManageReviewsScreen> createState() => _ManageReviewsScreenState();
}

class _ManageReviewsScreenState extends State<ManageReviewsScreen> {
  late final AdminOrderController _controller;

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
      title: 'Quản lý đánh giá',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSearchBox(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildReviewList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Danh sách đánh giá',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return TextField(
      onChanged: _controller.searchReview,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm theo khách hàng, sản phẩm, nội dung...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildReviewList() {
    final reviews = _controller.reviews;

    if (reviews.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy đánh giá phù hợp'),
      );
    }

    return ListView.separated(
      itemCount: reviews.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildReviewCard(reviews[index]);
      },
    );
  }

  Widget _buildReviewCard(AdminReview review) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReviewTop(review),
            const SizedBox(height: 8),
            Text('Khách hàng: ${review.customerName}'),
            Text('Sản phẩm: ${review.productName}'),
            Text('Ngày đánh giá: ${review.createdAt}'),
            const SizedBox(height: 8),
            _buildRating(review.rating),
            const SizedBox(height: 8),
            Text(
              review.comment,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    _controller.toggleReviewVisibility(review.id);
                  },
                  icon: Icon(
                    review.isVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  label: Text(review.isVisible ? 'Ẩn' : 'Hiện'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _confirmDeleteReview(review),
                  icon: const Icon(Icons.delete),
                  label: const Text('Xóa'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewTop(AdminReview review) {
    return Row(
      children: [
        Expanded(
          child: Text(
            review.id,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildVisibilityBadge(review.isVisible),
      ],
    );
  }

  Widget _buildVisibilityBadge(bool isVisible) {
    final color = isVisible ? Colors.green : Colors.grey;
    final text = isVisible ? 'Đang hiển thị' : 'Đã ẩn';

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
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRating(int rating) {
    return Row(
      children: [
        const Text(
          'Đánh giá: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...List.generate(5, (index) {
          return Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 20,
          );
        }),
      ],
    );
  }

  void _confirmDeleteReview(AdminReview review) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc muốn xóa đánh giá của "${review.customerName}" không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.deleteReview(review.id);
                Navigator.pop(context);
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
}