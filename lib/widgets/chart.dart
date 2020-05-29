import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transaction_app/models/transaction.dart';
import 'package:transaction_app/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> transactions;

  Chart({@required this.transactions, Key key}) : super(key: key);

  double get _totalSpending {
    return transactions.fold(0.0, (acc, e) => acc + e.amount);
  }

  List<Map<String, Object>> get _groupedTransactionValues {
    return List.generate(7, (i) {
      final weekDay = DateTime.now().subtract(Duration(days: i));
      final amount = transactions
          .where((e) =>
              DateFormat.yMMMd().format(e.date) ==
              DateFormat.yMMMd().format(weekDay))
          .fold(0.0, (acc, e) => acc + e.amount);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': amount,
        'percent': _totalSpending == 0.0 ? 0.0 : amount / _totalSpending,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _groupedTransactionValues.map((t) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                amount: t['amount'],
                label: t['day'],
                percent: t['percent'],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
