import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:no_polisi/Api/global.dart';
import 'package:http/http.dart' as http;
import 'package:no_polisi/drawer/drawer.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool isLoading = false;
  var pilihKodeWilayah = ["A", "B", "C", "D", "E"];
  var merekMobil = ["Toyota", "Avanza", "Alphard"];
  var warnaMobil = ["Merah", "Kuning", "Hijau", "Hitam"];
  String valueKode, valueMerek, valueWarna;

  TextEditingController noPol = TextEditingController();
  TextEditingController kodeDaerah = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String platNomor = valueKode.toString() +
        " - " +
        noPol.text +
        " " +
        kodeDaerah.text.toUpperCase() ;


    Future sendData() async {
      var url = Uri.http(IP_SERVER, API_REGISTER_PLAT);
      var respone = await http.post(url, body: {
        "plat": platNomor,
        "warna": valueWarna,
        "merek": valueMerek,
      });

      var result = json.decode(respone.body);
      print(respone.body);

      await Future.delayed(Duration(seconds: 5));
      return result;
    }

    return SafeArea(
      child: Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(
          title: Text("Selamat Datang"),
          centerTitle: true,
        ),
        body: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView(
              children: [
                DropdownButtonFormField(
                  validator: (isKode){
                    if(isKode == null){
                      return "Silahkan pilih Kode";
                    }
                    return null;
                  },
                  hint: Text("Pilih Kode"),
                  icon: Icon(Icons.arrow_drop_down),
                  value: valueKode,
                  onChanged: (newValue) {
                    setState(() {
                      valueKode = newValue;
                    });
                  },
                  items: pilihKodeWilayah.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
                Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                TextFormField(
                  autofocus: false,
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: noPol,
                  keyboardType: TextInputType.phone,
                  maxLength: 4,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.local_police_rounded, color: Colors.yellow,),
                    hintText: "Nomor polisi",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.red)),
                  ),
                  validator: (isNopol) {
                    if (isNopol.isEmpty) {
                      return "Nomor Polisi harus di isi";
                    } else if (isNopol.length < 4) {
                      return "Harus memiliki 4 angka";
                    }
                    return null;
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                TextFormField(
                  autofocus: false,
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: kodeDaerah,
                  keyboardType: TextInputType.text,
                  maxLength: 3,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_city, color: Colors.indigo,),
                    hintText: "Kode Daerah",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.red)),
                  ),
                  validator: (isNopol) {
                    if (isNopol.isEmpty) {
                      return "Kode Daerah harus di isi";
                    } else if (isNopol.length < 3) {
                      return "Harus memiliki 3 Huruf";
                    }
                    return null;
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                DropdownButtonFormField(
                  validator: (isMerek){
                    if(isMerek == null){
                      return "Silahkan pilih merek mobil";
                    }
                    return null;
                  },
                  hint: Text("Pilih Merek Mobil"),
                  icon: Icon(Icons.arrow_drop_down),
                  value: valueMerek,
                  onChanged: (newValue) {
                    setState(() {
                      valueMerek = newValue;
                    });
                  },
                  items: merekMobil.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
                Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                DropdownButtonFormField(
                  validator: (isWarna){
                    if(isWarna == null){
                      return "Silahkan pilih warna mobil";
                    }
                    return null;
                  },
                  hint: Text("Pilih Warna Mobil"),
                  icon: Icon(Icons.arrow_drop_down),
                  value: valueWarna,
                  onChanged: (newValue) {
                    setState(() {
                      valueWarna = newValue;
                    });
                  },
                  items: warnaMobil.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
                Padding(padding: EdgeInsets.only(top: 10, bottom: 5)),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Center(
                      child: Text(platNomor)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(_key.currentState.validate()==true){
                      setState(() {
                        isLoading = true;
                      });
                      sendData().then((data) {
                        setState(() {
                          isLoading = false;
                        });
                        var st = data["status"];
                        if (st == true) {
                          Flushbar(
                            message: "Register berhasil",
                            title: "Yay",
                            duration: Duration(seconds: 3),
                          ).show(context);
                        } else {
                          var msg = data["message"];
                          Flushbar(
                            message: msg,
                            title: "Nooo",
                            duration: Duration(seconds: 3),
                          ).show(context);
                        }
                      });

                    }


                  },
                  child: Text("Submit"),
                ),

                isLoading
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
