import 'package:flutter/material.dart';
import '../../config/theme.dart';

class ElearningScreen extends StatelessWidget {
  final String subject;
  const ElearningScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('التعليم الإلكتروني - $subject'),
        backgroundColor: const Color(0xFF0984E3),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            decoration: const BoxDecoration(
              color: Color(0xFF0984E3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.play_circle_rounded, size: 52, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  'دروس فيديو لمادة $subject',
                  style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.85)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0984E3).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.video_library_rounded, size: 50, color: Color(0xFF0984E3)),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'قريباً!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'سيتم إضافة دروس فيديو تعليمية\nلمادة $subject قريباً',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, color: AppTheme.textSecondary, height: 1.6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
