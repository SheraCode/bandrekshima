import 'dart:convert';

import 'package:bandrekshimaapp/dashboard.dart';
import 'package:bandrekshimaapp/order.dart';
import 'package:bandrekshimaapp/profile.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class Cart extends StatefulWidget {
  final token;
  const Cart({@required this.token,Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  late String userId;
  late String userName = '';
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodedToken['_id'];
    userName = jwtDecodedToken['name']; // Get the user name from the token
    print('User ID: $userId'); // Debug message
    print('User Name: $userName'); // Debug message
    userName = 'Halo ${userName}';
    print(items);
    getCartList(userId);
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
    } else  {
      return 'Selamat Malam';
    }
  }

  void addTodo() async{
    if(_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty){

      var regBody = {
        "userId":userId,
        "title":_todoTitle.text,
        "desc":_todoDesc.text
      };

      var response = await http.post(Uri.parse(addtodo),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(regBody)
      );

      var jsonResponse = jsonDecode(response.body);

      print(jsonResponse['status']);

      if(jsonResponse['status']){
        _todoDesc.clear();
        _todoTitle.clear();
        Navigator.pop(context);
        getCartList(userId);
      }else{
        print("SomeThing Went Wrong");
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Berhasil Checkout Keranjang",
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

  void checkout(userId) async{

    var regBody = {
      "userId":userId,
    };

    var response = await http.put(Uri.parse(checkoutBandrek),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );

    var jsonResponse = jsonDecode(response.body);

    print(jsonResponse['status']);

    if(jsonResponse['status']){
      _showErrorDialog('Lihat Pesanan Anda Di Daftar Pesanan');
    }else{
      print("SomeThing Went Wrong");
    }
  }


  void getCartList(userId) async {
    try {
      var url = Uri.parse('$getUserCart?userId=$userId');
      var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('success')) {
          items = jsonResponse['success'];
          print(items);

          // Check if the jsonResponse contains 'users'
          if (jsonResponse.containsKey('users')) {
            var userData = jsonResponse['users'];
            print('User data: $userData'); // Debug message

            if (userData != null && userData is Map && userData.containsKey('name')) {
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

  void deleteItem(id) async {
    try {
      var url = Uri.parse('$deleteCart?id=$id');

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        getCartList(userId);
      }
    } catch (error) {
      print('Error deleting item: $error');
      // Tangani kesalahan lain yang mungkin terjadi selama permintaan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 60.0,left: 30.0,right: 30.0,bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$userName ', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700)),
                SizedBox(height: 8.0),
                Text(getGreeting(), style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700)),
                SizedBox(height: 8.0),
                Text('Apa Kabar? Ayo Lihat Keranjang Kamu',style: TextStyle(fontSize: 20),),

              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: items == null || items!.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'img/keranjang.png', // Replace with your image asset path
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 20),
                      Text('Keranjang Kamu Kosong', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
                    : ListView.builder(
                    itemCount: items!.length,
                    itemBuilder: (context,int index){
                      return Slidable(
                        key: const ValueKey(0),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () {}),
                          children: [
                            SlidableAction(
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                              onPressed: (BuildContext context) {
                                print('${items![index]['_id']}');
                                deleteItem('${items![index]['_id']}');
                              },
                            ),
                          ],
                        ),
                        child: Card(
                          borderOnForeground: false,
                          child: ListTile(
                            leading: _getProductIcon(items![index]['name']),
                            title: Text('${items![index]['name']}'),
                            subtitle: Text('${items![index]['price']}'),
                            trailing: Icon(Icons.arrow_back),
                          ),
                        ),

                      );
                    }
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: items == null || items!.isEmpty
          ? null
          : FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Order(token: widget.token)));
          // _showErrorDialog('Lihat Pesanan Anda Di Daftar Pesanan');
          checkout(userId); // Panggil fungsi checkout di sini
          print('ID CHRISTIA ' + userId);
        },
        label: Text('Checkout'),
        icon: Icon(Icons.add),
        tooltip: 'Add-ToDo',
      ),



      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard(token: widget.token)),
                );
              },
              icon: Icon(Icons.home),
              tooltip: 'Home',
            ),
            IconButton(
              onPressed: () {
                // Current page, do nothing or add your action
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile(token: widget.token)),
                );
              },
              icon: Icon(Icons.person),
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getProductIcon(String productName) {
    switch (productName.toLowerCase()) {
      case 'bandrek original':
        return Image.asset(
          'img/bandrekoriginal.jpeg',
          width: 80,
          height: 70,
          fit: BoxFit.contain,
        );
      case 'bandrek susu':
        return Image.asset(
          'img/bandreksusu.jpeg',
          width: 80,
          height: 70,
          fit: BoxFit.contain,
        );
      case 'bandrek susu telur':
        return Image.asset(
          'img/bandreksusutelur.jpeg',
          width: 80,
          height: 70,
          fit: BoxFit.contain,
        );
      default:
        return Icon(Icons.task);
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Tulis Daftar Kegiatan Kamu'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _todoTitle,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Judul",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  TextField(
                    controller: _todoDesc,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  ElevatedButton(onPressed: (){
                    addTodo();
                  }, child: Text("Tambah"))
                ],
              )
          );
        });
  }
}