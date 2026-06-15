import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kairo/features/onboarding/onboarding_controller.dart';
import 'package:kairo/core/constants/app_colors.dart';

class Step3LifestyleQna extends StatefulWidget {
  const Step3LifestyleQna({super.key});

  @override
  State<Step3LifestyleQna> createState() => _Step3LifestyleQnaState();
}

class _Step3LifestyleQnaState extends State<Step3LifestyleQna> {
  final List<String> _questions = [
    "How often do you eat protein-rich meals per day?",
    "How many meals do you eat per day?",
    "How often do you eat processed food?",
    "How many glasses of water do you drink daily?",
    "How many servings of vegetables do you eat daily?",
    "Do you track your food intake?",
    "How often do you eat out?",
    "Do you eat breakfast regularly?",
    "How much fruit do you eat daily?",
    "Do you supplement (protein, vitamins)?"
  ];

  late List<double> _answers;

  @override
  void initState() {
    super.initState();
    final c = Provider.of<OnboardingController>(context, listen: false);
    _answers = List<double>.from(c.nutritionAnswers);
  }

  void _next() {
    final c = Provider.of<OnboardingController>(context, listen: false);
    c.nutritionAnswers = List<double>.from(_answers);
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
            'Nutrition Q&A',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Answer the nutrition questionnaire (1 = low, 5 = high).',
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
