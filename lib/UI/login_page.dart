import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:no_polisi/Api/global.dart';
import 'package:no_polisi/model/password_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool isLoading = false;
  TextEditingController _email =TextEditingController();
  TextEditingController _password =TextEditingController();


  Future<dynamic> sendData() async {
    var url = Uri.http(IP_SERVER, API_LOGIN);

    var email = _email.text.trim();
    var password = _password.text.trim();

    var response = await http.post(url, body: {
      "email": email,
      "password": password,
    });

    print(response.body);
    var hasil = json.decode(response.body);

    return hasil;
  }

  final f = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PasswordModel(),
      child: SafeArea(
        child: Consumer<PasswordModel>(
          builder: (context, viewmodel, child) => Scaffold(
            appBar: AppBar(
              title: Text("Login"),
              centerTitle: true,
            ),
            body: Form(
              key: f,
              child: ListView(
                children: [
                  Padding(
                    padding:  EdgeInsets.fromLTRB(20, 100, 20, 20),
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
                      padding: EdgeInsets.all(20),
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
                            onTap: (){
                              Provider.of<PasswordModel>(context, listen: false).onTapPassword();
                            },
                            child: (
                            viewmodel.isObsecure ? Icon(Icons.visibility) : Icon(Icons.visibility_off)
                            ),
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
                    padding:  EdgeInsets.fromLTRB(100, 0, 100, 0),
                    child: ElevatedButton(onPressed: () {

                      if (f.currentState.validate() == true) {
                        setState(() {
                          isLoading = true;
                        });
                        sendData().then((value) async {
                          setState(() {
                            isLoading = false;
                          });
                          var status = value["status"];

                          if (status == true) {
                            var isiToken = value["access_token"];

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('token', isiToken);
                            print("isi token " + isiToken);

                            Navigator.pushReplacementNamed(
                                context, "home_page");
                          } else {
                            Flushbar(
                              message: "Attention",
                              title: "Invalid email or password",
                              duration: Duration(seconds: 3),
                            ).show(context);
                          }
                        });
                      }
                    }, child: Text("Login")),
                  ),

                  Padding(
                    padding:  EdgeInsets.only(top:10),
                    child: Center(
                      child: GestureDetector(
                        child: Text("Register here"),
                        onTap: (){
                          Navigator.pushNamed(context, "register_page");
                        },
                      ),
                    ),
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
