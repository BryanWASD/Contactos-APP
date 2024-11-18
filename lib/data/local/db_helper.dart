import 'package:flutterpwa/data/dtos/response/create_contact_response_dto.dart';
import 'package:flutterpwa/data/models/contact_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseHelper {
  static final LocalDatabaseHelper _instance = LocalDatabaseHelper._internal();
  factory LocalDatabaseHelper() => _instance;

  LocalDatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'contacts.db');

      return await openDatabase(
        path,
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE contacts(id TEXT PRIMARY KEY, nombre TEXT, email TEXT, telefono TEXT)',
          );
        },
        version: 1,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> insertContact(ContactModel contact) async {
    final db = await database;
    await db.insert(
      'contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> saveContacts(List<ContactsResponseDto> contacts) async {
    final db = await database;

    await db.transaction((txn) async {
      for (var contact in contacts) {
        await txn.insert(
          'contacts',
          {
            'id': contact.id,
            'nombre': contact.nombre,
            'email': contact.email,
            'telefono': contact.telefono,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    print('Todos los contactos han sido guardados');
  }

  Future<List<ContactModel>> getLocalContacts() async {
    try {
      final db = await database;
      final result = await db.query('contacts');
      return List.generate(result.length, (i) {
        print(result[i]);
        return ContactModel.fromMap(result[i]);
      });
    } catch (e) {
      print('Error al obtener contactos locales: $e');
      return [];
    }
  }

  Future<void> deleteContact(String id) async {
    final db = await database;
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
