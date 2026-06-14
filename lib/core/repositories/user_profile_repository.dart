import 'package:kairo/core/services/storage_service.dart';
import 'package:kairo/models/onboarding_data.dart';

/// Persists [OnboardingData] as the single source of truth for the adaptive system.
class UserProfileRepository {
  static const String _profileKey = 'kairo_user_profile';

  static Future<void> save(OnboardingData data) async {
    await StorageService.saveMap(key: _profileKey, value: data.toMap());
  }

  static Future<OnboardingData?> load() async {
    final map = await StorageService.getMap(_profileKey);

    if (map == null) {
      return null;
    }

    return OnboardingData.fromMap(map);
  }

  static Future<bool> hasCompletedProfile() async {
    final profile = await load();

    return profile != null && profile.onboardingCompleted;
  }

  static Future<void> clear() async {
    await StorageService.remove(_profileKey);
  }
}
