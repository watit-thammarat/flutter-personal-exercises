import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transaction_app/models/transaction.dart';

const availableColors = [
  Colors.red,
  Colors.black,
  Colors.blue,
  Colors.purple,
];

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.onDeleteTranaction,
  }) : super(key: key);

  final Transaction transaction;
  final Function(String) onDeleteTranaction;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _backgroundColor;

  @override
  void initState() {
    super.initState();

    _backgroundColor =
        availableColors[Random().nextInt(availableColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _backgroundColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\$${widget.transaction.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(DateFormat.yMMMd().format(widget.transaction.date)),
        trailing: screenWidth > 360
            ? FlatButton.icon(
                textColor: Theme.of(context).errorColor,
                onPressed: () {
                  widget.onDeleteTranaction(widget.transaction.id);
                },
                icon: Icon(Icons.delete),
                label: Text('Delete'),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  widget.onDeleteTranaction(widget.transaction.id);
                },
              ),
      ),
    );
  }
}