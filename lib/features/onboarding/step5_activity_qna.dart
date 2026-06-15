import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kairo/features/onboarding/onboarding_controller.dart';
import 'package:kairo/core/constants/app_colors.dart';

class Step5ActivityQna extends StatefulWidget {
  const Step5ActivityQna({super.key});

  @override
  State<Step5ActivityQna> createState() => _Step5ActivityQnaState();
}

class _Step5ActivityQnaState extends State<Step5ActivityQna> {
  final List<String> _questions = [
    "How many steps do you walk per day?",
    "How many days per week do you do cardio?",
    "How many hours per day are you sedentary?",
    "How physically demanding is your job?",
    "Do you use stairs or elevators?",
    "How often do you do sports?",
    "How active are your weekends?",
    "Do you cycle or walk for transport?",
    "How many hours of light activity per day?",
    "Do you have an active hobby?"
  ];

  late List<double> _answers;

  @override
  void initState() {
    super.initState();
    final c = Provider.of<OnboardingController>(context, listen: false);
    _answers = List<double>.from(c.activityAnswers);
  }

  void _next() {
    final c = Provider.of<OnboardingController>(context, listen: false);
    c.activityAnswers = List<double>.from(_answers);
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
            'Activity Q&A',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Answer the physical activity questionnaire (1 = sedentary/rarely, 5 = active/always).',
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
