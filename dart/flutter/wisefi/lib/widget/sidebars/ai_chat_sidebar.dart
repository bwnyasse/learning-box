import 'package:flutter/material.dart';

class ChatMessage {
  final String content;
  final DateTime timestamp;
  final bool isUser;

  ChatMessage({
    required this.content,
    required this.timestamp,
    required this.isUser,
  });
}

class AIChatSidebar extends StatefulWidget {
  const AIChatSidebar({Key? key}) : super(key: key);

  @override
  State<AIChatSidebar> createState() => _AIChatSidebarState();
}

class _AIChatSidebarState extends State<AIChatSidebar> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    
    // Add initial greeting message
    _messages.add(
      ChatMessage(
        content: 'Hello! I\'m WiseFi Assistant. How can I help you with your wireless network today?',
        timestamp: DateTime.now(),
        isUser: false,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      content: _messageController.text,
      timestamp: DateTime.now(),
      isUser: true,
    );

    setState(() {
      _messages.add(userMessage);
      _messageController.clear();
      _isTyping = true; // Show typing indicator
    });

    // Simulate AI response after delay
    Future.delayed(const Duration(seconds: 1), () {
      final botResponse = ChatMessage(
        content: _generateResponse(userMessage.content),
        timestamp: DateTime.now(),
        isUser: false,
      );

      setState(() {
        _messages.add(botResponse);
        _isTyping = false;
      });
    });
  }

  String _generateResponse(String message) {
    // Simple mock response system
    if (message.toLowerCase().contains('underperforming')) {
      return 'Based on current data, AP-102 and AP-105 are showing performance issues with high channel utilization (>70%). They may need channel reallocation or load balancing.';
    } else if (message.toLowerCase().contains('bandwidth') || message.toLowerCase().contains('traffic')) {
      return 'The highest bandwidth users are on AP-103 in the Marketing department. Top 3 clients by usage:\n\n1. Device MAC ending in 4E:2A - 1.2GB\n2. Device MAC ending in F1:5C - 870MB\n3. Device MAC ending in A9:D3 - 690MB';
    } else if (message.toLowerCase().contains('interference')) {
      return 'There are several sources of interference affecting your network:\n\n- 2.4GHz band has adjacent channel interference on channels 1 and 2\n- 3 rogue APs detected near the east wing\n- Potential non-WiFi interference detected on 5GHz DFS channels';
    }
    
    return 'I\'ll analyze your network data for insights related to this question. To get more specific information, you could ask about wireless performance, client distribution, or security concerns.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      child: Column(
        children: [
          // AI Assistant Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  radius: 20,
                  child: Icon(
                    Icons.assistant,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WiseFi Assistant',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Ask me anything about your network',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      _messages.clear();
                      _messages.add(
                        ChatMessage(
                          content: 'Hello! I\'m WiseFi Assistant. How can I help you with your wireless network today?',
                          timestamp: DateTime.now(),
                          isUser: false,
                        ),
                      );
                    });
                  },
                  tooltip: 'Clear Chat',
                ),
              ],
            ),
          ),

          // Suggested Prompts Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggested Questions',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPromptChip(context, 'Show me underperforming APs'),
                    _buildPromptChip(context, 'Explain this spike in traffic'),
                    _buildPromptChip(
                        context, 'Which clients use the most bandwidth?'),
                    _buildPromptChip(context, 'What is causing interference?'),
                  ],
                ),
              ],
            ),
          ),

          // Chat Messages
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyChatState(context)
                : _buildChatMessages(context),
          ),

          // Typing indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Assistant is typing...',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

          // Input Section
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask something about your network',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyLarge,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChatState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Ask a question or use a suggested prompt',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      reverse: true,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[_messages.length - 1 - index];
        return _buildChatBubble(context, message);
      },
    );
  }

  Widget _buildChatBubble(BuildContext context, ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
              radius: 16,
              child: Icon(
                Icons.assistant,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: message.isUser
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isUser
                          ? Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.7)
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              radius: 16,
              child: Icon(
                Icons.person,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPromptChip(BuildContext context, String prompt) {
    return InkWell(
      onTap: () {
        _messageController.text = prompt;
        _sendMessage();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Text(
          prompt,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays > 0) {
      return '${time.day}/${time.month}, ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}