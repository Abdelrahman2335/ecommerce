import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  /// if you want to get one instance from the remove config and don't call it many times,
  /// one: you have to make the Constructor private.
  /// two: you have to make a static final variable. (static) shared everywhere, and final because you don't want to change it.
  /// three: you have to make a factory constructor.
  static final RemoteConfigService _instance = RemoteConfigService._internal();

  factory RemoteConfigService() => _instance;

  RemoteConfigService._internal();

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  initRemoteConfig() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await remoteConfig.fetchAndActivate();

    /// Fetch the latest values from Firebase.
  }
}
