import 'package:flutter/material.dart';
import 'package:med_bot/features/auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/welcome_image.jpg', fit: BoxFit.cover,),

              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Добро пожаловать в МедБот',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PPNeueMachina',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        text: 'Технологии, которые ',
                        style: TextStyle(
                          fontFamily: 'PPNeueMachina',
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w800,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'заботятся',
                            style: TextStyle(
                              fontFamily: 'NauryzRedKeds',
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w900
                            ),
                          ),
                          TextSpan(
                            text: ' о вас',
                            style: TextStyle(
                              fontFamily: 'PPNeueMachina',
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.w800
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Авторизация +',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'PPNeueMachina',
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
