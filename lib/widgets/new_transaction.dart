import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function(String, double, DateTime) onAddTransaction;

  NewTransaction({@required this.onAddTransaction, Key key}) : super(key: key);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  DateTime _date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          TextField(
            controller: _titleCtrl,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _amountCtrl,
            decoration: InputDecoration(labelText: 'Amount'),
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _submitData(),
          ),
          Container(
            height: 75,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _date == null
                        ? 'No Date Chosen'
                        : 'Picked Date: ${DateFormat.yMMMd().format(_date)}',
                  ),
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    'Choose Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _presentDatePicker,
                ),
              ],
            ),
          ),
          RaisedButton(
            child: Text(
              'Add Transaction',
            ),
            textColor: Theme.of(context).textTheme.button.color,
            color: Theme.of(context).primaryColor,
            onPressed: _submitData,
          ),
        ],
      ),
    );
  }

  Future<void> _presentDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date == null) {
      return;
    }
    setState(() {
      _date = date;
    });
  }

  void _submitData() {
    final title = _titleCtrl.text;
    final amount = double.tryParse(_amountCtrl.text);
    if (title.isEmpty || amount == null || amount <= 0 || _date == null) {
      return;
    }
    widget.onAddTransaction(
      _titleCtrl.text,
      double.tryParse(_amountCtrl.text),
      _date,
    );
  }
}
