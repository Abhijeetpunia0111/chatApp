import 'dart:convert';
import 'package:chat_login/chatservices/message.dart';
import 'package:chat_login/encrypt.dart/Myencrption.dart';
 // Import your encryption class
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //send message
  Future<void> SendMessage(String receiverId, String message) async {
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // Encrypt the message
    final encryptedMessage = MyEncryptionDecryption.encryptAES(message);

    //create a new message
    Message newMessage = Message (
      senderId : currentUserId,
      senderEmail : currentUserEmail,
      receiverId : receiverId ,
      message : encryptedMessage,
      timestamp : timestamp,
    );

    // construct chat room
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    
    //add new message to database
    await _firestore.collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .add(newMessage.toMap());
  }
  
  // get message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    List<String> ids = [ userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .orderBy('timestamp',descending: false)
      .snapshots();
  }

  // Decrypt message
  String decryptMessage(String encryptedMessage) {
    return MyEncryptionDecryption.decryptAES(encryptedMessage);
  }
}
