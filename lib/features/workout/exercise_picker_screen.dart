import 'package:flutter/material.dart';
import 'package:kairo/data/database/exercise_database.dart';
import 'package:kairo/core/constants/app_colors.dart';

class ExercisePickerScreen extends StatefulWidget {
  const ExercisePickerScreen({super.key});

  @override
  State<ExercisePickerScreen> createState() => _ExercisePickerScreenState();
}

class _ExercisePickerScreenState extends State<ExercisePickerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedEquipment = "All"; // All, bodyweight, home_gym, full_gym

  final List<String> _muscleTabs = ["All", "Chest", "Back", "Shoulders", "Biceps", "Triceps", "Legs", "Core"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _muscleTabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ExerciseModel> _getFilteredExercises() {
    final activeTab = _muscleTabs[_tabController.index];
    
    // 1. Get base by equipment
    List<ExerciseModel> list = [];
    if (_selectedEquipment == "All") {
      list = List.from(ExerciseDatabase.exercises);
    } else {
      list = ExerciseDatabase.exercises.where((e) => e.equipmentType == _selectedEquipment).toList();
    }

    // 2. Filter by muscle group tab
    if (activeTab != "All") {
      list = list.where((e) => e.muscleGroup.toLowerCase() == activeTab.toLowerCase()).toList();
    }

    // 3. Filter by search query
    if (_searchQuery.isNotEmpty) {
      list = list.where((e) => e.name.toLowerCase().contains(_searchQuery)).toList();
    }

    return list;
  }

  Widget _buildEquipmentFilterChip(String label, String value) {
    final isSelected = _selectedEquipment == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedEquipment = value);
        }
      },
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.black,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exercises = _getFilteredExercises();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Exercise'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: _muscleTabs.map((m) => Tab(text: m)).toList(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Search exercises...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                ),
              ),
            ),

            // Equipment Toggle Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildEquipmentFilterChip('All Equipment', 'All'),
                  const SizedBox(width: 8),
                  _buildEquipmentFilterChip('Bodyweight', 'bodyweight'),
                  const SizedBox(width: 8),
                  _buildEquipmentFilterChip('Home Gym', 'home_gym'),
                  const SizedBox(width: 8),
                  _buildEquipmentFilterChip('Full Gym', 'full_gym'),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Exercise List
            Expanded(
              child: exercises.isEmpty
                  ? const Center(
                      child: Text(
                        'No exercises found',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final e = exercises[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                          leading: Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.fitness_center, color: AppColors.primary),
                          ),
                          title: Text(
                            e.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            "${e.muscleGroup} • ${e.equipmentType.replaceAll('_', ' ').toUpperCase()}",
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                          onTap: () {
                            Navigator.pop(context, e);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
