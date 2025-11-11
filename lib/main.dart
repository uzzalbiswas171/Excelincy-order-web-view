import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excellency WebView',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const WebViewHome(),
    );
  }
}

class WebViewHome extends StatefulWidget {
  const WebViewHome({Key? key}) : super(key: key);

  @override
  State<WebViewHome> createState() => _WebViewHomeState();
}

class _WebViewHomeState extends State<WebViewHome> {
  int _currentIndex = 0;

  // URLs for each tab
  final List<String> _urls = [
    'https://excellency-catering-restaurant-sweets.com/',
    'https://excellency-catering-restaurant-sweets.com/cart/',
    'https://excellency-catering-restaurant-sweets.com/favorit/',
    'https://excellency-catering-restaurant-sweets.com/profile',
  ];

  // One WebViewController per tab so state/history is preserved when switching tabs
  late final List<WebViewController> _controllers;

  @override
  void initState() {
    super.initState();

    // // For Android, use the surface-based WebView implementation
    // if (Platform.isAndroid) {
    //   WebView.platform = SurfaceAndroidWebView();
    // }

    _controllers = List.generate(_urls.length, (index) {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..loadRequest(Uri.parse(_urls[index]));
      return controller;
    });
  }

  @override
  void dispose() {
    // WebViewController does not require explicit dispose, but if you keep references
    // to streams or other resources, clean them here.
    super.dispose();
  }

  // Build a WebView widget for a given controller
  Widget _buildWebView(WebViewController controller) {
    return WebViewWidget(controller: controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excellency Catering'),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _controllers.map(_buildWebView).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey[700],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
