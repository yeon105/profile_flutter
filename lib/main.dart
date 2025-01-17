import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import './tokeninfo.dart';
import './userinfo.dart';
import './detailinfo.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TokenInfo(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserInfo? userInfo = null;

  String? responseError = null;

  bool isLogin = false;

  TextEditingController namectl = TextEditingController();
  TextEditingController passwordctl = TextEditingController();

  Future<void> loginRequest(BuildContext context) async {
    TokenInfo provider = context.read<TokenInfo>();
    final url = Uri.parse("http://10.0.2.2:8080/api/login");
    final body = userInfo!.toJson();

    try {
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        setState(() {
          isLogin = true;
        });
        final refresh = response.headers['set-cookie'];
        final access = response.headers['authorization'];
        provider.saveAccessToken(access);
        provider.saveRefreshToken(refresh);
      } else if (response.statusCode == 401) {
        responseError = utf8.decode(response.bodyBytes);
      } else {
        setState(() {
          responseError = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        responseError = 'Exception: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Image.asset('assets/Sadaharu_Gintama.gif'),
              ),
              Form(
                child: Theme(
                  data: ThemeData(
                    inputDecorationTheme: InputDecorationTheme(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      labelStyle: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: namectl,
                          decoration: InputDecoration(
                            labelText: 'ID or email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextField(
                          controller: passwordctl,
                          decoration: InputDecoration(
                            labelText: 'password',
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[200],
                            minimumSize: Size(50, 50),
                          ),
                          onPressed: () {
                            setState(() {
                              userInfo = UserInfo(
                                username: namectl.text,
                                password: passwordctl.text,
                              );
                            });

                            loginRequest(context).then((_) {
                              if (isLogin) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailInfo()));
                              } else {
                                showSnackBar(context, responseError!);
                              }
                            });
                          },
                          child: Icon(
                            Icons.login,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        if (responseError != null)
                          Text(responseError!,
                              style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context, String str) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      str,
      textAlign: TextAlign.center,
    ),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.blue,
  ));
}
