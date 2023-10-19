import 'package:flutter/material.dart';
import 'database/db.dart';
import 'add_income.dart'; // Import your AddIncomePage
import 'add_expense.dart'; // Import your AddExpensePage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await database.init();
  runApp(ExpenseTrackerApp());
}

final database = ExpenseDatabase();

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: ExpenseDashboard(),
    );
  }
}

class ExpenseDashboard extends StatefulWidget {
  @override
  _ExpenseDashboardState createState() => _ExpenseDashboardState();
}

class _ExpenseDashboardState extends State<ExpenseDashboard> {
  double weeklyIncome = 1000.0;
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> incomes = [];
  List<Map<String, dynamic>> total = [];

  double e_total = 0;
  double i_total = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    expenses = await database.getExpenses();
    incomes = await database.getIncomes();
    for (final expense in expenses) {
      e_total += expense['amount'];
    }
    for (final income in incomes) {
      i_total += income['amount'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker Dashboard'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: Text('Add Income'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddIncomePage()), // Navigate to AddIncomePage
                );
              },
            ),
            ListTile(
              title: Text('Add Expense'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddExpensePage()), // Navigate to AddExpensePage
                );
              },
            ),
            // Add more menu items as needed
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Expenses',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '\$${e_total}',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Income',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '\$${i_total}',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // ... (other code) ...
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add expense functionality here
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // ... (other code) ...
}

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final double amountSpent;
  final Color color;

  CategoryCard({
    required this.categoryName,
    required this.amountSpent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width * 0.28,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            categoryName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '\$$amountSpent',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String transactionName;
  final double amount;
  final String date;
  final IconData icon;
  final Color categoryColor;

  TransactionCard({
    required this.transactionName,
    required this.amount,
    required this.date,
    required this.icon,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 45,
          color: categoryColor,
        ),
        title: Text(
          transactionName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          date,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: Text(
          '\$$amount',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
