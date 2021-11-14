import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:no_polisi/Api/global.dart';
import 'package:no_polisi/model/password_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();
  final f = GlobalKey<FormState>();

  Future sendData(String name, String email, String password) async {
    var url = Uri.http(IP_SERVER, API_REGISTER);
    var respone = await http.post(url, body: {
      "name": name,
      "email": email,
      "password": password,
    });

    var result = json.decode(respone.body);
    print(respone.body);

    await Future.delayed(Duration(seconds: 5));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return ChangeNotifierProvider(
      create: (context) => PasswordModel(),
      child: SafeArea(
        child: Consumer<PasswordModel>(
          builder: (context, viewmodel, child) => Scaffold(
            appBar: AppBar(
              title: Text("Register"),
              centerTitle: true,
            ),
            body: Form(
              key: f,
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 100, 10, 10),
                    child: TextFormField(
                      controller: _name,
                      validator: (isName) {
                        if (isName.isEmpty) {
                          return "Nama tidak boleh kosong";
                        } else if (isName.length < 7) {
                          return "Nama minimal 7 karakter";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Nama",
                        prefixIcon: Icon(Icons.account_box_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.red)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (isEmail) {
                        if (isEmail.isEmpty) {
                          return "Please input your email";
                        } else if (isEmail.length < 6) {
                          return "Email must contain 6 characters";
                        } else if (isEmail.contains("@") == false) {
                          return "Invalid email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.red)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _password,
                      obscureText: viewmodel.isObsecure,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.red)),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            Provider.of<PasswordModel>(context, listen: false)
                                .onTapPassword();
                          },
                          child: (viewmodel.isObsecure
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                        ),
                      ),
                      validator: (isPassword) {
                        if (isPassword.isEmpty) {
                          return "Please enter your password";
                        } else if (isPassword.length < 3) {
                          return "Password minimal 3 char";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _confirmPass,
                      obscureText: viewmodel.isObsecure,
                      decoration: InputDecoration(
                        hintText: "Konfirmasi password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Colors.red)),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            Provider.of<PasswordModel>(context, listen: false)
                                .onTapPassword();
                          },
                          child: (viewmodel.isObsecure
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                        ),
                      ),
                      validator: (isPassword) {
                        if (isPassword.isEmpty) {
                          return "Please enter your password";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                    child: ElevatedButton(
                        onPressed: () {
                          String name = _name.text.trim();
                          String email = _email.text.trim();
                          String password = _password.text;
                          String confirmPass = _confirmPass.text;

                          if (password.compareTo(confirmPass) != 0) {
                            Flushbar(
                              title: "attention!!",
                              message: "password not same",
                              duration: Duration(seconds: 3),
                            ).show(context);
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            sendData(name, email, password).then((data) {
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
                                Navigator.pushNamed(context, "login_page");
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
                        child: Text("Submit")),
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
      ),
    );
  }
}
