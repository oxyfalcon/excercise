library config;

import 'package:excercise/model/user_model.dart';
import 'package:excercise/utils/database_values.dart';
import 'package:excercise/view/auth_gate/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

part '../model/dataRepository/data_repository.dart';

class Config {
  Config._();

  late final DataRepository _dataRepository;
  late final DatabaseOperations _databaseOperation;

  factory Config() => _obj;
  static final Config _obj = Config._();

  Future<void> createDatabase() async {
    var path = await getDatabasesPath();
    final Database database =
        await openDatabase("$path/pagination.db", version: 1);
    _dataRepository = DataRepository._(database);
    _databaseOperation = DatabaseOperations._(database);
    await _dataRepository._createTable();
  }

  // entry
  Future<void> initialize() async {
    await createDatabase();
    runApp(const AuthGate());
  }
}
