import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:no_polisi/Api/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ListPlat extends StatefulWidget {
  @override
  _ListPlatState createState() => _ListPlatState();
}

class _ListPlatState extends State<ListPlat> {
  getData() async {
    var url = Uri.http(IP_SERVER, API_REGISTER_PLAT);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isiToken = await prefs.getString("token");
    print(isiToken);

    Map<String, String> params = {"Authorization": "Bearer " + isiToken};

    var response = await http.get(url, headers: params);
    print(response.body);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Plat Nomor"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text((index + 1).toString() + ". " + data[index]["merek"]),
                  subtitle: Text("Plat Nomor : "+data[index]["plat"] +"\n" + "Warna Mobil : "+data [index]["warna"]),
                  leading: Icon(Icons.car_repair),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("gagal ulang lagi coy"),
            );
          } else {
            print("circular progress muncullah");
            return Center(

              child: CircularProgressIndicator(

              ),
            );
          }
        },
      ),
    );
  }
}
