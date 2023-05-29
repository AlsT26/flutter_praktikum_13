import 'package:flutter/material.dart';
import 'package:flutter_praktikum_13/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Tugas12(),
    );
  }
}

class Tugas12 extends StatefulWidget {
  const Tugas12({super.key});

  @override
  State<Tugas12> createState() => _Tugas12State();
}

Future<List<Datum>> fetchUser() async {
  final res = await http.get(
      Uri.parse('https://a25b-103-156-164-13.ngrok-free.app/api/getAllUser'));
  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    var parsed = data['data'].cast<Map<String, dynamic>>();
    return parsed.map<Datum>((json) => Datum.fromJson(json)).toList();
  } else {
    throw Exception('Failed');
  }
}

class _Tugas12State extends State<Tugas12> {
  late Future<List<Datum>> futureUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Datum>>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      child: InkWell(
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.amber,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(snapshot.data![index].name),
                              Text(snapshot.data![index].nim),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
