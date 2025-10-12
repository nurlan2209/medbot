import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:med_bot/config.dart';
import 'package:med_bot/features/home/home_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatModel? initialChat;
  final String userEmail;

  const ChatScreen({super.key, required this.userEmail, this.initialChat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  String? _chatId;
  bool _isSending = false;
  String _chatTitle = 'Новый чат';
  bool _chatWasModified = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialChat != null) {
      _chatId = widget.initialChat!.id;
      _messages = widget.initialChat!.messages;
      _chatTitle = widget.initialChat!.title;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context, _chatWasModified);
    return false;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(Message(sender: 'user', text: text, timestamp: DateTime.now()));
      _messageController.clear();
      _isSending = true;
      _chatWasModified = true;
    });

    _scrollToBottom();

    final tempBotMessage = Message(sender: 'bot', text: 'Печатает...', timestamp: DateTime.now());
    setState(() {
      _messages.add(tempBotMessage);
    });
    _scrollToBottom();

    try {
      final String endpoint;
      final Map<String, dynamic> body;

      if (_chatId == null) {
        endpoint = '$serverUrl/api/chats';
        body = {'userEmail': widget.userEmail, 'messageText': text};
      } else {
        endpoint = '$serverUrl/api/chats/$_chatId/messages';
        body = {'messageText': text};
      }

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (!mounted) return;

      setState(() {
        _messages.removeLast();
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final updatedChat = ChatModel.fromJson(responseData['chat']);

        setState(() {
          _chatId = updatedChat.id;
          _messages = updatedChat.messages;
          _chatTitle = updatedChat.title;
          _isSending = false;
        });

        _scrollToBottom();
      } else {
        final responseData = json.decode(response.body);
        _showSnackBar('Ошибка: ${responseData['message']}');
        setState(() {
          _isSending = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.removeLast();
        _isSending = false;
      });
      _showSnackBar('Не удалось подключиться к серверу: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_chatTitle),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _onWillPop(),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message.sender == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                          bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                        ),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (value) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Отправить сообщение в МедБот',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: _isSending
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send),
                    onPressed: _isSending ? null : _sendMessage,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
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
