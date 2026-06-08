import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/tourism-app-9529a.firebasestorage.app/o/places%2F1780738721360.jpg?alt=media&token=cb938080-4817-4b94-859f-19277943c24f',
          errorBuilder: (context, error, stackTrace) {
            print(error);
            return const Text('Failed to load image');
          },
        ),
      ),
    );
  }
}
