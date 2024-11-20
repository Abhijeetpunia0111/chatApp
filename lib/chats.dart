import 'package:chat_login/chatservices/chatservce.dart';
import 'package:chat_login/components/chat_bubble.dart';
import 'package:chat_login/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String receiveruserEmail;
  final String receiveruserUserId;
  
  const ChatPage({
    super.key,
    required this.receiveruserEmail,
    required this.receiveruserUserId,
  });
  
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageContoller = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  void sendMessage() async {
    if (_messageContoller.text.isNotEmpty) {
      // If there is a message, then only send the message
      await _chatServices.sendMessage(widget.receiveruserUserId, _messageContoller.text);
      // Clear the message after sending
      _messageContoller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiveruserEmail)),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _buildMessageList(),
          ),
          // User input
          _buildMessageInput(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatServices.getMessages(
        widget.receiveruserUserId,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }
        return ListView(
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
  
    // Decrypt the message
    String decryptedMessage = '';
    try {
      decryptedMessage = _chatServices.decryptMessage(data['encryptedMessage'], data['iv']);
    } catch (e) {
      decryptedMessage = 'Failed to decrypt message';
    }

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5),
            ChatBubble(message: decryptedMessage),
          ],
        ),
      ),
    );
  }

  // Build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageContoller,
              hintText: 'Enter message',
              obscureText: false,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward, size: 40.0),
          ),
        ],
      ),
    );
  }
}
