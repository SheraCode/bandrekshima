import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bandrekshimaapp/dashboard.dart';
import 'package:bandrekshimaapp/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'applogo.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:intl/intl.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  String getGreeting() {
    var now = DateTime.now();
    var formatter = DateFormat('HH');
    var hour = int.parse(formatter.format(now));

    if (hour >= 0 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 15) {
      return 'Good Afternoon';
    } else if (hour >= 15 && hour < 19) {
      return 'Good Afternoon';
    } else {
      return 'Good Night';
    }
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Dashboard(token: myToken)));
      } else {
        setState(() {
          _isNotValidate = true;
        });
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _isNotValidate = false;
          });
        });
        _showErrorDialog('Email atau Password salah');
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isNotValidate = false;
        });
      });
      _showErrorDialog('Email dan Password Harus Diisi');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Gagal Masuk",
            style: TextStyle(
                color: Colors.red,
                fontWeight:
                    FontWeight.bold), // Mengatur warna teks menjadi merah
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 20.0, left: 30.0, right: 10.0, bottom: 13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome Back!',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text(getGreeting(),
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w700)),
                  SizedBox(height: 8.0),
                  Text(
                    'Masuk Untuk Menemukan Kelezatan Minuman Tradisional Bandrek Shima',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'img/jahe.png'), // Sesuaikan dengan path lokasi gambar Anda
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(
                            0.6), // Sesuaikan dengan opasitas yang diinginkan
                        BlendMode.darken,
                      ),
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ), // Tambahkan widget yang ingin Anda tampilkan di bagian bawah layar di sini
                  // Misalnya, menambahkan tombol atau teks
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // CommonLogo(),
                        "Sign To Your Account".text.size(22).yellow100.make(),
                        HeightBox(10),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Email",
                            errorStyle: TextStyle(fontSize: 15, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            prefixIcon: Icon(Icons.email), // Icon surat untuk email
                          ),
                        ).p4().px24(),
                        HeightBox(30),
                        TextField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Password",
                            errorStyle: TextStyle(fontSize: 15, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            prefixIcon: Icon(Icons.lock), // Icon gembok untuk password
                          ),
                        ).p4().px24(),

                        HeightBox(30),
                        GestureDetector(
                          onTap: () {
                            loginUser();
                          },
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 90),
                            decoration: BoxDecoration(
                              color: Colors.white, // Changed Vx.white to Colors.white
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login), // Your chosen login icon
                                SizedBox(width: 5),
                                "Login".text.bold.size(18).black.makeCentered(),
                              ],
                            ),
                          )

                        ),

                      ])),
            )
          ],
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Registration()));
          },
          child: Container(
            height: 45,
            color: Colors.white,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not A Member? ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // Sesuaikan ukuran font yang diinginkan di sini
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Join Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20, // Ukuran font yang sama untuk konsistensi
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          )



        ),
      ),
    );
  }
}
