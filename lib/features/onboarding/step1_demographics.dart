import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kairo/features/onboarding/onboarding_controller.dart';
import 'package:kairo/core/constants/app_colors.dart';

class Step1Demographics extends StatefulWidget {
  const Step1Demographics({super.key});

  @override
  State<Step1Demographics> createState() => _Step1DemographicsState();
}

class _Step1DemographicsState extends State<Step1Demographics> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  String _gender = 'Male';

  @override
  void initState() {
    super.initState();
    final controller = Provider.of<OnboardingController>(context, listen: false);
    _nameController = TextEditingController(text: controller.name);
    _ageController = TextEditingController(text: controller.age.toString());
    _heightController = TextEditingController(text: controller.heightCm.toString());
    _weightController = TextEditingController(text: controller.weightKg.toString());
    _gender = controller.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _next() {
    if (_formKey.currentState!.validate()) {
      final controller = Provider.of<OnboardingController>(context, listen: false);
      controller.name = _nameController.text.trim();
      controller.age = int.parse(_ageController.text.trim());
      controller.gender = _gender;
      controller.heightCm = double.parse(_heightController.text.trim());
      controller.weightKg = double.parse(_weightController.text.trim());
      controller.nextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tell us about yourself',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Let\'s build your baseline physiological profile.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              // Name Input
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              // Age Input
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Age',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Age is required';
                  final age = int.tryParse(val.trim());
                  if (age == null || age <= 0 || age > 120) return 'Please enter a valid age';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Gender Selection Row
              const Text(
                'Gender',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Male'),
                      selected: _gender == 'Male',
                      onSelected: (selected) {
                        if (selected) setState(() => _gender = 'Male');
                      },
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.black,
                      labelStyle: TextStyle(
                        color: _gender == 'Male' ? Colors.black : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Female'),
                      selected: _gender == 'Female',
                      onSelected: (selected) {
                        if (selected) setState(() => _gender = 'Female');
                      },
                      selectedColor: AppColors.primary,
                      checkmarkColor: Colors.black,
                      labelStyle: TextStyle(
                        color: _gender == 'Female' ? Colors.black : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Height & Weight row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Height (cm)',
                        prefixIcon: Icon(Icons.height),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Required';
                        final num = double.tryParse(val.trim());
                        if (num == null || num < 50 || num > 250) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Weight (kg)',
                        prefixIcon: Icon(Icons.monitor_weight_outlined),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Required';
                        final num = double.tryParse(val.trim());
                        if (num == null || num < 10 || num > 300) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: _next,
                  child: const Text('CONTINUE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
