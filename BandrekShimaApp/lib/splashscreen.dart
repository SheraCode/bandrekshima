import 'package:flutter/material.dart';
import 'package:bandrekshimaapp/registration.dart';
import 'package:bandrekshimaapp/loginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with ColorFilter for darkness
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // Adjust opacity for darkness
              BlendMode.srcOver,
            ),
            child: Image.asset(
              'img/jahe.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.w700),
                ),
                Text(
                  'to',
                  style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Bandrek Shima',
                  style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
// ...

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ...

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignInPage()));
                      // Handle login button press
                      print('Login button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 50), // Set minimum width and height
                    ),
                    child: Text('Login'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Registration()));
                      // Handle register button press
                      print('Register button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      minimumSize: Size(double.infinity, 50), // Set minimum width and height
                    ),
                    child: Text('Register'),
                  ),

// ...

                ],
              ),
            ),
          ),

// ...
        ],
      ),
    );
  }
}
