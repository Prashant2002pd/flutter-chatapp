import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test3/models/message.dart';
import 'package:flutter/material.dart';
class ChatService extends ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  //send message
  Future<void>sendMessage({required String message, required String receiverId}) async {
    // Send message
    //get current user information
    final currentUserEmail = _auth.currentUser!.email!;
    final currentUserId = _auth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    //create new message
    Message newMessage = Message(
      message: message,
      senderEmail: currentUserEmail,
      senderId: currentUserId,
      receiverId: receiverId,
      timestamp: timestamp,
    );
   

    //construct the chatRoom id by sorting the user ids
    List<String> userIds = [currentUserId, receiverId];
    userIds.sort();
    String chatRoomId = userIds.join('_');

    //add message to firestore
    await FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
    

  }

  //get messages
  Stream<QuerySnapshot> getMessages({required String receiverId, required String senderId}){ 
    // Get messages

    //construct the chatRoom id by sorting the user ids
    List<String> userIds = [senderId, receiverId];
    userIds.sort();
    String chatRoomId = userIds.join('_');

    //get messages from firestore
    return FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).collection('messages').orderBy('timestamp').snapshots();
  }

  //get all users except the current user
  Stream<List<Map<String, dynamic>>> getUsers() {
    // Get all users except the current user
    final currentUser = _auth.currentUser;
    return FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).collection('blockedUsers').snapshots().asyncMap((snapsort) async{
      //get list of blocked users
      final blockedUsers = snapsort.docs.map((doc) => doc.id).toList();

      final userDocs = await FirebaseFirestore.instance.collection('users').get();

      return userDocs.docs.where((doc) => doc.data()['email'] != currentUser.email && !blockedUsers.contains(doc.id)).map((doc) => doc.data()).toList();
    });
  }

  //report message
  Future<void>reportMessage(String messageId, String userId) async{
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': messageId,
      'messageOwnerId': userId,
      'reportedAt': Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection('reports').add(report);
  }

  //block user
  Future<void>blockUser(String userId) async{
    final currentUser = _auth.currentUser;
  
    await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).collection('blockedUsers').doc(userId).set({});
    notifyListeners();
  }
  
  //unblock user
  Future<void>unblockUser(String userId) async{
    final currentUser = _auth.currentUser;
  
    await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).collection('blockedUsers').doc(userId).delete();
  }

  //blocked users stream
  Stream<List<Map<String, dynamic>>> getBlockedUsers(){
    final currentUser = _auth.currentUser;
    return FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).collection('blockedUsers').snapshots().asyncMap((snapsort) async{
      //get list of blocked users
      final blockedUsers = snapsort.docs.map((doc) => doc.id).toList();

      final userDocs = await Future.wait(blockedUsers.map((userId) => FirebaseFirestore.instance.collection('users').doc(userId).get()));

      return userDocs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  // Delete message from chat. Only sender can delete the message
  Future<void> deleteMessage(String messageId, String receiverId) async {
    final currentUser = _auth.currentUser;
    final currentUserId = currentUser!.uid;

    List<String> userIds = [currentUserId, receiverId];
    userIds.sort();
    String chatRoomId = userIds.join('_');

    final messageDoc = await FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).collection('messages').doc(messageId).get();

    if (messageDoc.exists) {

      final message = messageDoc.data() as Map<String, dynamic>;


      if (message['senderId'] == currentUserId) {
        await FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).collection('messages').doc(messageId).delete();
      } else {
        throw Exception("You can only delete your own messages.");
      }
    } else {
      throw Exception("Message not found.");
    }
  }


}