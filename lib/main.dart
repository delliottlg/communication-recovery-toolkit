import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/aac_provider.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const CommunicationRecoveryApp());
}

class CommunicationRecoveryApp extends StatelessWidget {
  const CommunicationRecoveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AACProvider()),
      ],
      child: MaterialApp(
        title: 'Communication Recovery Toolkit',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const MainNavigation(),
      ),
    );
  }
}