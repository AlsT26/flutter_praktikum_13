import 'package:flutter/material.dart';
import 'package:flutter_praktikum_13/dokter_model.dart';
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
      Uri.parse('https://6699-103-156-164-13.ngrok-free.app/api/getDokter'));
  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    var parsed = data['data'].cast<Map<String, dynamic>>();
    return parsed.map<Datum>((json) => Datum.fromJson(json)).toList();
  } else {
    throw Exception('Failed');
  }
}

Future<http.Response> addDokter(
  nama,
  spesialis,
  no_telepon,
  hari_praktik,
) async {
  final res = await http.post(
    Uri.parse('https://6699-103-156-164-13.ngrok-free.app/api/createDokter'),
    body: {
      "nama": nama,
      "spesialis": spesialis,
      "no_telepon": no_telepon,
      "hari_praktik": hari_praktik,
    },
  );
  if (res.statusCode == 200) {
    return res;
  } else {
    throw Exception(res.statusCode);
  }
}

class _Tugas12State extends State<Tugas12> {
  late Future<List<Datum>> futureUser;

  final namaController = TextEditingController();
  final spesialisController = TextEditingController();
  final teleponController = TextEditingController();
  final hariPraktikController = TextEditingController();

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
                              Text(snapshot.data![index].nama),
                              Text(snapshot.data![index].spesialis),
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
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text("Tambah Data"),
                    children: [
                      TextField(
                        controller: namaController,
                        decoration: const InputDecoration(
                          hintText: "nama",
                          labelText: "nama",
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                      TextField(
                        controller: spesialisController,
                        decoration: const InputDecoration(
                          hintText: "spesialis",
                          labelText: "spesialis",
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                      TextField(
                        controller: teleponController,
                        decoration: const InputDecoration(
                          hintText: "nomor telepon",
                          labelText: "nomor telepon",
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                      TextField(
                        controller: hariPraktikController,
                        decoration: const InputDecoration(
                          hintText: "hari praktik",
                          labelText: "hari praktik",
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          var res = await addDokter(
                              namaController.text,
                              spesialisController.text,
                              teleponController.text,
                              hariPraktikController.text);
                          if (res.statusCode != 200) {
                            throw Exception('Unexpected error occured!');
                          } else {
                            setState(() {
                              futureUser = fetchUser();
                            });
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          var snackBar = const SnackBar(
                            content: Text('Data berhasil ditambahkan'),
                          );
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: const Text("Tambah"),
                      ),
                    ],
                  );
                });
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ));
  }
}
