import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// TODO: Importer le modèle Exercise après sa création
// import 'package:matheasy_sn/domain/entities/exercise.dart';

/// Service de gestion de la base de données locale SQLite.
///
/// Gère la création de la base de données, la création des tables,
/// et les opérations CRUD (Create, Read, Update, Delete) pour les données
/// de l'application, comme les exercices.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  /// Récupère l'instance de la base de données.
  ///
  /// Initialise la base de données si elle ne l'est pas déjà.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialise la connexion à la base de données SQLite.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'matheasy.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Crée les tables de la base de données lors de sa première création.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE exercises (
        id TEXT PRIMARY KEY,
        chapterSlug TEXT,
        question TEXT,
        type TEXT,
        options TEXT, -- JSON-encoded list of strings for QCM
        correctAnswer TEXT
      )
    ''');
  }

  /// Insère une liste d'exercices dans la base de données.
  ///
  /// Utilise une transaction pour assurer l'atomicité de l'opération.
  Future<void> insertExercises(List<Map<String, dynamic>> exercises) async {
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final exercise in exercises) {
        batch.insert('exercises', exercise, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit();
    });
  }

  /// Récupère tous les exercices pour un chapitre donné.
  Future<List<Map<String, dynamic>>> getExercisesForChapter(String chapterSlug) async {
    final db = await database;
    return await db.query(
      'exercises',
      where: 'chapterSlug = ?',
      whereArgs: [chapterSlug],
    );
  }
}