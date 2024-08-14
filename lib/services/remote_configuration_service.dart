import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(minutes: 1),
    ));
    await _fetchAndActivate();
  }

  Future<void> _fetchAndActivate() async {
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      // Handle fetch errors
      print('Failed to fetch remote config: $e');
    }
  }

  bool get showDiscountPrice {
    return _remoteConfig.getBool('show_discount_price');
  }
}
