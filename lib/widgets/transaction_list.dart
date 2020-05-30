import 'package:flutter/material.dart';
import 'package:transaction_app/models/transaction.dart';
import 'package:transaction_app/widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String) onDeleteTranaction;

  const TransactionList({
    @required this.transactions,
    @required this.onDeleteTranaction,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No Transactions added yet',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: constraints.maxHeight * .6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView(
            children: transactions.map((t) {
              return TransactionItem(
                key: ValueKey(t.id),
                transaction: t,
                onDeleteTranaction: onDeleteTranaction,
              );
            }).toList(),
          );
    // : ListView.builder(
    //     itemCount: transactions.length,
    //     itemBuilder: (context, index) {
    //       final t = transactions[index];
    //       return TransactionItem(
    //         key: ValueKey(t.id),
    //         transaction: t,
    //         onDeleteTranaction: onDeleteTranaction,
    //       );
    //     },
    //   );
  }
}
