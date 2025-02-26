import 'package:flutter/material.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';

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
  final List<FortiAPData>? fortiAPData;
  final List<FortiManagerData>? fortiManagerData;

  const AIChatSidebar({
    Key? key,
    this.fortiAPData,
    this.fortiManagerData,
  }) : super(key: key);

  @override
  State<AIChatSidebar> createState() => _AIChatSidebarState();
}

class _AIChatSidebarState extends State<AIChatSidebar> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isInitialized = false;
  String _initializationError = '';

  // Gemini model configuration
  static const String _modelName = 'gemini-1.0-pro';
  GenerativeModel? _model;

  @override
  void initState() {
    super.initState();
    _initializeModel();

    // Add initial greeting message
    _messages.add(
      ChatMessage(
        content:
            'Hello! I\'m WiseFi Assistant. How can I help you with your wireless network today?',
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

  Future<void> _initializeModel() async {
    setState(() {
      _isInitialized = false;
      _initializationError = '';
    });

    try {
      debugPrint('Initializing Gemini model with $_modelName');
      _model = FirebaseVertexAI.instance.generativeModel(model: _modelName);

      // Test initialization with a simple prompt
      await _model?.generateContent([Content.text('test initialization')]);

      setState(() {
        _isInitialized = true;
      });
      debugPrint('Gemini model initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Gemini model: $e');
      setState(() {
        _isInitialized = false;
        _initializationError = e.toString();
        _model = null;
      });
    }
  }

  Future<void> _sendMessage() async {
    final userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    // Add user message to the chat
    final userChatMessage = ChatMessage(
      content: userMessage,
      timestamp: DateTime.now(),
      isUser: true,
    );

    setState(() {
      _messages.add(userChatMessage);
      _messageController.clear();
      _isTyping = true;
    });

    try {
      if (_isInitialized && _model != null) {
        // Create context from network data if available
        String context = '';
        if (widget.fortiAPData != null || widget.fortiManagerData != null) {
          context = _createNetworkContext();
        }

        // Create the full prompt with context
        final fullPrompt = context.isNotEmpty
            ? "You are WiseFi Assistant, a helpful AI that specializes in wireless networking. "
                "You're answering questions about the user's wireless network. "
                "Please format your responses using Markdown for better readability. Use headers, lists, "
                "bold, and code blocks where appropriate. "
                "Here's the current context about their network:\n\n$context\n\n"
                "User question: $userMessage"
            : "You are WiseFi Assistant, a helpful AI that specializes in wireless networking. "
                "Please format your responses using Markdown for better readability. Use headers, lists, "
                "bold, and code blocks where appropriate.\n\n"
                "User question: $userMessage";

        // Call the Gemini model with the user's message
        final response = await _model!.generateContent([
          Content.multi([TextPart(fullPrompt)]),
        ]);

        if (response.text == null || response.text!.isEmpty) {
          throw Exception('Empty response from Gemini');
        }

        // Add AI response to the chat
        final aiResponse = ChatMessage(
          content: response.text!,
          timestamp: DateTime.now(),
          isUser: false,
        );

        setState(() {
          _messages.add(aiResponse);
          _isTyping = false;
        });
      } else {
        // If model initialization failed, use fallback response
        await Future.delayed(const Duration(seconds: 1));

        String errorMessage = _initializationError.isNotEmpty
            ? 'Sorry, I\'m having trouble connecting to my AI capabilities. Technical error: $_initializationError'
            : 'Sorry, I\'m having trouble connecting to my AI capabilities. Please try again later.';

        final fallbackResponse = ChatMessage(
          content: errorMessage,
          timestamp: DateTime.now(),
          isUser: false,
        );

        setState(() {
          _messages.add(fallbackResponse);
          _isTyping = false;
        });
      }
    } catch (e) {
      debugPrint('Error getting response from model: $e');

      // Add error message to chat
      final errorResponse = ChatMessage(
        content:
            'Sorry, I encountered an error while processing your request: ${e.toString()}',
        timestamp: DateTime.now(),
        isUser: false,
      );

      setState(() {
        _messages.add(errorResponse);
        _isTyping = false;
      });
    }
  }

  String _createNetworkContext() {
    StringBuffer context = StringBuffer();

    if (widget.fortiAPData != null && widget.fortiAPData!.isNotEmpty) {
      context.writeln("WIRELESS NETWORK SUMMARY:");

      // Count total APs and their status
      int totalAPs = widget.fortiAPData!.length;
      int onlineAPs =
          widget.fortiAPData!.where((ap) => ap.status == 'online').length;
      int warningAPs =
          widget.fortiAPData!.where((ap) => ap.status == 'warning').length;
      int offlineAPs =
          widget.fortiAPData!.where((ap) => ap.status == 'offline').length;

      context.writeln("- Total Access Points: $totalAPs");
      context.writeln("- Online APs: $onlineAPs");
      context.writeln("- Warning APs: $warningAPs");
      context.writeln("- Offline APs: $offlineAPs");

      // Count clients and rogue APs
      int totalClients = 0;
      int totalRogueAPs = 0;

      for (var ap in widget.fortiAPData!) {
        if (ap.radios != null) {
          for (var radio in ap.radios!) {
            totalClients += radio.clientCount ?? 0;
            totalRogueAPs += radio.detectedRogueAps ?? 0;
          }
        }
      }

      context.writeln("- Total Clients: $totalClients");
      context.writeln("- Detected Rogue APs: $totalRogueAPs");

      // List locations
      final locations = widget.fortiAPData!
          .where((ap) => ap.dv_location != null)
          .map((ap) => ap.dv_location!)
          .toSet();

      context.writeln("\nLOCATIONS: ${locations.join(', ')}");

      // List any warning/critical APs
      if (warningAPs > 0 || offlineAPs > 0) {
        context.writeln("\nPROBLEMATIC ACCESS POINTS:");

        for (var ap in widget.fortiAPData!) {
          if (ap.status == 'warning' || ap.status == 'offline') {
            context.writeln("- ${ap.name} (${ap.dv_location}): ${ap.status}");
          }
        }
      }
    }

    if (widget.fortiManagerData != null &&
        widget.fortiManagerData!.isNotEmpty) {
      context.writeln("\nRECENT MANAGEMENT EVENTS:");

      // Get the 5 most recent events
      final recentEvents = List.from(widget.fortiManagerData!)
        ..sort((a, b) {
          if (a.date == null && b.date == null) return 0;
          if (a.date == null) return 1;
          if (b.date == null) return -1;
          return b.date!.compareTo(a.date!);
        });

      final eventsToShow = recentEvents.take(5).toList();

      for (var event in eventsToShow) {
        final dateStr = event.date != null
            ? DateFormat('MMM d, h:mm a').format(event.date!)
            : 'Unknown time';

        context.writeln(
            "- $dateStr: ${event.action} by ${event.getUserName()} - ${event.msg}");
      }
    }

    return context.toString();
  }

  void _handleSuggestedPrompt(String prompt) {
    _messageController.text = prompt;
    _sendMessage();
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
                      Row(
                        children: [
                          Text(
                            'Powered by Gemini',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 8),

                          // Show status indicator
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isInitialized ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
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
                          content:
                              'Hello! I\'m WiseFi Assistant. How can I help you with your wireless network today?',
                          timestamp: DateTime.now(),
                          isUser: false,
                        ),
                      );
                    });

                    if (!_isInitialized) {
                      _initializeModel();
                    }
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
                    _buildPromptChip(context, 'Explain the rogue AP threats'),
                    _buildPromptChip(
                        context, 'Which clients use the most bandwidth?'),
                    _buildPromptChip(
                        context, 'What recent config changes were made?'),
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
                    'WiseFi Assistant ( Not Kris Castilho ) is typing...',
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
                    enabled: _isInitialized || !_isTyping,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isInitialized && !_isTyping ? _sendMessage : null,
                  style: IconButton.styleFrom(
                    backgroundColor: _isInitialized && !_isTyping
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).disabledColor,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                  if (message.isUser)
                    // For user messages, we just display plain text
                    Text(
                      message.content,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  else
                    // For assistant messages, we render markdown
                    MarkdownBody(
                      data: message.content,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        h1: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        h2: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        h3: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        code: TextStyle(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: 'monospace',
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        blockquote: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                        blockquoteDecoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 4,
                            ),
                          ),
                        ),
                      ),
                      onTapLink: (text, href, title) {
                        // Handle link taps if needed
                      },
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
      onTap: () => _handleSuggestedPrompt(prompt),
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
