import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Penguins from Pexels',
      theme: ThemeData(
        primaryColor: Colors.green, // Changing primary color to green
        hintColor: Colors.greenAccent, // Changing hint color to green accent
        fontFamily: 'Montserrat', // Changing font family to Montserrat
        textTheme: TextTheme(
          headline6: TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(color: Colors.black, fontSize: 16),
          bodyText2: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ImageList()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/image1.jpg', width: 100, height: 100), // Replace with your penguin image
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class ImageList extends StatefulWidget {
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  final String apiKey = "7xR4wPRK19kIZbcitGcfANAEGQrHEMVR8bQGAN8wY3Qc0QCUez75ZwMG";
  List<dynamic> _photos = [];

  @override
  void initState() {
    super.initState();
    fetchPhotos("penguin");
  }

  Future<void> fetchPhotos(String query) async {
    final String url = "https://api.pexels.com/v1/search?query=$query&per_page=5";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": apiKey,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        _photos = json.decode(response.body)["photos"];
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }

  String generateRandomPrice() {
    Random random = Random();
    double price = random.nextDouble() * 50 + 20; // Changing price range
    return "\$" + price.toStringAsFixed(2); // Changing currency symbol
  }

  String generateRandomName() {
    List<String> names = ["Pablo", "Penny", "Pippin", "Pengy", "Percy"]; // Changing penguin names
    return names[Random().nextInt(names.length)];
  }

  void displayPaymentMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 24.0),
                Icon(Icons.check_circle, color: Colors.green, size: 48.0),
                SizedBox(height: 16.0),
                Text(
                  "Payment Successful",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Thank you for your purchase! Your order has been successfully processed.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bidhan Shrestha Penguin Collection', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: _photos.length,
        itemBuilder: (BuildContext context, int index) {
          String imageUrl = _photos[index]["src"]["medium"];
          String price = generateRandomPrice();
          String name = generateRandomName();
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                displayPaymentMessage(context);
              },
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(imageUrl),
                        radius: 50,
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: $name",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(
                              "Price: $price",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
