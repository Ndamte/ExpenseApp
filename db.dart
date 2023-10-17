
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';


class ExpenseDatabase {
  // create the database
  static const name = "ExpenseDatabase.db";
  // late Database _database;
  static late Database _database;


  // initialize the database (will OPEN the database)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, name);
    _database = await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
    );
  }


  // create the table 
  static const String expenseTable = "expense";
  static const String expenseId = 'id';
  static const String expenseAmount = 'amount';
  static const String expenseReason = 'reason';
  static const String expenseDescription = 'description';

  static const String incomeTable = "income";
  static const String incomeId = 'id';
  static const String incomeAmount = 'amount';
  static const String incomePeriod = 'period';
  
  Future _onCreate(Database database, int version) async {
    await database.execute('''
        CREATE TABLE $expenseTable (
          $expenseId INTEGER PRIMARY KEY,
          $expenseAmount REAL NOT NULL,
          $expenseReason TEXT,
          $expenseDescription TEXT
        )
        ''');
    await database.execute('''
        CREATE TABLE $incomeTable (
          $incomeId INTEGER PRIMARY KEY,
          $incomeAmount REAL NOT NULL,
          $incomePeriod TEXT NOT NULL
        )
        ''');
    }


  // insert data into the income table
  Future<void> insertIncome(double amount, String period) async {
    await _database.insert(
      'income',
      {
        'amount': amount,
        'period': period,
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
      String path = await getDatabasesPath();
  print(path);
  }


  // insert data into the expense table
  Future<void> insertExpense(double amount, String reason, String description) async {
    await _database.insert(
      'expense',
      {
        'amount': amount,
        'reason': reason,
        'description': description,
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }
}