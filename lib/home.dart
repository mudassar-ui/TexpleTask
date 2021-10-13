import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:texple/NewTransaction.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final String mobileRegister;

  Home({required this.mobileRegister});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _transaction = [];
  Map _balance = {};

  @override
  void initState() {
    _getTransaction();
    _getBalance();
    setState(() {});

    super.initState();
  }

//List Tiles Widget

  Widget listTiles({String? title, String? amount}) {
    return Column(
      children: [
        Card(
          elevation: 1,
          child: ListTile(
            title: Text(
              title!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              amount!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

// Botto Modal sheet
  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(mobileRegister: widget.mobileRegister);
        });

    setState(() {});
  }

  //Get Transactions List

  Future<dynamic> _getTransaction() async {
    String baseUrl = 'http://13.235.89.254:3001';
    var url = Uri.parse('$baseUrl/api/transactions');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': widget.mobileRegister,
        },
      );

      var transaction = json.decode(response.body);

      _transaction = transaction['transactions'];

      setState(() {});
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<dynamic> _getBalance() async {
    String baseUrl = 'http://13.235.89.254:3001';
    var url = Uri.parse('$baseUrl/api/balance');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': widget.mobileRegister,
        },
      );

      var balance = json.decode(response.body);

      _balance = balance;

      setState(() {});
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: double.infinity,
                margin: EdgeInsets.all(20),
                //color: Colors.white,
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  border: Border.all(color: Colors.pink),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Center(
                    child: Text(
                  'Total Balance : ${_balance['balance']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white30,
                ),
                child: ListView.builder(
                    itemCount: _transaction.length,
                    itemBuilder: (context, index) {
                      return listTiles(
                        title: _transaction[index]['title'],
                        amount:
                            _transaction[index]['transactionAmount'].toString(),
                      );
                    }),
              ),
              FloatingActionButton(
                onPressed: () {
                  startAddNewTransaction(context);
                },
                child: Icon(
                  Icons.add,
                  size: 50,
                ),
                backgroundColor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
