import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../providers/report_provider.dart';
import '../../domain/entities/report.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Data Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _instagramController = TextEditingController();

  int _age = 18;
  String _gender = 'Masculino';
  String _country = 'México'; // Default
  String _category = 'Infidelidad física';
  bool _confirmed = false;

  final List<String> _genders = ['Masculino', 'Femenino', 'Otro'];
  final List<String> _categories = [
    'Engaño emocional',
    'Infidelidad física',
    'Múltiples parejas',
    'Mentiras y ocultamiento',
    'Otro'
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _descriptionController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_confirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes confirmar que la información es verdadera')),
      );
      return;
    }

    final report = Report(
      id: const Uuid().v4(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      age: _age,
      gender: _gender,
      country: _country,
      city: _cityController.text.trim(),
      district: _districtController.text.trim(),
      category: _category,
      description: _descriptionController.text.trim(),
      evidenceUrls: [], // TODO: Implement image upload
      createdAt: DateTime.now(),
      socialMedia: _instagramController.text.isNotEmpty
        ? {'instagram': _instagramController.text.trim()}
        : null,
    );

    await Provider.of<ReportProvider>(context, listen: false).addReport(report);

    if (mounted) {
       Navigator.pop(context);
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Reporte enviado correctamente')),
       );
    }
  }

  Widget _buildStep1() {
    return Column(
      children: [
        CustomTextField(
          label: 'Nombres',
          controller: _firstNameController,
          validator: (v) => v!.isEmpty ? 'Requerido' : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Apellidos',
          controller: _lastNameController,
          validator: (v) => v!.isEmpty ? 'Requerido' : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _age,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                items: List.generate(80, (index) => index + 18)
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                    .toList(),
                onChanged: (v) => setState(() => _age = v!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _gender,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Género',
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                items: _genders.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _gender = v!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
         DropdownButtonFormField<String>(
            value: _country,
            dropdownColor: AppColors.surface,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              labelText: 'País',
              filled: true,
              fillColor: AppColors.surface,
            ),
            items: ['México', 'Colombia', 'Argentina', 'Perú', 'España', 'USA']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _country = v!),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Ciudad',
            controller: _cityController,
            validator: (v) => v!.isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Distrito / Zona',
            controller: _districtController,
          ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _category,
          dropdownColor: AppColors.surface,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            labelText: 'Categoría',
            filled: true,
            fillColor: AppColors.surface,
          ),
          items: _categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _category = v!),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Historia detallada',
          controller: _descriptionController,
          maxLines: 5,
          validator: (v) => (v?.length ?? 0) < 50 ? 'Mínimo 50 caracteres' : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Instagram (Opcional)',
          controller: _instagramController,
          hint: '@usuario',
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      children: [
        const Text(
          'Resumen del Reporte',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          color: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Persona: ${_firstNameController.text} ${_lastNameController.text}', style: const TextStyle(color: Colors.white)),
                Text('Ubicación: $_country, ${_cityController.text}', style: const TextStyle(color: Colors.white70)),
                Text('Categoría: $_category', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        CheckboxListTile(
          value: _confirmed,
          activeColor: AppColors.primary,
          title: const Text(
            'Confirmo que la información es verdadera y asumo la responsabilidad legal.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          onChanged: (v) => setState(() => _confirmed = v ?? false),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Nuevo Reporte', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.primary),
        ),
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep == 0) {
              if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) return;
            }
            if (_currentStep == 1) {
              if (_cityController.text.isEmpty) return;
            }
            if (_currentStep == 2) {
              if (_descriptionController.text.length < 50) return;
            }

            if (_currentStep < 3) {
              setState(() => _currentStep++);
            } else {
              _submit();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: _currentStep == 3 ? 'PUBLICAR' : 'SIGUIENTE',
                      onPressed: details.onStepContinue!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('ATRÁS', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Datos Personales'),
              content: _buildStep1(),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text('Ubicación'),
              content: _buildStep2(),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text('Detalles'),
              content: _buildStep3(),
              isActive: _currentStep >= 2,
            ),
            Step(
              title: const Text('Confirmación'),
              content: _buildStep4(),
              isActive: _currentStep >= 3,
            ),
          ],
        ),
      ),
    );
  }
}
