import 'package:contacts/models/contact.model.dart';
import 'package:contacts/settings.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactRepository {
  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_NAME),
      onCreate: (db, version) {
        db.execute(CREATE_CONTACTS_TABLE_SCRIPT);
      },
      version: 1,
    );
  }

  Future create(ContactModel model) async {
    try {
      final Database db = await _getDatabase();

      await db.insert(
        TABLE_NAME,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (err) {
      print(err);
    }
  }

  Future<List<ContactModel>> getContacts() async {
    try {
      final Database db = await _getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);

      return List.generate(
        maps.length,
        (index) => ContactModel.fromJson(maps[index]),
      );
    } catch (err) {
      print(err);
      return List();
    }
  }

  Future<List<ContactModel>> search(String term) async {
    try {
      final Database db = await _getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        TABLE_NAME,
        where: 'name LIKE ?',
        whereArgs: ['%$term%'],
      );

      return List.generate(
        maps.length,
        (index) => ContactModel.fromJson(maps[index]),
      );
    } catch (err) {
      print(err);
      return List();
    }
  }

  Future<ContactModel> getContact(int id) async {
    try {
      final Database db = await _getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(
        TABLE_NAME,
        where: 'id = ?',
        whereArgs: [id],
      );

      return ContactModel.fromJson(maps.first);
    } catch (err) {
      print(err);
      return ContactModel();
    }
  }

  Future update(ContactModel model) async {
    try {
      final Database db = await _getDatabase();

      await db.update(
        TABLE_NAME,
        model.toMap(),
        where: 'id = ?',
        whereArgs: [model.id],
      );
    } catch (err) {
      print(err);
    }
  }

  Future delete(int id) async {
    try {
      final Database db = await _getDatabase();

      await db.delete(
        TABLE_NAME,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (err) {
      print(err);
    }
  }

  Future updateImage(int id, String imagePath) async {
    try {
      final Database db = await _getDatabase();
      final model = await getContact(id);

      model.image = imagePath;

      await db.update(
        TABLE_NAME,
        model.toMap(),
        where: 'id = ?',
        whereArgs: [model.id],
      );
    } catch (err) {
      print(err);
    }
  }
}
