part of '../../utils/config.dart';

class DataRepository {
  final Database database;

  factory DataRepository() => Config()._dataRepository;

  DataRepository._(this.database);

  Future<void> _createTable() async {
    await database.execute('''CREATE TABLE IF NOT EXISTS $tableName(
              id INTEGER PRIMARY KEY, 
              ${TableColumn.title.name} TEXT, 
              ${TableColumn.fiscalYear.name} INTEGER,
              ${TableColumn.pageNumber.name} INTEGER,
              ${TableColumn.artistDisplay.name} TEXT)''');
  }
}

class DatabaseOperations {
  final Database database;

  factory DatabaseOperations() => Config()._databaseOperation;

  DatabaseOperations._(this.database);

  Future<void> insertUserModelToDb(List<UserModel> list, int pageNumber) async {
    await database.rawDelete(
        '''DELETE FROM $tableName WHERE ${TableColumn.pageNumber.name} = ?''');
    await Future.wait(list.map((user) async {
      await database.insert(
          tableName,
          {
            TableColumn.pageNumber.name: user.pageNumber.toString(),
            TableColumn.fiscalYear.name: user.fiscalYear,
            TableColumn.title.name: user.title,
            TableColumn.artistDisplay.name: user.artistDisplay
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    }));
  }

  Future<List<UserModel>> getUserModelFromDb(int pageNumber) async {
    List<Map<String, dynamic>> items = await database.rawQuery(
        '''SELECT * FROM $tableName WHERE ${TableColumn.pageNumber.name}=$pageNumber''');
    List<UserModel> userList = [];
    for (var item in items) {
      userList.add(UserModel.fromJson(
          item,
          item[TableColumn.pageNumber.name] is int
              ? item[TableColumn.pageNumber.name]
              : pageNumber));
    }
    return userList;
  }

  Future<void> deleteAll() async{
    await database.delete(tableName);
  }
}
