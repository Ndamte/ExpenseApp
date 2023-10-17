import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'db.dart';

enum PayPeriod { weekly, monthly }

final database = ExpenseDatabase();

void initState() async {
  WidgetsFlutterBinding.ensureInitialized();
  await database.init();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await database.init();
  runApp(
    ChangeNotifierProvider(
          create: (context) => DataProvider(), 
          child: MyApp()),
  );
}
    

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Expenses',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green[800],
        brightness: Brightness.dark,
      ),
      home: AddIncomePage(),
    );
  }
}

class DataModel {
  double? incomeAmount;
  PayPeriod? incomePayPeriod;
  double? expenseAmount;
  String? expenseCategory;
}

class DataProvider with ChangeNotifier {
  DataModel data = DataModel();

  // ... you can add methods or logic here if needed
}

class AddIncomePage extends StatefulWidget {
  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final database = ExpenseDatabase();
  String amount = "";
  PayPeriod? _selectedPayPeriod;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Income"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpensePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flexible(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money),
                  labelText: 'Amount',
                  hintText: 'Enter Amount',
                  suffixText: 'USD',
                ),
                onChanged: (value) {
                  setState(() {
                    amount = value;
                  });
                },
              ),
            ),
            SizedBox(height: 40),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Pay Period: ',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Radio<PayPeriod>(
                    value: PayPeriod.weekly,
                    groupValue: _selectedPayPeriod,
                    onChanged: (PayPeriod? value) {
                      setState(() {
                        _selectedPayPeriod = value;
                      });
                    },
                    activeColor: Colors.green[800],
                  ),
                  Text('Weekly'),
                  Radio<PayPeriod>(
                    value: PayPeriod.monthly,
                    groupValue: _selectedPayPeriod,
                    onChanged: (PayPeriod? value) {
                      setState(() {
                        _selectedPayPeriod = value;
                      });
                    },
                    activeColor: Colors.green[800],
                  ),
                  Text('Monthly'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Flexible(
              child: Center(
                child: Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_selectedPayPeriod != null && amount.isNotEmpty) {
                        double? parsedAmount = double.tryParse(amount);
                        if (parsedAmount != null) {
                          // Save to SQLite here
                          String parsePayPeriod = _selectedPayPeriod.toString().split('.')[1];
                          await database.insertIncome(parsedAmount, parsePayPeriod);

                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      minimumSize: Size(double.infinity, 40),
                    ),
                    child: Text('Submit'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddExpensePage extends StatefulWidget {
  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final database = ExpenseDatabase();
  String amount = "";
  String reason = "";
  String description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expenses"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.attach_money),
                labelText: 'Amount',
                hintText: 'Enter Amount',
                suffixText: 'USD',
              ),
              onChanged: (value) {
                setState(() {
                  amount = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(FontAwesomeIcons.piggyBank),
                labelText: 'Category',
                hintText: 'Enter Category',
              ),
              onChanged: (value) {
                setState(() {
                  reason = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.note),
                labelText: 'Description',
                hintText: 'Enter Description',
              ),
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    if (reason.isNotEmpty && amount.isNotEmpty) {
                      double? parsedAmount = double.tryParse(amount);
                      if (parsedAmount != null) {
                        // Save to SQLite here
                        await database.insertExpense(parsedAmount, reason, description);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    minimumSize: Size(double.infinity, 40),
                  ),
                  child: Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
