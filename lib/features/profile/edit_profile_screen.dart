import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:med_bot/config.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late String _gender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.userData['fullName'] ?? '',
    );
    _emailController = TextEditingController(
      text: widget.userData['email'] ?? '',
    );
    _dateOfBirthController = TextEditingController(
      text: widget.userData['dateOfBirth'] ?? '',
    );
    _bloodGroupController = TextEditingController(
      text: widget.userData['bloodGroup'] ?? '',
    );
    _heightController = TextEditingController(
      text: widget.userData['height'] ?? '',
    );
    _weightController = TextEditingController(
      text: widget.userData['weight'] ?? '',
    );
    _gender = widget.userData['gender'] ?? 'Мужской';
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.put(
        Uri.parse('$serverUrl/user/${_emailController.text}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': _fullNameController.text,
          'dateOfBirth': _dateOfBirthController.text,
          'gender': _gender,
          'bloodGroup': _bloodGroupController.text,
          'height': _heightController.text,
          'weight': _weightController.text,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Профиль успешно обновлен'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          final responseData = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка: ${responseData['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось подключиться к серверу: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Редактировать профиль'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(controller: _fullNameController, label: 'ФИО'),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              enabled: false,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _dateOfBirthController,
              label: 'Дата рождения',
            ),
            const SizedBox(height: 16),
            _buildGenderDropdown(),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _bloodGroupController,
              label: 'Группа крови',
            ),
            const SizedBox(height: 16),
            _buildTextField(controller: _heightController, label: 'Рост'),
            const SizedBox(height: 16),
            _buildTextField(controller: _weightController, label: 'Вес'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Сохранить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField(
      value: _gender,
      decoration: const InputDecoration(
        labelText: 'Пол',
        border: OutlineInputBorder(),
      ),
      items: <String>['Мужской', 'Женский'].map<DropdownMenuItem<String>>((
        String value,
      ) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _gender = newValue!;
        });
      },
    );
  }
}
