import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rest_api_demo/todos.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Todo> todos = [];
  bool isLoading = false;
  final url = 'https://6255ecdf8646add390de99d3.mockapi.io/todos';

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  getTodos() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.get(Uri.parse(url));
      setState(() {
        todos = Todo.fromJsonList(jsonDecode(response.body) as List<dynamic>);
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !isLoading
            ? ListView.builder(
                itemCount: todos.length,
                itemBuilder: (childContext, itemIndex) => ListTile(
                  title: Text(todos[itemIndex].title ?? ''),
                  subtitle: Text(todos[itemIndex].description ?? ''),
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
