import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:crafts_portal/firebase_options.dart';
import 'package:crafts_portal/providers/auth_provider.dart';
import 'package:crafts_portal/providers/user_provider.dart';
import 'package:crafts_portal/providers/chat_provider.dart';
import 'package:crafts_portal/screens/splash_screen.dart';
import 'package:crafts_portal/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CraftsPortalApp());
}

class CraftsPortalApp extends StatelessWidget {
  const CraftsPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Crafts Portal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
} 