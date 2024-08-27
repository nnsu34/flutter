import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 추가

  void _sendMessage() {
    final user = context.read<LoginProvider>().user;
    if (user != null && _controller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('chats').add({
        'text': _controller.text,
        'sender': user.email,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _controller.clear();
      _scrollController.animateTo( // 메시지 전송 후 리스트를 아래로 스크롤
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = context.read<LoginProvider>().user;
    return Scaffold(
      appBar: AppBar(
        title: Text('chat'),
        actions: [
          IconButton(
              onPressed: () async {
                await context.read<LoginProvider>().signOut();
                Navigator.pushNamed(context, '/login');
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          // 텍스트 출력창
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = snapshot.data.docs;
                return ListView.builder(
                  controller: _scrollController, // 스크롤 컨트롤러 추가
                  reverse: true, // 리스트를 거꾸로 렌더링
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    bool isMe = chatDocs[index]['sender'] == user?.email;
                    return Row(
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          margin: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 8),
                          decoration: BoxDecoration(
                              color: isMe ? Colors.grey[300] : Colors.grey[500],
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                          child: Text(chatDocs[index]['text'],
                              style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'Send a message..'),
                    )),
                IconButton(onPressed: _sendMessage, icon: Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
