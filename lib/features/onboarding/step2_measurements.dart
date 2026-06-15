import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kairo/features/onboarding/onboarding_controller.dart';
import 'package:kairo/core/constants/app_colors.dart';

class Step2Measurements extends StatefulWidget {
  const Step2Measurements({super.key});

  @override
  State<Step2Measurements> createState() => _Step2MeasurementsState();
}

class _Step2MeasurementsState extends State<Step2Measurements> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    final c = Provider.of<OnboardingController>(context, listen: false);
    _controllers = {
      'neck': TextEditingController(text: c.neckCm.toString()),
      'shoulders': TextEditingController(text: c.shouldersCm.toString()),
      'chest': TextEditingController(text: c.chestCm.toString()),
      'backWidth': TextEditingController(text: c.backWidthCm.toString()),
      'biceps': TextEditingController(text: c.bicepsCm.toString()),
      'forearms': TextEditingController(text: c.forearmsCm.toString()),
      'waist': TextEditingController(text: c.waistCm.toString()),
      'glutes': TextEditingController(text: c.glutesCm.toString()),
      'thighs': TextEditingController(text: c.thighsCm.toString()),
      'calves': TextEditingController(text: c.calvesCm.toString()),
    };
  }

  @override
  void dispose() {
    _controllers.values.forEach((ctr) => ctr.dispose());
    super.dispose();
  }

  void _next() {
    if (_formKey.currentState!.validate()) {
      final c = Provider.of<OnboardingController>(context, listen: false);
      c.neckCm = double.parse(_controllers['neck']!.text.trim());
      c.shouldersCm = double.parse(_controllers['shoulders']!.text.trim());
      c.chestCm = double.parse(_controllers['chest']!.text.trim());
      c.backWidthCm = double.parse(_controllers['backWidth']!.text.trim());
      c.bicepsCm = double.parse(_controllers['biceps']!.text.trim());
      c.forearmsCm = double.parse(_controllers['forearms']!.text.trim());
      c.waistCm = double.parse(_controllers['waist']!.text.trim());
      c.glutesCm = double.parse(_controllers['glutes']!.text.trim());
      c.thighsCm = double.parse(_controllers['thighs']!.text.trim());
      c.calvesCm = double.parse(_controllers['calves']!.text.trim());
      c.nextStep();
    }
  }

  Widget _buildField(String key, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _controllers[key],
        keyboardType: TextInputType.number,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: "$label (cm)",
          prefixIcon: const Icon(Icons.architecture_outlined),
        ),
        validator: (val) {
          if (val == null || val.trim().isEmpty) return 'Required';
          final num = double.tryParse(val.trim());
          if (num == null || num <= 0 || num > 300) return 'Invalid';
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Body Measurements',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Input your circumferences to analyze symmetry and archetype target ratios.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildField('neck', 'Neck'),
                  _buildField('shoulders', 'Shoulders'),
                  _buildField('chest', 'Chest'),
                  _buildField('backWidth', 'Back Width'),
                  _buildField('biceps', 'Biceps'),
                  _buildField('forearms', 'Forearms'),
                  _buildField('waist', 'Waist'),
                  _buildField('glutes', 'Glutes / Hip'),
                  _buildField('thighs', 'Thighs'),
                  _buildField('calves', 'Calves'),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 58,
                    child: ElevatedButton(
                      onPressed: _next,
                      child: const Text('CONTINUE'),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
