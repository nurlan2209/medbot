import 'package:flutter/material.dart';
import 'package:med_bot/features/home/home_screen.dart';
import 'package:med_bot/app/widgets/bottom_nav.dart';
import 'package:med_bot/features/chat/ai_chat_screen.dart';
import 'package:med_bot/features/medical/medical_card_screen.dart';
import 'package:med_bot/features/profile/profile_screen.dart';
import 'package:med_bot/features/emergency/emergency_button.dart';

class MainScreen extends StatefulWidget {
  final String userEmail;
  const MainScreen({super.key, required this.userEmail});

  @override
  State<MainScreen> createState() => MainScreenState();

  static MainScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainScreenState>();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;
  final GlobalKey<AiChatScreenState> _aiChatKey = GlobalKey<AiChatScreenState>();

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(userEmail: widget.userEmail),
      AiChatScreen(key: _aiChatKey, userEmail: widget.userEmail),
      const MedicalCardScreen(),
      ProfileScreen(userEmail: widget.userEmail),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void setTab(int index) => _onItemTapped(index);

  void openChatHistory() {
    setTab(1);
    _aiChatKey.currentState?.showHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _selectedIndex, children: _widgetOptions),
          const EmergencyButton(),
        ],
      ),
      bottomNavigationBar: BottomNav(currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
