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
  final ScrollController _scrollController = ScrollController();

  Future<String> _getSenderName(String email) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first.data() as Map<String, dynamic>;
        return userData['name'] ?? 'Unknown';
      }
    } catch (e) {
      print('Error fetching sender name: $e');
    }
    return 'Unknown';
  }

  void _sendMessage() {
    final user = context.read<LoginProvider>().user;
    if (user != null && _controller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('chats').add({
        'text': _controller.text,
        'sender': user.email,
        'senderName': user.displayName ?? 'Anonymous',
        'timestamp': FieldValue.serverTimestamp(),
      });
      _controller.clear();
      _scrollController.animateTo(
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
        centerTitle: true,
        backgroundColor: Color(0xFFffe600),
        title: Text('Chat'),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<LoginProvider>().signOut();
              Navigator.pushNamed(context, '/login');
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: Text('No messages yet.'),
                  );
                }
                final chatDocs = snapshot.data!.docs;
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: Future.wait(
                    chatDocs.map((doc) async {
                      final chatData = doc.data() as Map<String, dynamic>;
                      final senderName = await _getSenderName(chatData['sender']);
                      return {
                        ...chatData,
                        'senderName': senderName,
                      };
                    }).toList(),
                  ),
                  builder: (context, futureSnapshot) {
                    if (futureSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!futureSnapshot.hasData) {
                      return Center(
                        child: Text('Error loading messages.'),
                      );
                    }
                    final updatedChatDocs = futureSnapshot.data!;
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: updatedChatDocs.length,
                      itemBuilder: (context, index) {
                        final chatData = updatedChatDocs[index];
                        bool isMe = chatData['sender'] == user?.email;
                        Timestamp timestamp = chatData['timestamp'] ?? Timestamp.now();
                        DateTime dateTime = timestamp.toDate();
                        String formattedTime = "${dateTime.hour}:${dateTime.minute}";

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${chatData['senderName']} • $formattedTime",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 4, bottom: 4),
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isMe ? Colors.black : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  chatData['text'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isMe ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
                    decoration: InputDecoration(
                      labelText: 'Send a message..',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    cursorColor: Colors.black,
                    onSubmitted: (_) => _sendMessage(),

                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
