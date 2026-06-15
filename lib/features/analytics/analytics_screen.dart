import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/data/repositories/workout_repository.dart';
import 'package:kairo/data/models/workout_session.dart';
import 'package:kairo/core/constants/app_colors.dart';
import 'package:kairo/widgets/bottom_nav_bar.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _periodTabController;
  bool _loading = true;
  List<WorkoutSession> _sessions = [];
  double _totalVolume = 0.0;
  int _totalSets = 0;
  int _totalDuration = 0;

  @override
  void initState() {
    super.initState();
    _periodTabController = TabController(length: 3, vsync: this);
    _periodTabController.addListener(_onTabChanged);
    _loadAnalyticsData();
  }

  @override
  void dispose() {
    _periodTabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_periodTabController.indexIsChanging) return;
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final userId = auth.currentUser?.uid ?? 'local_user';

      final workoutRepo = WorkoutRepository();
      
      int days = 7;
      if (_periodTabController.index == 1) days = 30;
      if (_periodTabController.index == 2) days = 90;

      final end = DateTime.now();
      final start = end.subtract(Duration(days: days));

      _sessions = await workoutRepo.getSessionsForPeriod(userId, start, end);

      _totalVolume = 0.0;
      _totalSets = 0;
      _totalDuration = 0;

      for (var s in _sessions) {
        _totalVolume += s.totalVolumeKg;
        _totalSets += s.totalSets;
        _totalDuration += s.durationMinutes;
      }
    } catch (e) {
      debugPrint("Error loading analytics: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Performance Analytics'),
        bottom: TabBar(
          controller: _periodTabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: '7 Days'),
            Tab(text: '30 Days'),
            Tab(text: '90 Days'),
          ],
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  // STATS SUMMARY ROW
                  _buildStatCard('Workouts Completed', '${_sessions.length}', Icons.check_circle_outline, AppColors.success),
                  const SizedBox(height: 12),
                  _buildStatCard('Total Volume Lifted', '${_totalVolume.round()} kg', Icons.fitness_center, AppColors.primary),
                  const SizedBox(height: 12),
                  _buildStatCard('Sets Logged', '$_totalSets', Icons.playlist_add_check, AppColors.secondary),
                  const SizedBox(height: 12),
                  _buildStatCard('Total Duration', '${_totalDuration}m', Icons.timer_outlined, AppColors.warning),
                  const SizedBox(height: 32),

                  // VISUAL DASHBOARD SELECTIONS
                  const Text(
                    'DETAILED ANALYTICS VIEWS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildMenuCard(
                    'Muscle Load Radar',
                    'Analyze set counts against ideal archetype distributions.',
                    Icons.radar,
                    AppColors.primary,
                    () => context.push('/analytics/radar'),
                  ),

                  _buildMenuCard(
                    'Anatomical Heatmap',
                    'Interactive muscle distribution workload maps.',
                    Icons.accessibility_new,
                    AppColors.success,
                    () => context.push('/analytics/body'),
                  ),

                  _buildMenuCard(
                    'Monthly Performance Report',
                    'Year-wide training volume and sets progress reports.',
                    Icons.trending_up,
                    AppColors.secondary,
                    () => context.push('/analytics/report'),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}
