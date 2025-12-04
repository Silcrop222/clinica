import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'presentation/providers/report_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'data/repositories/report_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Note: Firebase.initializeApp() requires valid configuration (google-services.json / GoogleService-Info.plist)
  // which is not present in this environment. We wrap it in a try-catch or just proceed with a mock repository if needed for UI testing.
  // For the final app, the user must provide the Firebase config.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization failed (expected if config missing): $e");
  }

  runApp(const RniApp());
}

class RniApp extends StatelessWidget {
  const RniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ReportProvider(
            repository: ReportRepositoryImpl(), // Uses Firestore
          ),
        ),
      ],
      child: MaterialApp(
        title: 'RNI - Registro Nacional de Infieles',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            error: AppColors.primary, // Red for error/danger
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
