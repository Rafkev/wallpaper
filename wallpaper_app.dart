import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(WallpaperApp());
}

class WallpaperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallpaper App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WallpaperScreen(),
    );
  }
}

class WallpaperScreen extends StatefulWidget {
  @override
  _WallpaperScreenState createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final String apiKey = 'YOUR_UNSPLASH_API_KEY';
  late List<String> _wallpapers = [];

  @override
  void initState() {
    super.initState();
    fetchWallpapers();
  }

  Future<void> fetchWallpapers() async {
    final url = 'https://api.unsplash.com/photos/random?count=10&client_id=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        _wallpapers = jsonResponse.map((photo) => photo['urls']['regular']).toList();
      });
    } else {
      throw Exception('Failed to load wallpapers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpaper App'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _wallpapers.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Handle wallpaper tap event
              print('Tapped on wallpaper $index');
            },
            child: CachedNetworkImage(
              imageUrl: _wallpapers[index],
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
