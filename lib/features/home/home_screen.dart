import 'package:flutter/material.dart';
import 'package:med_bot/features/chat/chat_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:med_bot/config.dart';
import 'package:intl/intl.dart';

class Message {
  final String sender;
  final String text;
  final DateTime timestamp;

  Message({required this.sender, required this.text, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ChatModel {
  final String id;
  final String title;
  final DateTime updatedAt;
  final List<Message> messages;

  ChatModel({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.messages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    var list = json['messages'] as List;
    List<Message> messagesList = list.map((i) => Message.fromJson(i)).toList();
    return ChatModel(
      id: json['_id'],
      title: json['title'],
      updatedAt: DateTime.parse(json['updatedAt']),
      messages: messagesList,
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String userEmail;
  const HomeScreen({super.key, required this.userEmail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatModel> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$serverUrl/api/chats/${widget.userEmail}'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        List<dynamic> chatsJson = json.decode(response.body);
        setState(() {
          _chats = chatsJson.map((json) => ChatModel.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF3F4F6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, top: 24.0, bottom: 16.0),
            child: Text(
              'Мои чаты',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RefreshIndicator(
                      onRefresh: _fetchChats,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _chats.length,
                        itemBuilder: (context, index) {
                          final chat = _chats[index];
                          final lastMessage = chat.messages.isNotEmpty
                              ? chat.messages.last
                              : null;
                          final timeAgo = lastMessage != null
                              ? DateFormat('HH:mm dd.MM').format(chat.updatedAt)
                              : 'Нет сообщений';

                          return GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    initialChat: chat,
                                    userEmail: widget.userEmail,
                                  ),
                                ),
                              );
                              if (result == true) {
                                _fetchChats();
                              }
                            },
                            child: Card(
                              color: Colors.white,
                              elevation: 1,
                              shadowColor: Colors.black12,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  chat.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  'Последнее: ${lastMessage?.text ?? 'Начните беседу'}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(
                                  timeAgo,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userEmail: widget.userEmail,
                            initialChat: null,
                          ),
                        ),
                      );
                      if (result == true) {
                        _fetchChats();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 32,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'МедБот',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Flash 2.5 Pro',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
