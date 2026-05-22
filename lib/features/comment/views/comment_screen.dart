import 'package:flutter/material.dart';
import '../controllers/comment_controller.dart';

class CommentScreen extends StatefulWidget {
  final int maSP;
  final int maTK;
  final String tenSP;

  const CommentScreen({
    super.key,
    required this.maSP,
    required this.maTK,
    required this.tenSP,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final CommentController _controller = CommentController();
  final TextEditingController _contentController = TextEditingController();

  int _selectedStar = 5;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _controller.fetchComments(widget.maSP);
  }

  @override
  void dispose() {
    _controller.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung đánh giá')),
      );
      return;
    }

    setState(() => _isSending = true);

    await _controller.addComment(
      maSP: widget.maSP,
      maTK: widget.maTK,
      soSao: _selectedStar,
      noiDung: _contentController.text.trim(),
    );

    _contentController.clear();

    setState(() {
      _selectedStar = 5;
      _isSending = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã gửi đánh giá')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030A16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1528),
        foregroundColor: Colors.white,
        title: const Text('Đánh giá sản phẩm'),
      ),
      body: Column(
        children: [
          _inputBox(),
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                if (_controller.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF5CE1E6),
                    ),
                  );
                }

                if (_controller.comments.isEmpty) {
                  return const Center(
                    child: Text(
                      'Chưa có đánh giá nào',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _controller.comments.length,
                  itemBuilder: (context, index) {
                    final item = _controller.comments[index];
                    return _commentItem(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528),
        border: Border(
          bottom: BorderSide(color: Colors.white.withAlpha(20)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.tenSP,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) {
              final star = index + 1;

              return IconButton(
                onPressed: () {
                  setState(() {
                    _selectedStar = star;
                  });
                },
                icon: Icon(
                  star <= _selectedStar ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFD54F),
                ),
              );
            }),
          ),
          Text(
            'Điểm: ${_selectedStar * 20}/100',
            style: const TextStyle(
              color: Color(0xFF5CE1E6),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contentController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Nhập đánh giá của bạn...',
              hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
              filled: true,
              fillColor: const Color(0xFF030A16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSending ? null : _submitComment,
              icon: const Icon(Icons.send),
              label: Text(_isSending ? 'Đang gửi...' : 'Gửi đánh giá'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5CE1E6),
                foregroundColor: const Color(0xFF030A16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _commentItem(Map<String, dynamic> item) {
    final soSao = item['sosao'] ?? 0;
    final diemSo = item['diemso'] ?? soSao * 20;
    final noiDung = item['noidung']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1528),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < soSao ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFD54F),
                  size: 18,
                );
              }),
              const Spacer(),
              Text(
                '$diemSo/100',
                style: const TextStyle(
                  color: Color(0xFF5CE1E6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            noiDung,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}