import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:texple/home.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController registerMobile = TextEditingController();

  Future<void> _registerUser() async {
    String baseUrl = 'http://13.235.89.254:3001';
    var url = Uri.parse('$baseUrl/api/transactions');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'user': registerMobile.value.text,
        }),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      var message = json.decode(response.body);

      if (response.statusCode == 200 ||
          message['message'] == 'This mobile number already exists!!!') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                Home(mobileRegister: registerMobile.value.text)));
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moible Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Mobile'),
                  controller: registerMobile,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    onPressed: () {
                      _registerUser();
                    },
                    padding: EdgeInsets.all(20),
                    color: Colors.blue,
                    child: Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
