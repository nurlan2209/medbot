import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/network/api_client.dart';
import 'package:med_bot/features/chat/chat_models.dart';
import 'package:med_bot/features/profile/user_settings_models.dart';
import 'package:share_plus/share_plus.dart';

class AiChatScreen extends StatefulWidget {
  final String userEmail;
  const AiChatScreen({super.key, required this.userEmail});

  @override
  State<AiChatScreen> createState() => AiChatScreenState();
}

class AiChatScreenState extends State<AiChatScreen> {
  bool _showHistory = true;

  bool _loadingHistory = true;
  List<ChatModel> _history = const [];

  String? _chatId;
  List<ChatMessage> _messages = const [];
  bool _sending = false;

  final _inputController = TextEditingController();

  UserSettings _settings = const UserSettings(
    useMedicalDataInAI: true,
    storeChatHistory: true,
    shareAnalytics: false,
  );

  @override
  void initState() {
    super.initState();
    _fetchHistory();
    _fetchSettings();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _fetchHistory() async {
    setState(() => _loadingHistory = true);
    try {
      final data = await ApiClient.getJson('/api/chats/${widget.userEmail}');
      final list = (data as List).whereType<Map<String, dynamic>>().toList();
      setState(() {
        _history = list.map(ChatModel.fromJson).toList();
        _loadingHistory = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingHistory = false);
    }
  }

  void _startNewChat() {
    setState(() {
      _showHistory = false;
      _chatId = null;
      _messages = const [];
    });
  }

  void _openChat(ChatModel chat) {
    setState(() {
      _showHistory = false;
      _chatId = chat.id;
      _messages = chat.messages;
    });
  }

  void _backToHistory() {
    setState(() => _showHistory = true);
    _fetchHistory();
  }

  void showHistory() => _backToHistory();

  Future<void> _fetchSettings() async {
    try {
      final data = await ApiClient.getJson('/user/settings');
      final settingsJson = (data as Map)['settings'] as Map? ?? const {};
      if (!mounted) return;
      setState(() => _settings = UserSettings.fromJson(settingsJson.cast<String, dynamic>()));
    } catch (_) {}
  }

  Future<void> _send() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _sending = true;
      _messages = [
        ..._messages,
        ChatMessage(sender: 'user', text: text, timestamp: DateTime.now()),
      ];
      _inputController.clear();
    });

    try {
      final Map<String, dynamic> response;
      if (_chatId == null) {
        response = await ApiClient.postJson(
          '/api/chats',
          body: {'userEmail': widget.userEmail, 'messageText': text},
        );
      } else {
        response = await ApiClient.postJson(
          '/api/chats/$_chatId/messages',
          body: {'messageText': text},
        );
      }

      final chatJson = response['chat'] as Map<String, dynamic>?;
      if (chatJson == null) throw ApiException(500, 'Invalid server response');
      final chat = ChatModel.fromJson(chatJson);

      if (!mounted) return;
      setState(() {
        _chatId = chat.id;
        _messages = chat.messages;
        _sending = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.danger),
      );
    }
  }

  Future<void> _deleteChat(String chatId) async {
    await ApiClient.deleteJson('/api/chats/$chatId');
    await _fetchHistory();
  }

  Future<void> _saveCurrent() async {
    final lastAi = _messages.lastWhere(
      (m) => m.sender != 'user' && m.text.trim().isNotEmpty,
      orElse: () => ChatMessage(sender: 'bot', text: '', timestamp: DateTime.now()),
    );
    if (lastAi.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to save')),
      );
      return;
    }

    final firstUser = _messages.firstWhere(
      (m) => m.sender == 'user' && m.text.trim().isNotEmpty,
      orElse: () => ChatMessage(sender: 'user', text: 'AI Chat', timestamp: DateTime.now()),
    );
    final title = firstUser.text.trim().length > 60 ? '${firstUser.text.trim().substring(0, 60)}…' : firstUser.text.trim();

    try {
      await ApiClient.postJson(
        '/api/saved',
        body: {
          'type': 'chat_message',
          'title': title.isEmpty ? 'Saved item' : title,
          'content': lastAi.text,
          'chatId': _chatId,
        },
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.danger),
      );
    }
  }

  Future<void> _shareCurrent() async {
    final lastAi = _messages.lastWhere(
      (m) => m.sender != 'user' && m.text.trim().isNotEmpty,
      orElse: () => ChatMessage(sender: 'bot', text: '', timestamp: DateTime.now()),
    );
    if (lastAi.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nothing to share')),
      );
      return;
    }
    await Share.share(lastAi.text, subject: 'AI Chat');
  }

  @override
  Widget build(BuildContext context) {
    if (_showHistory) return _historyView(context);
    return _chatView(context);
  }

  Widget _historyView(BuildContext context) {
    final df = DateFormat('MMM d, y');
    final tf = DateFormat('HH:mm');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Chat', style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Medical consultation assistant',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.surfaceMuted,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _settings.useMedicalDataInAI ? AppColors.success : AppColors.grayLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _settings.useMedicalDataInAI ? 'Medical profile applied' : 'Medical profile not applied',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grayDark),
                  ),
                ],
              ),
            ),
            Expanded(
          child: RefreshIndicator(
                onRefresh: _fetchHistory,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Recent Chats', style: Theme.of(context).textTheme.headlineMedium)),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                          onPressed: _startNewChat,
                          child: Row(
                            children: const [
                              Icon(Icons.add, size: 16),
                              SizedBox(width: 6),
                              Text('New Chat', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_loadingHistory)
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_history.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          'No chats yet. Start a new chat.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
                        ),
                      )
                    else
                      ..._history.map((chat) {
                        final last = chat.messages.isNotEmpty ? chat.messages.last.text : '—';
                        final local = chat.updatedAt.toLocal();
                        final dateLabel = DateTime.now().difference(local).inDays == 0 ? 'Today, ${tf.format(local)}' : df.format(local);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Dismissible(
                            key: ValueKey(chat.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete chat?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                                  ],
                                ),
                              );
                              return ok ?? false;
                            },
                            onDismissed: (_) async {
                              final messenger = ScaffoldMessenger.of(context);
                              try {
                                await _deleteChat(chat.id);
                              } catch (e) {
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(content: Text(e.toString()), backgroundColor: AppColors.danger),
                                );
                                _fetchHistory();
                              }
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: AppColors.danger,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: InkWell(
                              onTap: () => _openChat(chat),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(chat.title, style: Theme.of(context).textTheme.bodyMedium),
                                    const SizedBox(height: 6),
                                    Text(
                                      last,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(dateLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grayLight)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatView(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _backToHistory,
                    child: const Text('← Back'),
                  ),
                  const Spacer(),
                  IconButton(onPressed: _saveCurrent, icon: const Icon(Icons.bookmark_border, color: AppColors.grayLight)),
                  IconButton(onPressed: _shareCurrent, icon: const Icon(Icons.share_outlined, color: AppColors.grayLight)),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.surfaceMuted,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _settings.useMedicalDataInAI ? AppColors.success : AppColors.grayLight,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _settings.useMedicalDataInAI ? 'Medical profile applied' : 'Medical profile not applied',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grayDark),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ..._messages.map((m) => _MessageBubble(message: m)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Describe your symptoms...',
                        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
                        filled: true,
                        fillColor: AppColors.surfaceMuted,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: _sending ? null : _send,
                      child: _sending
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.send, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == 'user';
    final risk = isUser ? null : _riskLevel(message.text);

    Color? riskColor;
    String? riskLabel;
    switch (risk) {
      case _Risk.high:
        riskColor = AppColors.danger;
        riskLabel = 'High Risk';
        break;
      case _Risk.medium:
        riskColor = AppColors.warning;
        riskLabel = 'Medium Risk';
        break;
      case _Risk.low:
        riskColor = AppColors.success;
        riskLabel = 'Low Risk';
        break;
      case null:
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser && riskColor != null && riskLabel != null) ...[
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: riskColor, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Text(
                          riskLabel,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grayDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isUser ? Colors.white : AppColors.foreground,
                        ),
                  ),
                  if (!isUser) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 8),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                      onPressed: () {},
                      child: const Text('Ask follow-up →', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _Risk { low, medium, high }

_Risk? _riskLevel(String text) {
  final t = text.toLowerCase();
  if (t.contains('call emergency') || t.contains('emergency') || t.contains('urgent')) return _Risk.high;
  if (t.contains('consult') || t.contains('doctor') || t.contains('warning')) return _Risk.medium;
  if (t.isEmpty) return null;
  return _Risk.low;
}
