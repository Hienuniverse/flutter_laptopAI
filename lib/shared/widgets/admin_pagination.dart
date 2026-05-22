import 'package:flutter/material.dart';

class AdminPagination extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int itemsPerPage;
  final ValueChanged<int> onPageChanged;

  const AdminPagination({
    super.key,
    required this.currentPage,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
  });

  int get totalPages {
    if (totalItems == 0) {
      return 1;
    }

    return (totalItems / itemsPerPage).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final startItem = totalItems == 0
        ? 0
        : ((currentPage - 1) * itemsPerPage) + 1;
    final endItem = (currentPage * itemsPerPage) > totalItems
        ? totalItems
        : currentPage * itemsPerPage;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.end,
        children: [
          Text(
            'Hiển thị $startItem - $endItem / $totalItems',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            tooltip: 'Trang trước',
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          _buildPageButton(context, 1),
          if (currentPage > 3) const Text('...'),
          if (currentPage - 1 > 1) _buildPageButton(context, currentPage - 1),
          if (currentPage != 1 && currentPage != totalPages)
            _buildPageButton(context, currentPage),
          if (currentPage + 1 < totalPages)
            _buildPageButton(context, currentPage + 1),
          if (currentPage < totalPages - 2) const Text('...'),
          if (totalPages > 1) _buildPageButton(context, totalPages),
          IconButton(
            tooltip: 'Trang sau',
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(BuildContext context, int page) {
    final isSelected = page == currentPage;

    return OutlinedButton(
      onPressed: isSelected ? null : () => onPageChanged(page),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      child: Text(page.toString()),
    );
  }
}
