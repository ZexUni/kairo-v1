import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kairo/features/onboarding/onboarding_controller.dart';
import 'package:kairo/core/constants/app_colors.dart';

class Step6StressQna extends StatefulWidget {
  const Step6StressQna({super.key});

  @override
  State<Step6StressQna> createState() => _Step6StressQnaState();
}

class _Step6StressQnaState extends State<Step6StressQna> {
  final List<String> _questions = [
    "How stressful is your work/study?",
    "Do you feel mentally exhausted often?",
    "How well do you manage stress?",
    "Do you practice relaxation techniques?",
    "How often do you feel overwhelmed?",
    "Do you have strong social support?",
    "How often do you feel anxious?",
    "Do you get enough personal time?",
    "Do you feel in control of your life?",
    "Rate your overall stress level."
  ];

  late List<double> _answers;

  @override
  void initState() {
    super.initState();
    final c = Provider.of<OnboardingController>(context, listen: false);
    _answers = List<double>.from(c.stressAnswers);
  }

  void _next() {
    final c = Provider.of<OnboardingController>(context, listen: false);
    c.stressAnswers = List<double>.from(_answers);
    c.nextStep();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Stress Q&A',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Answer the stress questionnaire (1 = low stress, 5 = high stress).',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _questions.length + 1,
              itemBuilder: (context, index) {
                if (index == _questions.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 40.0),
                    child: SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _next,
                        child: const Text('CONTINUE'),
                      ),
                    ),
                  );
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  color: AppColors.card,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${index + 1}. ${_questions[index]}",
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text('1', style: TextStyle(color: AppColors.textSecondary)),
                            Expanded(
                              child: Slider(
                                value: _answers[index],
                                min: 1.0,
                                max: 5.0,
                                divisions: 4,
                                label: _answers[index].round().toString(),
                                onChanged: (val) {
                                  setState(() => _answers[index] = val);
                                },
                              ),
                            ),
                            const Text('5', style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
