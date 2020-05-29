import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transaction_app/models/transaction.dart';

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
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
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
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final t = transactions[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('\$${t.amount.toStringAsFixed(2)}'),
                      ),
                    ),
                  ),
                  title: Text(
                    t.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(DateFormat.yMMMd().format(t.date)),
                  trailing: screenWidth > 360
                      ? FlatButton.icon(
                          textColor: Theme.of(context).errorColor,
                          onPressed: () {
                            onDeleteTranaction(t.id);
                          },
                          icon: Icon(Icons.delete),
                          label: Text('Delete'),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () {
                            onDeleteTranaction(t.id);
                          },
                        ),
                ),
              );
            },
          );
  }
}
