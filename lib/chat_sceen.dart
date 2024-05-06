// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:chat_login/components/my_textfield.dart';
// import 'package:chat_login/sendbutton.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;
// import 'package:chat_login/components/chat_bubble.dart';

// class ChatScreen extends StatefulWidget {
//   final String userId;

//   const ChatScreen({Key? key, required this.userId}) : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   String? userName;
//   final textController = TextEditingController();
//   late io.Socket socket;
//   String? currentUserId;
//   List<Map<String, dynamic>> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchUserName();
//     initSocket();
//   }

//   Future<void> fetchUserName() async {
//   try {
//     final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
//         await FirebaseFirestore.instance
//             .collection('users')
//             .doc(widget.userId)
//             .get();
//     if (userSnapshot.exists) {
//       final userData = userSnapshot.data();
//       setState(() {
//         userName = userData?['name'];
//         currentUserId = userData?['name']; // Replace 'userId' with the correct field name for the user ID
//       });
//     }
//   } catch (error) {
//     print('Error fetching user name: $error');
//   }
// }

//   void initSocket() {
//     socket = io.io('https://serverd-rvou.onrender.com', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });

//     // Connect to the server
//     socket.connect();

//     // Listen for incoming messages
//     socket.on('message', (data) {
//       // Handle received message data
//       print('Received message: $data');
//       // Add logic to update UI with received messages
//       setState(() {
//         messages.add({
//           'senderId': data['name'],
//           'message': data['message'],
//         });
//       });
//     });
//   }

//   void sendMessage(String message) {
//      print('Received message: $message');
//     print('Socket connected: ${socket.connected}');

//     // Check if the message is not empty and the socket is connected
//     if (message.isNotEmpty && socket.connected) {
//       // Emit the message event to the serverp
      
//       socket.emit('message', {
//         'senderId': currentUserId,
//         'message': message,
//       });
//       // Add the sent message to the local list for UI update
//       setState(() {
//         messages.add({
//           'senderId': currentUserId,
//           'message': message,
//         });
//       });
//     }
//   }

//   @override
//   void dispose() {
//     // Disconnect from the server when the screen is disposed
//     socket.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with ${userName ?? 'User'}'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final messageData = messages[index];
//                 final isSentByMe = messageData['senderId'] == currentUserId;
//                 return ChatBubble(
//                   message: messageData['message'],
//                   isSentByMe: isSentByMe,
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: MyTextField(
//                     controller: textController,
//                     hintText: 'Type your message...',
//                     obscureText: false,
//                   ),
//                 ),
//                 SizedBox(width: 8.0),
//                 SendButton(
//                   onPressed: () {
//                     sendMessage(textController.text);
//                     textController.clear();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
