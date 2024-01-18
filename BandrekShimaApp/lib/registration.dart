import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'applogo.dart';
import 'loginPage.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:intl/intl.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController teleponController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool _isNotValidate = false;

  void registerUser() async{
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){

      var regBody = {
        "email":emailController.text,
        "password":passwordController.text,
        "name":nameController.text,
        "telepon":teleponController.text,
        "address":addressController.text
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(regBody)
      );

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if(jsonResponse['status']){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SignInPage()));
      }else{
        print("SomeThing Went Wrong");
      }
    }else{
      setState(() {
        _isNotValidate = true;
      });
    }
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
                    'Daftar Untuk Menemukan Kelezatan Minuman Tradisional Bandrek Shima',
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
                        "Create To Your Account".text.size(22).yellow100.make(),
                        HeightBox(30),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              errorStyle: TextStyle(color: Colors.white),
                              errorText: _isNotValidate ? "Enter Proper Info" : null,
                              hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            prefixIcon: Icon(Icons.email), // Icon surat untuk email
                          ),
                        ).p4().px24(),
                        HeightBox(30),
                        TextField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              errorStyle: TextStyle(color: Colors.white),
                              errorText: _isNotValidate ? "Enter Proper Info" : null,
                              hintText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            prefixIcon: Icon(Icons.person), // Icon surat untuk email
                          ),
                        ).p4().px24(),
                        HeightBox(30),


                        //inputan no telepon
                        TextField(
                          controller: teleponController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(color: Colors.white),
                            errorText: _isNotValidate ? "Enter Proper Info" : null,
                            hintText: "Telepon",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            prefixIcon: Icon(Icons.phone), // Icon surat untuk email
                          ),
                        ).p4().px24(),
                        HeightBox(30),


                        //inputan alamat
                        TextField(
                          controller: addressController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorStyle: TextStyle(color: Colors.white),
                            errorText: _isNotValidate ? "Enter Proper Info" : null,
                            hintText: "Alamat",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            prefixIcon: Icon(Icons.house), // Icon surat untuk email
                          ),
                        ).p4().px24(),
                        HeightBox(30),



                        TextField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(icon: Icon(Icons.copy),onPressed: (){
                                final data = ClipboardData(text: passwordController.text);
                                Clipboard.setData(data);
                              },),
                              prefixIcon: IconButton(icon: Icon(Icons.lock),onPressed: (){
                                String passGen =  generatePassword();
                                passwordController.text = passGen;
                                setState(() {

                                });
                              },),
                              filled: true,
                              fillColor: Colors.white,
                              errorStyle: TextStyle(color: Colors.white),
                              errorText: _isNotValidate ? "Enter Proper Info" : null,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                        ).p4().px24(),


                        HeightBox(5),

                        GestureDetector(
                            onTap: () {
                              registerUser();
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
                                  Icon(Icons.person_add), // Your chosen login icon
                                  SizedBox(width: 5),
                                  "Registration".text.bold.size(18).black.makeCentered(),
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
                  MaterialPageRoute(builder: (context) => SignInPage()));
            },
            child: Container(
              height: 45,
              color: Colors.white,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have An Account? ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20, // Sesuaikan ukuran font yang diinginkan di sini
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Log In",
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

String generatePassword() {
  String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String lower = 'abcdefghijklmnopqrstuvwxyz';
  String numbers = '1234567890';
  String symbols = '!@#\$%^&*()<>,./';

  String password = '';

  int passLength = 20;

  String seed = upper + lower + numbers + symbols;

  List<String> list = seed.split('').toList();

  Random rand = Random();

  for (int i = 0; i < passLength; i++) {
    int index = rand.nextInt(list.length);
    password += list[index];
  }
  return password;
}