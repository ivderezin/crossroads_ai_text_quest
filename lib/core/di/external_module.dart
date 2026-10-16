import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class ExternalModule {
  @lazySingleton
  Dio get dio => Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      // A big model with thinking can spend a couple of minutes on a scene.
      receiveTimeout: const Duration(minutes: 3),
      contentType: Headers.jsonContentType,
    ),
  );

  @lazySingleton
  SharedPreferencesAsync get preferences => SharedPreferencesAsync();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}
