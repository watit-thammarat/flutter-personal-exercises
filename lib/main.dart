import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transaction_app/models/transaction.dart';
import 'package:transaction_app/widgets/chart.dart';
import 'package:transaction_app/widgets/new_transaction.dart';
import 'package:transaction_app/widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              button: TextStyle(
                color: Colors.white,
              ),
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];
  var _showChart = true;

  List<Transaction> get _recentTransactions {
    return _transactions
        .where(
            (tx) => tx.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('==> didChangeAppLifecycleState');
    print(state);
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final tx = Transaction(
      id: DateTime.now().toString(),
      amount: amount,
      title: title,
      date: date,
    );
    setState(() {
      _transactions.add(tx);
    });
    Navigator.of(context).pop();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (ctx) {
        return NewTransaction(onAddTransaction: _addNewTransaction);
      },
    );
  }

  Widget _buildSwitich() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Show Chart', style: Theme.of(context).textTheme.headline6),
        Switch.adaptive(
          activeColor: Theme.of(context).accentColor,
          value: _showChart,
          onChanged: (value) {
            setState(() {
              _showChart = value;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? _buildCupertinoNavigationBar(context)
        : _buidAppBar(context);
    final mq = MediaQuery.of(context);
    final landscape = mq.orientation == Orientation.landscape;
    final availableHeight =
        mq.size.height - mq.padding.top - appBar.preferredSize.height;

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (landscape) _buildSwitich(),
            if (!landscape || _showChart)
              _buildChart(availableHeight, landscape),
            if (!landscape || !_showChart)
              _buildTransactionList(availableHeight),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                _startAddNewTransaction(context);
              },
            ),
          );
  }

  AppBar _buidAppBar(BuildContext context) {
    return AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _startAddNewTransaction(context);
          },
        ),
      ],
    );
  }

  CupertinoNavigationBar _buildCupertinoNavigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () {
              _startAddNewTransaction(context);
            },
          )
        ],
      ),
    );
  }

  Widget _buildTransactionList(double availableHeight) {
    return Container(
      height: availableHeight * 0.7,
      child: TransactionList(
        transactions: _transactions,
        onDeleteTranaction: _deleteTransaction,
      ),
    );
  }

  Widget _buildChart(double availableHeight, bool landscape) {
    return Container(
      height: availableHeight * (landscape ? 0.7 : 0.3),
      child: Chart(transactions: _recentTransactions),
    );
  }
}
