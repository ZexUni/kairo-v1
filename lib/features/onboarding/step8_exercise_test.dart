import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:kairo/features/onboarding/onboarding_controller.dart';
import 'package:kairo/core/constants/app_colors.dart';

class Step8ExerciseTest extends StatefulWidget {
  const Step8ExerciseTest({super.key});

  @override
  State<Step8ExerciseTest> createState() => _Step8ExerciseTestState();
}

class _Step8ExerciseTestState extends State<Step8ExerciseTest> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _pushupsController;
  late TextEditingController _pullupsController;
  late TextEditingController _squatsController;
  late TextEditingController _plankController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final c = Provider.of<OnboardingController>(context, listen: false);
    _pushupsController = TextEditingController(text: c.maxPushups.toString());
    _pullupsController = TextEditingController(text: c.maxPullups.toString());
    _squatsController = TextEditingController(text: c.maxSquats.toString());
    _plankController = TextEditingController(text: c.plankSeconds.toString());
  }

  @override
  void dispose() {
    _pushupsController.dispose();
    _pullupsController.dispose();
    _squatsController.dispose();
    _plankController.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _saving = true);
      try {
        final c = Provider.of<OnboardingController>(context, listen: false);
        c.maxPushups = int.parse(_pushupsController.text.trim());
        c.maxPullups = int.parse(_pullupsController.text.trim());
        c.maxSquats = int.parse(_squatsController.text.trim());
        c.plankSeconds = int.parse(_plankController.text.trim());

        await c.completeOnboarding(context);

        if (mounted) {
          context.go('/dashboard');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to save profile: $e")),
          );
        }
      } finally {
        if (mounted) setState(() => _saving = false);
      }
    }
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
        validator: (val) {
          if (val == null || val.trim().isEmpty) return 'Required';
          final num = int.tryParse(val.trim());
          if (num == null || num < 0 || num > 1000) return 'Invalid number';
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Performance Test',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Input your max repetitions to benchmark your baseline muscular capability.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildField('Max Push-ups', _pushupsController, Icons.sports_gymnastics),
                  _buildField('Max Pull-ups', _pullupsController, Icons.fitness_center),
                  _buildField('Max Squats', _squatsController, Icons.accessibility_new),
                  _buildField('Plank Hold Time (seconds)', _plankController, Icons.timer_outlined),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 58,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _complete,
                      child: _saving
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text('COMPLETE ASSESSMENT'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
