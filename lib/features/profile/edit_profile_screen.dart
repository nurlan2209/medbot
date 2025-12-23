import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/network/api_client.dart';
import 'package:med_bot/app/widgets/primary_button.dart';
import 'package:med_bot/app/widgets/text_input.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> initialUser;
  const EditProfileScreen({super.key, required this.initialUser});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _ageController;
  late final TextEditingController _phoneController;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: (widget.initialUser['fullName'] ?? '').toString());
    _emailController = TextEditingController(text: (widget.initialUser['email'] ?? '').toString());
    _ageController = TextEditingController(text: (widget.initialUser['age'] ?? '').toString());
    _phoneController = TextEditingController(text: (widget.initialUser['phoneNumber'] ?? '').toString());
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ApiClient.putJson(
        '/user/${_emailController.text.trim()}',
        body: {
          'fullName': _fullNameController.text.trim(),
          'age': int.tryParse(_ageController.text.trim()),
          'phoneNumber': _phoneController.text.trim(),
        },
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.danger),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('User Information'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                TextInput(label: 'Full name', controller: _fullNameController, hintText: 'John Doe'),
                const SizedBox(height: 16),
                TextInput(label: 'Email', controller: _emailController, enabled: false),
                const SizedBox(height: 16),
                TextInput(label: 'Age', controller: _ageController, keyboardType: TextInputType.number, hintText: '25'),
                const SizedBox(height: 16),
                TextInput(
                  label: 'Phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  hintText: '+7 (777) 123-45-67',
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  fullWidth: true,
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
