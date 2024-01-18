import 'dart:convert';
import 'package:bandrekshimaapp/dashboard.dart';
import 'package:bandrekshimaapp/order.dart';
import 'package:bandrekshimaapp/profile.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:intl/intl.dart';
import 'package:bandrekshimaapp/cart.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
// Existing imports...

class Profile extends StatefulWidget {
  final token;

  const Profile({@required this.token, Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String userId;
  late String userName = '';
  late String email = '';
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodedToken['_id'];
    userName = jwtDecodedToken['name'];
    email = jwtDecodedToken['email'];
    print('User ID: $userId');
    print('User Name: $userName');
    getTodoList(userId);
    nameController.text = userName;
    emailController.text = email;
  }
  String getGreeting() {
    var now = DateTime.now();
    var formatter = DateFormat('HH');
    var hour = int.parse(formatter.format(now));

    if (hour >= 0 && hour < 12) {
      return 'Selamat Pagi';
    } else if (hour >= 12 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 19) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  void getTodoList(userId) async {
    try {
      var url = Uri.parse('$getToDoList?userId=$userId');
      var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('success')) {
          items = jsonResponse['success'];

          if (jsonResponse.containsKey('users')) {
            var userData = jsonResponse['users'];
            print('User data: $userData');

            if (userData != null &&
                userData is Map &&
                userData.containsKey('name')) {
              userName = userData['name'];
              print(userName);
            } else {
              print('User data is empty or name not found');
            }
          } else {
            print('User data not found in the response');
          }

          setState(() {});
        } else {
          print('Format respons tidak valid: ${response.body}');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error mengambil daftar kegiatan: $error');
    }
  }
  // Existing methods...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
            EdgeInsets.only(top: 18.0, left: 30.0, right: 30.0, bottom: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Halo $userName ',
                    style:
                    TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700)),
                SizedBox(height: 8.0),
                Text(getGreeting(),
                    style:
                    TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700)),
                SizedBox(height: 8.0),
                Text('Apa Kabar? Ayo Lihat Profil Kamu Dibawah Ini',
                  style: TextStyle(fontSize: 20),),
              ],
            ),
          ),
          // White box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16.0),
                // Replace this with your profile form
                ProfileForm(),
              ],
            ),
          ),

          // Bottom Navigation Bar
          BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Dashboard(token: widget.token)));
                  },
                  icon: Icon(Icons.home),
                  tooltip: 'Home',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart(token: widget.token)));
                    // Add your action here
                  },
                  icon: Icon(Icons.shopping_cart),
                  tooltip: 'Cart',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Order(token: widget.token)));
                    // Add your action here
                  },
                  icon: Icon(Icons.assignment_outlined),
                  tooltip: 'Order',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile(token: widget.token)));
                  },
                  icon: Icon(Icons.person),
                  tooltip: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ProfileForm() {
    return Form(
      // Add your form key and other form properties here if needed
      child: Column(
        children: [
          // SizedBox(height: 20),
          Image(
            image: AssetImage('img/user.png'), // Sesuaikan dengan path sesuai struktur folder Anda
            width: 100, // Sesuaikan dengan lebar yang diinginkan
            height: 100, // Sesuaikan dengan tinggi yang diinginkan
          ),
          SizedBox(height: 30),
          TextFormField(
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
              prefixIcon: Icon(Icons.email),
            ),
          ).p4().px24(),
          SizedBox(height: 16),
          TextFormField(
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
              prefixIcon: Icon(Icons.person),
            ),
          ).p4().px24(),

          SizedBox(height: 16,),
          SizedBox(height: 85,),

          SizedBox(height: 37),
          GestureDetector(
            onTap: () {

            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 90),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 5),
                  "Your Profile".text.bold.size(18).black.makeCentered(),
                  SizedBox(height: 57,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
