import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:persistence_sqflite/student.dart';
import 'package:sqflite/sqflite.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'students.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE students(id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, age INTEGER)',
      );
    },
    version: 1,
  );

  Future<void> insertStudent(Student student) async {
    final db = await database; // recuperer une reference a la base de donnees

    await db.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Student>> students() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('students');

    return List.generate(maps.length, (i) {
      return Student(
        id: maps[i]['id'] as int,
        first_name: maps[i]['first_name'] as String,
        last_name: maps[i]['last_name'] as String,
        age: maps[i]['age'] as int,
      );
    });
  }

  Future<void> updateStudent(Student student) async {
    final db = await database;

    await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<void> deleteStudent(int id) async{
    final db = await database;

    await db.delete('students', where: 'id = ?', whereArgs: [id],);
  }

  // Creer un etudiant
  var student1 = const Student(id: 0, first_name: 'John', last_name: 'Doe', age: 17);
  await insertStudent(student1);

  print (await students() ); // Recuperer et afficher la liste de tous les etudiants

  student1 = Student(id: student1.id, first_name: student1.first_name, last_name: student1.last_name, age: student1.age + 1);

  await updateStudent(student1); // Mette a jour l'etudiant

  print(await students()); // Recuperer et afficher les resultats mis a jour

  await deleteStudent(student1.id); // Supprimer l'etudiant de la base de donnees

  print(await students()); // Afficher la listye des etudiants



}
