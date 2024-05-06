import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_login/chats.dart';
import 'package:chat_login/components/my_textfield.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userController = TextEditingController();

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Row(
          children: [
            Expanded(
              child: Text(
                "${user.email}",
                style: TextStyle(fontSize: 16, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: signUserOut,
              icon: Icon(Icons.logout, color: Colors.white),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: userController,
                    hintText: 'Search user',
                    obscureText: false,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final User currentUser = FirebaseAuth.instance.currentUser!;
// print(data);
    if (currentUser.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiveruserEmail: data['email'],
                receiveruserUserId: data['uid'],
                
              ),
            ),
          );
        },
      );
    }
    return SizedBox(); // Return empty widget if it's the current user
  }
}
