import 'package:flutter/material.dart';
import '../controllers/chat_ai_controller.dart';

class ChatAiScreen extends StatefulWidget {
  const ChatAiScreen({super.key});

  @override
  State<ChatAiScreen> createState() => _ChatAiScreenState();
}

class _ChatAiScreenState extends State<ChatAiScreen> {
  final ChatAiController _controller = ChatAiController();

  final TextEditingController _textController =
  TextEditingController();

  final ScrollController _scrollController =
  ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _textController.text.trim();

    if (text.isEmpty) return;

    _textController.clear();

    await _controller.sendMessage(text);

    await Future.delayed(
      const Duration(milliseconds: 100),
    );

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030A16),

      body: SafeArea(
        child: Column(
          children: [
            _header(),

            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  if (_controller.messages.isEmpty) {
                    return _emptyState();
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),

                    itemCount:
                    _controller.messages.length +
                        (_controller.isLoading
                            ? 1
                            : 0),

                    itemBuilder: (context, index) {
                      if (index >=
                          _controller.messages.length) {
                        return _typingBubble();
                      }

                      final msg =
                      _controller.messages[index];

                      return _messageBubble(
                        role: msg['role'] ?? '',
                        content:
                        msg['content'] ?? '',
                      );
                    },
                  );
                },
              ),
            ),

            _inputBox(),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // HEADER
  // =====================================================

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFF0B1528),

        border: Border(
          bottom: BorderSide(
            color: Colors.white.withAlpha(20),
          ),
        ),
      ),

      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },

            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 4),

          const Icon(
            Icons.smart_toy_outlined,
            color: Color(0xFF5CE1E6),
          ),

          const SizedBox(width: 12),

          const Text(
            'AI Tư vấn Laptop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // EMPTY STATE
  // =====================================================

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFF5CE1E6),
              size: 70,
            ),

            const SizedBox(height: 20),

            const Text(
              'Bạn cần tư vấn laptop gì?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Ví dụ: Laptop gaming 25 triệu, laptop học AI, laptop đồ họa, laptop văn phòng...',
              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.white.withAlpha(130),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // MESSAGE BUBBLE
  // =====================================================

  Widget _messageBubble({
    required String role,
    required String content,
  }) {
    final isUser = role == 'user';

    return Align(
      alignment:
      isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        padding: const EdgeInsets.all(14),

        constraints:
        const BoxConstraints(maxWidth: 290),

        decoration: BoxDecoration(
          color:
          isUser
              ? const Color(0xFF5CE1E6)
              : const Color(0xFF0B1528),

          borderRadius:
          BorderRadius.circular(18),

          border: Border.all(
            color:
            isUser
                ? Colors.transparent
                : const Color(
              0xFF5CE1E6,
            ).withAlpha(60),
          ),
        ),

        child: Text(
          content,

          style: TextStyle(
            color:
            isUser
                ? const Color(0xFF030A16)
                : Colors.white,

            fontWeight:
            isUser
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // AI TYPING
  // =====================================================

  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: const Color(0xFF0B1528),
          borderRadius: BorderRadius.circular(18),
        ),

        child: const Text(
          'AI đang suy nghĩ...',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  // =====================================================
  // INPUT BOX
  // =====================================================

  Widget _inputBox() {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xFF0B1528),

        border: Border(
          top: BorderSide(
            color: Colors.white.withAlpha(20),
          ),
        ),
      ),

      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,

              style: const TextStyle(
                color: Colors.white,
              ),

              minLines: 1,
              maxLines: 4,

              decoration: InputDecoration(
                hintText:
                'Nhập câu hỏi tư vấn laptop...',

                hintStyle: TextStyle(
                  color:
                  Colors.white.withAlpha(100),
                ),

                filled: true,
                fillColor: const Color(0xFF030A16),

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(18),

                  borderSide: BorderSide.none,
                ),
              ),

              onSubmitted: (_) => _send(),
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 54,
            height: 54,

            child: ElevatedButton(
              onPressed: _send,

              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,

                backgroundColor:
                const Color(0xFF5CE1E6),

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(16),
                ),
              ),

              child: const Icon(
                Icons.send,
                color: Color(0xFF030A16),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}