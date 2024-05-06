// import 'package:firebase_database/firebase_database.dart';
// import 'package:chat_login/chatservices/chatservce.dart';
// import 'package:chat_login/components/chat_bubble.dart';

// import 'package:chat_login/components/my_textfield.dart';
// import 'package:chat_login/encrypt.dart/Myencrption.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CallService {
//   late final DatabaseReference _callRef;

//   CallService() {
//     _callRef = FirebaseDatabase.instance.reference().child('calls');
//   }

//   void makeCall() {
//     _callRef.set({'state': 'calling'});
//   }

//   void answerCall() {
//     _callRef.set({'state': 'connected'});
//   }

//   void hangUp() {
//     _callRef.set({'state': 'disconnected'});
//   }

//   Stream<Event> getCallStateStream() {
//     return _callRef.onValue;
//   }
// }
