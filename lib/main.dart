import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _doctors = [];

  // Fetch data from JSON file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await json.decode(response);
    setState(() {
      _doctors = data["doctor"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Doctors'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _doctors.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _doctors.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(20),
                        key: ValueKey(_doctors[index]["name"]),
                        color: Colors.lime.shade100,
                        child: ListTile(
                          trailing: Icon(Icons.medical_services),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(_doctors[index]["img"]),
                          ),
                          title: Text(_doctors[index]["name"]),
                          subtitle: Text(_doctors[index]["speciality"]),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Details(
                                      desc: _doctors[index]["description"],
                                      img: _doctors[index]["img"],
                                      name: _doctors[index]["name"],
                                      speciality: _doctors[index]["speciality"],
                                    )));
                          },
                        ),
                      );
                    },
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    readJson();
                  },
                  child: Text('Show Popular Doctor'),
                ),
        ],
      ),
    );
  }
}

class Details extends StatelessWidget {
  Details(
      {super.key,
      required this.name,
      required this.img,
      required this.speciality,
      required this.desc});

  String name, img, speciality, desc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors Details'),
      ),
      body: Center(
          child: Column(
        children: [
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(img),
              radius: 70,
            ),
          ),
          Center(
            heightFactor: 2,
            child: Text('${name}', style:TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
          ),
          Center(
            heightFactor: 2,
            child: Text('$speciality', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),),
          ),
          Center(
            child: Text('$desc', textAlign: TextAlign.center,),
          ),
        ],
      )),
    );
  }
}
