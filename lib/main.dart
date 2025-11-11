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
      debugShowCheckedModeBanner: false,
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

  final List<String> _urls = [
    'https://excellency-catering-restaurant-sweets.com/',
    'https://excellency-catering-restaurant-sweets.com/all-products',
    'https://excellency-catering-restaurant-sweets.com/wishlist',
    'https://excellency-catering-restaurant-sweets.com/profile',
  ];

  late final List<WebViewController> _controllers;

  @override
  void initState() {
    super.initState();

    // // Enable surface-based rendering for Android
    // if (Platform.isAndroid) {
    //   WebView.platform = SurfaceAndroidWebView();
    // }

    // Create one controller per tab to preserve state
    _controllers = List.generate(_urls.length, (index) {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
       // ..setZoomEnabled(false) // ✅ Disable zoom gestures
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) {
              // Example: block YouTube links
              if (request.url.startsWith('https://excellency-catering-restaurant-sweets.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(_urls[index]));
      return controller;
    });
  }

  // Build WebView widget
  Widget _buildWebView(WebViewController controller) {
    return WebViewWidget(controller: controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _controllers.map(_buildWebView).toList(),
        ),
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
            icon: Icon(Icons.production_quantity_limits),
            label: 'Products',
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
