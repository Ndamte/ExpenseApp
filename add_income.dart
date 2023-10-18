import 'package:expense_tracker_app/db.dart';
import 'package:expense_tracker_app/dbtest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard.dart';

enum PayPeriod { weekly, monthly }

final database = ExpenseDatabase();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await database.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: IncomePage(), // This is the renamed AddExpensePageState.
    ),
  );
}

class DataModel {
  double? incomeAmount;
  PayPeriod? incomePayPeriod;
}

class DataProvider with ChangeNotifier {
  DataModel data = DataModel();

  // ... you can add methods or logic here if needed
}

class IncomePage extends StatelessWidget {
  // Renamed from AddExpensePageState
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark, // Set the theme mode to dark
      darkTheme: ThemeData.dark(), // Use the dark theme
      title: 'Add Expense ',

      home: AddIncomePage(),
    );
  }
}

class AddIncomePage extends StatefulWidget {
  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final database = ExpenseDatabase();
  String amount = "";
  PayPeriod? _selectedPayPeriod;

  final resetField = TextEditingController();
  void resetData() {
    setState(() {
      amount = ""; // reset amount
      _selectedPayPeriod = null; // reset selected pay period
      resetField.clear(); // clear the TextField using its controller
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Income"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExpenseDashboard()),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewDataPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: resetField,
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
            SizedBox(height: 40),
            Row(
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
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedPayPeriod != null && amount.isNotEmpty) {
                      double? parsedAmount = double.tryParse(amount);
                      if (parsedAmount != null) {
                        String parsePayPeriod =
                            _selectedPayPeriod.toString().split('.')[1];
                        await database.insertIncome(
                            parsedAmount, parsePayPeriod);
                        resetData();
                        print("Income inserted sucessfully");
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
