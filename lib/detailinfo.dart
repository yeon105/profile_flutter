import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './tokeninfo.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class DetailInfo extends StatefulWidget {
  const DetailInfo({super.key});

  @override
  State<DetailInfo> createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {
  Future<void> accessTokenRequest(BuildContext context) async {
    TokenInfo provider = context.read<TokenInfo>();
    print("access token 재발급 요청");

    final url = Uri.parse("http://10.0.2.2:8080/api/reissue");
    final headers = {'Cookie': provider.refreshToken!};

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        final access = response.headers["authorization"];
        provider.saveAccessToken(access);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? word = null;
    return Scaffold(
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
            title: Text('사카타 긴토키'),
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            centerTitle: true),
        body: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/Gintoki.png"),
                  radius: 100.0,
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  "이름",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Text(
                  "坂田 銀時 | Sakata Gintoki",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "생일",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
                Text(
                  "10월 10일 | 천칭자리",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "이명",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
                Text(
                  "해결사(万事屋), 백야차(白夜叉)",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "개요",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
                TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "ギャーギャーギャーギャーやかましいんだよ、 発情期ですか？コノヤロー",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                        backgroundColor: Colors.blue[800],
                        duration: Duration(milliseconds: 3000),
                      ));
                    },
                    label: Text(
                      "첫 등장 대사.",
                      style: TextStyle(fontSize: 25.0, color: Colors.white70),
                    ),
                    icon:
                        Icon(Icons.star, size: 25.0, color: Colors.blue[800])),
                Text(
                  "명대사",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                TextButton.icon(
                  onPressed: () {
                    flutterToast('내 검이 닿지 않아도, 우리의 검이라면 닿겠지. 사라져라, 망령.');
                  },
                  label: Text(
                    "61권 543화",
                    style: TextStyle(
                        fontSize: 25.0,
                        letterSpacing: 1.0,
                        color: Colors.white70),
                  ),
                  icon:
                      Icon(Icons.campaign, size: 25.0, color: Colors.blue[800]),
                ),
                TextButton.icon(
                    onPressed: () {
                      flutterToast(
                          '우츠로. 나는 텅 비지 않았어. 내가 지키고 싶었던 것은, 내 혼(魂)여기에 있다.');
                    },
                    label: Text(
                      "77권 703화",
                      style: TextStyle(
                          fontSize: 25.0,
                          letterSpacing: 1.0,
                          color: Colors.white70),
                    ),
                    icon: Icon(Icons.campaign,
                        size: 25.0, color: Colors.blue[800])),
              ],
            )));
  }

  void flutterToast(String word) {
    Fluttertoast.showToast(
        msg: word,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.blue[800],
        fontSize: 25.0,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT);
  }
}
