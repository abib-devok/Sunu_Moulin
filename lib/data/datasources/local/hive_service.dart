import 'package:hive_flutter/hive_flutter.dart';
import 'package:matheasy_sn/domain/entities/user_progress.dart';

/// Service pour gérer l'initialisation et la configuration de Hive.
class HiveService {
  /// Initialise Hive, son répertoire et enregistre les adaptateurs de type.
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserProgressAdapter());
  }

  /// Ouvre la boîte (box) pour stocker les progrès de l'utilisateur.
  static Future<Box<UserProgress>> openProgressBox() async {
    return await Hive.openBox<UserProgress>('user_progress');
  }
}