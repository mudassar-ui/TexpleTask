import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewTransaction extends StatefulWidget {
  final String mobileRegister;

  NewTransaction({required this.mobileRegister});
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _inputtitleController = TextEditingController();
  final _inputamountController = TextEditingController();
  String? valueChoose;
  final listItems = ['Debit', 'Credit'];

  void _submitData() {
    if (_inputamountController.text.isEmpty) {
      return;
    }
    final inputTitle = _inputtitleController.text;
    final inputAmount = double.parse(_inputamountController.text);

    if (inputTitle.isEmpty || inputAmount <= 0 || valueChoose!.isEmpty) {
      return;
    }

    addTransaction(inputTitle, inputAmount, valueChoose);
    Navigator.of(context).pop();
  }

  //Debit and Credit Post Api Methods

  Future<void> addTransaction(title, amount, value) async {
    String baseUrl = 'http://13.235.89.254:3001';
    var url;
    if (value == 'Credit') {
      url = Uri.parse('$baseUrl/api/credit');
    } else {
      url = Uri.parse('$baseUrl/api/debit');
    }
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "amount": amount.toString(),
          "title": title,
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': widget.mobileRegister,
        },
      );
      var message = jsonDecode(response.body);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    DropdownMenuItem<String> buildMenuItem(String listItem) {
      return DropdownMenuItem(
        value: listItem,
        child: Text(listItem),
      );
    }

    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).size.height + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _inputtitleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _inputamountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              DropdownButton<String>(
                hint: Text('Select'),
                //onTap: _submitData,
                value: valueChoose,
                icon: Icon(Icons.arrow_drop_down),
                items: listItems.map((buildMenuItem)).toList(),
                onChanged: (value) {
                  setState(() {
                    this.valueChoose = value.toString();
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: RaisedButton(
                    onPressed: _submitData,
                    child: Text('Add Transaction'),
                    color: Colors.black,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
