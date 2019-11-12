import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'MemberPage.dart';
import 'AddGarage.dart';
import 'GoogleMapPage.dart';
import 'PlacesExample.dart';


void main() => runApp(new MyApp());
String userid = '';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rent Your Garage',
        home: new MyHomePage(),
        routes: <String, WidgetBuilder>{
          '/MemberPage': (BuildContext context) => new MemberPage( userid: userid ),
          '/GoogleMapPage': (BuildContext context) => new GoogleMapPage(),
          '/PlacesExample': (BuildContext context) => new PlacesExample(),
          '/MyHomePage': (BuildContext context) => new MyHomePage(),
          '/SignUpPage': (BuildContext context) => new SignUpPage(),
          '/AddGarage': (BuildContext context) => new AddGarage( userid: userid )
        }
      );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  String msg = '';

  Future<String> _login() async {
    final response =
        await http.post("http://patrongeldi.com/garaj/api/actions", body: {
      "action": "login",
      "email": email.text,
      "password": password.text,
    });

    var datauser = json.decode(response.body);
    //print(datauser["status"]);

    if (datauser["status"] == "error") {
      String type = 'Error';
      String text = 'Account not found!';
      _showMaterialDialog(type, text);
    }

    if (datauser['status'] == 'ok') {
      setState(() {
        userid = datauser['user_id'];
      });
      Navigator.pushReplacementNamed(context, '/MemberPage');
    }
    return datauser['status'];
  }

  void _showMaterialDialog(type, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(type),
            content: Text(text),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Login"),),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage('http://patrongeldi.com/garaj/img/bg2.jpg'),
              fit: BoxFit.cover),
        ),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Text(
                "LOGIN",
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              ),
              SizedBox(
                height: 50.0,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50.0,
              ),
              Column(
                children: <Widget>[
                  RaisedButton(
                    padding: EdgeInsets.all(20),
                    color: Colors.greenAccent,
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _login();
                    },
                  ),
                  SizedBox(height: 25.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/SignUpPage');
                    },
                    child: Text("Sign Up"),
                  ),
                ],
              ),
              Text(
                msg,
                style: TextStyle(fontSize: 20.0, color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController fullname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  Future<String> _signup() async {
    final response =
        await http.post("http://patrongeldi.com/garaj/api/actions", body: {
      "action": "signup",
      "full_name": fullname.text,
      "email": email.text,
      "password": password.text,
    });

    var datauser = json.decode(response.body);
    //print(datauser["status"]);

    if (datauser["status"] == "error") {
      String type = 'Error';
      String text = 'Account not found!';
      _showMaterialDialog(type, text);
    }

    if (datauser["status"] == "field_error") {
      String type = 'Error';
      String text = 'Please fill the required fields!';
      _showMaterialDialog(type, text);
    }

    if (datauser['status'] == 'ok') {
      setState(() {
        userid = datauser['user_id'];
      });
      Navigator.pushReplacementNamed(context, '/MemberPage');
    }
    return datauser['status'];
  }

  void _showMaterialDialog(type, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(type),
            content: Text(text),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Login"),),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage('http://patrongeldi.com/garaj/img/bg2.jpg'),
              fit: BoxFit.cover),
        ),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Text(
                "SIGN UP",
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              ),
              SizedBox(
                height: 50.0,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: fullname,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 50.0,
              ),
              Column(
                children: <Widget>[
                  RaisedButton(
                    padding: EdgeInsets.all(20),
                    color: Colors.greenAccent,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _signup();
                    },
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/MyHomePage');
                },
                child: Text(
                  "Log in",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
