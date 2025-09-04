import 'package:communication_recovery_toolkit/models/progress_data.dart';
import 'package:communication_recovery_toolkit/providers/progress_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/aac_provider.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProgressDataAdapter());
  await Hive.openBox<ProgressData>('progress');
  runApp(const CommunicationRecoveryApp());
}

class CommunicationRecoveryApp extends StatelessWidget {
  const CommunicationRecoveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AACProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
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