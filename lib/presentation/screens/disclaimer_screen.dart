import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import 'home/home_screen.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
  bool _accepted = false;

  Future<void> _continue() async {
    if (_accepted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_accepted_disclaimer', true);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.warning_amber_rounded, size: 64, color: AppColors.primary),
              const SizedBox(height: 24),
              const Text(
                'Aviso Importante',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              const Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    'Esta aplicación contiene contenido generado por usuarios. \n\n'
                    'La información aquí mostrada puede ser ficticia, exagerada o inexacta. '
                    'La aplicación no verifica la veracidad de los reportes.\n\n'
                    'El usuario es el único responsable del contenido que publica y de las consecuencias legales que puedan derivarse de la difamación o divulgación de datos personales sin consentimiento.\n\n'
                    'Esta aplicación es para mayores de 18 años.\n\n'
                    'Al continuar, aceptas que has leído este aviso y asumes total responsabilidad por el uso de la plataforma.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: _accepted,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _accepted = val ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'He leído y acepto los términos.',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _accepted ? _continue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    disabledBackgroundColor: AppColors.surface,
                  ),
                  child: const Text('Continuar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
