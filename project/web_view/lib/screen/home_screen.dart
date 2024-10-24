import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

final homeUrl = Uri.parse(
    'https://ordinary-hide-5fe.notion.site/Portfolio-ba896d3922ae40d68b5beab74ab3aabe?pvs=4');

class HomeScreen extends StatelessWidget {

  final WebViewController controller = WebViewController()
    ..loadRequest(homeUrl)
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF9CA26),
        title: Text('NN'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              controller.loadRequest(homeUrl);
            },
            icon: Icon(
              Icons.home,
            ),
          ),
        ],
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
