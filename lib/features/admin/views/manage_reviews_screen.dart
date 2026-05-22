import 'package:flutter/material.dart';

import '../../../shared/layouts/admin_layout.dart';
import '../../../shared/widgets/admin_pagination.dart';
import '../controllers/admin_order_controller.dart';

class ManageReviewsScreen extends StatefulWidget {
  const ManageReviewsScreen({super.key});

  @override
  State<ManageReviewsScreen> createState() => _ManageReviewsScreenState();
}

class _ManageReviewsScreenState extends State<ManageReviewsScreen> {
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
      title: 'Quản lý đánh giá',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSearchBox(),
            const SizedBox(height: 16),
            if (_controller.reviewErrorMessage != null) _buildErrorBox(),
            if (_controller.reviewErrorMessage != null)
              const SizedBox(height: 12),
            Expanded(child: _buildReviewList()),
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
            'Danh sách đánh giá',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          tooltip: 'Tải lại',
          onPressed: () {
            setState(() => _currentPage = 1);
            _controller.loadReviews();
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildSearchBox() {
    return TextField(
      onChanged: (value) {
        setState(() => _currentPage = 1);
        _controller.searchReview(value);
      },
      decoration: InputDecoration(
        hintText: 'Tìm kiếm theo khách hàng, sản phẩm, nội dung...',
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
        _controller.reviewErrorMessage!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildReviewList() {
    if (_controller.isLoadingReviews) {
      return const Center(child: CircularProgressIndicator());
    }

    final reviews = _controller.reviews;
    final pagedReviews = _getPagedReviews(reviews);

    if (reviews.isEmpty) {
      return const Center(child: Text('Không tìm thấy đánh giá phù hợp'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: pagedReviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _buildReviewCard(pagedReviews[index]),
          ),
        ),
        const SizedBox(height: 8),
        AdminPagination(
          currentPage: _currentPage,
          totalItems: reviews.length,
          itemsPerPage: _itemsPerPage,
          onPageChanged: (page) {
            setState(() => _currentPage = page);
          },
        ),
      ],
    );
  }

  List<AdminReview> _getPagedReviews(List<AdminReview> reviews) {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;

    if (startIndex >= reviews.length) {
      return [];
    }

    return reviews.sublist(
      startIndex,
      endIndex > reviews.length ? reviews.length : endIndex,
    );
  }

  Widget _buildReviewCard(AdminReview review) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReviewTop(review),
            const SizedBox(height: 8),
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                Text('Khách hàng: ${review.customerName}'),
                Text('Sản phẩm: ${review.productName}'),
                Text('Ngày đánh giá: ${review.createdAt}'),
              ],
            ),
            const SizedBox(height: 8),
            _buildRating(review.rating),
            const SizedBox(height: 8),
            Text(review.comment, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final success = await _controller.toggleReviewVisibility(
                      review.id,
                    );

                    if (!mounted) {
                      return;
                    }

                    _showSnackBar(
                      success
                          ? 'Cập nhật trạng thái đánh giá thành công'
                          : (_controller.reviewErrorMessage ??
                                'Thao tác thất bại'),
                    );
                  },
                  icon: Icon(
                    review.isVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  label: Text(review.isVisible ? 'Ẩn' : 'Hiện'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _confirmDeleteReview(review),
                  icon: const Icon(Icons.delete_forever),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        color: color.withValues(alpha: 0.12),
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
        const Text('Đánh giá: ', style: TextStyle(fontWeight: FontWeight.bold)),
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
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc muốn xóa đánh giá của "${review.customerName}" không?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final success = await _controller.deleteReview(review.id);

                if (!mounted) {
                  return;
                }

                if (success) {
                  Navigator.pop(dialogContext);
                  _showSnackBar('Đã xóa đánh giá');
                } else {
                  _showSnackBar(
                    _controller.reviewErrorMessage ?? 'Xóa thất bại',
                  );
                }
              },
              icon: const Icon(Icons.delete_forever),
              label: const Text('Xóa'),
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

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
