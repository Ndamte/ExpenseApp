import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ExpenseDatabase {
  // For the User table
  static const String userTable = "user";
  static const String userId = 'id';
  static const String username = 'username';
  static const String password = 'password';

  // For the expense table
  static const String expenseDate = 'expense_date';
  static const String category = 'category';

  // For the Budget table
  static const String budgetTable = "budget";
  static const String budgetId = 'id';
  static const String budgetAmount = 'amount';

  // create the database
  static const name = "ExpenseDatabase.db";
  static late Database _database;

  // Define formatDate here
  static String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    return await _database.query('expense');
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    return await _database.query(userTable);
  }

  Future<List<Map<String, dynamic>>> getIncomes() async {
    return await _database.query(incomeTable);
  }

  Future<List<Map<String, dynamic>>> getBudgets() async {
    return await _database.query(budgetTable);
  }

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
  static const String expenseDescription = 'description';

  static const String incomeTable = "income";
  static const String incomeId = 'id';
  static const String incomeAmount = 'amount';
  static const String incomePeriod = 'period';
  Future _onCreate(Database database, int version) async {
    // Creating the User table first because other tables reference it
    await database.execute(
        '''
        CREATE TABLE $userTable (
          $userId INTEGER PRIMARY KEY,
          $username TEXT NOT NULL UNIQUE,
          $password TEXT NOT NULL  
        )
        ''');

    await database.execute(
        '''
        CREATE TABLE $expenseTable (
          $expenseId INTEGER PRIMARY KEY ,
          $expenseAmount REAL NOT NULL,
          $category TEXT,
          $expenseDescription TEXT,
          $expenseDate TEXT NOT NULL,
          user_id INTEGER,
          FOREIGN KEY (user_id) REFERENCES $userTable($userId)
        )
        ''');

    await database.execute(
        '''
        CREATE TABLE $incomeTable (
          $incomeId INTEGER PRIMARY KEY,
          $incomeAmount REAL NOT NULL,
          $incomePeriod TEXT NOT NULL,
          user_id INTEGER,
          FOREIGN KEY (user_id) REFERENCES $userTable($userId)
        )
        ''');

    await database.execute(
        '''
        CREATE TABLE $budgetTable (
          $budgetId INTEGER PRIMARY KEY,
          $budgetAmount REAL NOT NULL,
          user_id INTEGER,
          FOREIGN KEY (user_id) REFERENCES $userTable($userId)
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
  Future<void> insertExpense(double amount, String category, String description,
      DateTime expenseDate) async {
    String formattedDate =
        ExpenseDatabase.formatDate(expenseDate); // Convert DateTime to String
    await _database.insert(
      'expense',
      {
        'amount': amount,
        'category': category,
        'description': description,
        'expense_date': formattedDate,
      },
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
    print("Data inserted successfully");
  }
}
