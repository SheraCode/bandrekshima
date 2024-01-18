import 'dart:convert';
import 'package:bandrekshimaapp/order.dart';
import 'package:bandrekshimaapp/profile.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:intl/intl.dart';
import 'package:bandrekshimaapp/cart.dart';

class Dashboard extends StatefulWidget {
  final token;

  const Dashboard({@required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userId;
  late String userName = '';
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;



  
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodedToken['_id'];
    userName = jwtDecodedToken['name'];
    print('User ID: $userId');
    print('User Name: $userName');
    userName = 'Halo ${userName}';
    print(widget.token);

    getTodoList(userId);
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

  void bandrekOriginal() async{

    var regBody = {
      "userId":userId,
      "name":"Bandrek Original",
      "price":7000
    };

    var response = await http.post(Uri.parse(cart),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse['status']);

    if(jsonResponse['status']){
      _showErrorDialog('Cek Produk Anda di Keranjang dan Lakukan Checkout');

    }else{
      print("SomeThing Went Wrong");
    }

  }

  void bandrekSusu() async{

    var regBody = {
      "userId":userId,
      "name":"Bandrek Susu",
      "price":9000
    };

    var response = await http.post(Uri.parse(cart),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse['status']);

    if(jsonResponse['status']){
      _showErrorDialog('Cek Produk Anda di Keranjang dan Lakukan Checkout');
    }else{
      print("SomeThing Went Wrong");
    }

  }

  void bandrekSusuTelur() async{

    var regBody = {
      "userId":userId,
      "name":"Bandrek Susu Telur",
      "price":14000
    };

    var response = await http.post(Uri.parse(cart),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse['status']);

    if(jsonResponse['status']){
      _showErrorDialog('Cek Produk Anda di Keranjang dan Lakukan Checkout');
    }else{
      print("SomeThing Went Wrong");
    }

  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Tersimpan Di Keranjang",
            style: TextStyle(
                color: Colors.black,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
              EdgeInsets.only(top: 40.0, left: 30.0, right: 30.0, bottom: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$userName ',
                      style:
                      TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700)),
                  SizedBox(height: 8.0),
                  Text(getGreeting(),
                      style:
                      TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700)),
                  SizedBox(height: 8.0),
                  Text('Apa Kabar? Ayo Hangatkan Tubuhmu Sekarang',
                      style: TextStyle(fontSize: 20)),
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
                  Text('Produk Kami',
                      style:
                      TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.0),
                  // Replace this with your actual product widgets
                  BandrekOriginal(
                    'Bandrek Original',
                    'Bandrek original memiliki ciri khas tertentu',
                    '7.000',
                    'img/bandrekoriginal.jpeg',
                  ),
                  BandrekSusu(
                    'Bandrek Susu',
                    'Bandrek susu memiliki perpaduan rasa antara rempah dan susu',
                    '9.000',
                    'img/bandreksusu.jpeg',
                  ),
                  BandrekSusuTelur(
                    'Bandrek Susu Telur',
                    'Bandrek dengan susu serta telur yang di mix',
                    '14.000',
                    'img/bandreksusutelur.jpeg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard(token: widget.token)));

                // Add your action here
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
                // Add your action here
              },
              icon: Icon(Icons.person),
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget BandrekOriginal(String name, String description, String price, String imagePath) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Product Details
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text(description, style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 8.0),
                  Text('Rp $price', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add your action here
                      bandrekOriginal();
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: Text('Tambah Keranjang'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget BandrekSusu(String name, String description, String price, String imagePath) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Product Details
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text(description, style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 8.0),
                  Text('Rp $price', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      bandrekSusu();
                      // Add your action here
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: Text('Tambah Keranjang'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget BandrekSusuTelur(String name, String description, String price, String imagePath) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Product Details
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  Text(description, style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 8.0),
                  Text('Rp $price', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      bandrekSusuTelur();
                      // Add your action here
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    child: Text('Tambah Keranjang'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
