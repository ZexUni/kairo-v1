import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/data/repositories/user_repository.dart';
import 'package:kairo/data/models/user_profile.dart';
import 'package:kairo/core/constants/app_colors.dart';
import 'package:kairo/widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final userId = auth.currentUser?.uid ?? 'local_user';

      final userRepo = UserRepository();
      _profile = await userRepo.getProfile(userId);
    } catch (e) {
      debugPrint("Error loading profile: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signOut() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.signOut();
    if (mounted) {
      context.go('/login');
    }
  }

  Widget _buildProfileTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _profile == null
                ? Center(
                    child: ElevatedButton(
                      onPressed: () => context.go('/onboarding'),
                      child: const Text('COMPLETE ONBOARDING'),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(24.0),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // PROFILE HEADER CARD
                      Center(
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(Icons.person, color: Colors.black, size: 55),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _profile!.name,
                              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _profile!.gender,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // PROFILE STAT TILES
                      _buildProfileTile(Icons.calendar_today, 'Age', '${_profile!.age} years'),
                      _buildProfileTile(Icons.height, 'Height', '${_profile!.heightCm.round()} cm'),
                      _buildProfileTile(Icons.monitor_weight_outlined, 'Weight', '${_profile!.weightKg.toStringAsFixed(1)} kg'),
                      _buildProfileTile(Icons.fitness_center, 'Training Level / Mode', _profile!.equipmentMode.name.toUpperCase()),
                      _buildProfileTile(Icons.track_changes, 'Primary Goal', _profile!.primaryGoal.name.toUpperCase()),
                      const SizedBox(height: 32),

                      // Sign Out Button
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _signOut,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.danger,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'SIGN OUT',
                            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }
}
