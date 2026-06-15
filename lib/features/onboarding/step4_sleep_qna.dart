import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kairo/features/onboarding/onboarding_controller.dart';
import 'package:kairo/core/constants/app_colors.dart';

class Step4SleepQna extends StatefulWidget {
  const Step4SleepQna({super.key});

  @override
  State<Step4SleepQna> createState() => _Step4SleepQnaState();
}

class _Step4SleepQnaState extends State<Step4SleepQna> {
  final List<String> _questions = [
    "How many hours do you sleep on average?",
    "Do you sleep and wake at consistent times?",
    "How rested do you feel upon waking?",
    "Do you use screens before bed?",
    "How often do you wake up during the night?",
    "Do you nap during the day?",
    "How long does it take you to fall asleep?",
    "Do you feel sleepy during the day?",
    "Do you dream regularly?",
    "Rate your overall sleep quality."
  ];

  late List<double> _answers;

  @override
  void initState() {
    super.initState();
    final c = Provider.of<OnboardingController>(context, listen: false);
    _answers = List<double>.from(c.sleepAnswers);
  }

  void _next() {
    final c = Provider.of<OnboardingController>(context, listen: false);
    c.sleepAnswers = List<double>.from(_answers);
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
            'Sleep Q&A',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Answer the sleep questionnaire (1 = poor/rarely, 5 = excellent/always).',
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
