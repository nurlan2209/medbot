import 'package:flutter/material.dart';
import 'package:med_bot/features/profile/edit_profile_screen.dart';
import 'package:med_bot/features/welcome/welcome_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:med_bot/config.dart';

class ProfileScreen extends StatefulWidget {
  final String userEmail;
  const ProfileScreen({super.key, required this.userEmail});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(Uri.parse('$serverUrl/user/${widget.userEmail}'));
      if (mounted) {
        if (response.statusCode == 200) {
          setState(() {
            _userData = json.decode(response.body);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
          ? const Center(child: Text('Не удалось загрузить данные профиля'))
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 240,
                    child: Stack(
                      children: [
                        Container(height: 240, color: Colors.white),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[300],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _userData!['fullName'] ?? 'Нет данных',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _userData!['email'] ?? 'Нет данных',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildInfoField(
                            label: 'Пол',
                            value: _userData!['gender'] ?? 'Не указано',
                          ),
                          _buildInfoField(
                            label: 'Группа крови',
                            value: _userData!['bloodGroup'] ?? 'Не указано',
                          ),
                          _buildInfoField(
                            label: 'Рост',
                            value: _userData!['height'] ?? 'Не указано',
                          ),
                          _buildInfoField(
                            label: 'Вес',
                            value: _userData!['weight'] ?? 'Не указано',
                          ),
                          _buildInfoField(
                            label: 'Дата рождения',
                            value: _userData!['dateOfBirth'] ?? 'Не указано',
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          _buildActionButton(
                            icon: Icons.person_outline,
                            text: 'Редактировать профиль',
                            color: Colors.blue,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfileScreen(userData: _userData!),
                                ),
                              );
                              if (result == true) {
                                _fetchUserData();
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildActionButton(
                            icon: Icons.exit_to_app,
                            text: 'Выйти',
                            color: Colors.red,
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WelcomeScreen(),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
