import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test3/components/my_backbutton.dart';
import 'package:test3/services/authservice.dart';
import 'package:test3/services/chat_service.dart';

class ChatPage extends StatelessWidget {
  final String reciverEmail;
  final String receiverId;
  ChatPage({
    super.key,
    required this.reciverEmail,
    required this.receiverId,
  });

  // Text controller
  final TextEditingController textEditingController = TextEditingController();

  // Services
  final AuthService authService = AuthService();
  final ChatService chatService = ChatService();

  // Scroll controller
  final ScrollController _scrollController = ScrollController();

  // Send message function
  void sendMessage() async {
    if (textEditingController.text.isEmpty) {
      return;
    }
    await chatService.sendMessage(
      receiverId: receiverId,
      message: textEditingController.text,
    );

    textEditingController.clear();

    // Scroll to the bottom after sending a message
    _scrollToBottom();
  }

  // Scroll to the bottom function
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 20),
            Text(reciverEmail),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessagesList(),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: TextField(
                      controller: textEditingController,
                      maxLines: null,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, left: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color:  Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.arrow_upward),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    String senderId = authService.getCurrentUser()?.uid ?? "null";
    return StreamBuilder(
      stream: chatService.getMessages(receiverId: receiverId, senderId: senderId),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // Data received
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

          return ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              final message = snapshot.data?.docs[index];

              // Alignment of messages
              bool isCurrentUser = message?['senderId'] == senderId;

              return Container(
                alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment:
                      isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: chat_bubble(isCurrentUser: isCurrentUser, message: message, messageId: snapshot.data!.docs[index].id, userId: message?['senderId'], receiverId: message?['receiverId']),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return Container();
      },
    );
  }
}



//chat bibble
class chat_bubble extends StatelessWidget {
  const chat_bubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
    required this.messageId,
    required this.userId,
    required this.receiverId
  });

  final bool isCurrentUser;
  final QueryDocumentSnapshot<Object?>? message;
  final String messageId;
  final String userId;
  final String receiverId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
      if(!isCurrentUser) {
        _showOption(context,messageId,userId);
      } else {
        _showDeleteOption(context, messageId, receiverId);
      }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message?['message'],
           style: TextStyle(
            fontSize: 16,
           ),
           ),
      ),
    );
  }


  //show options for block and report
  void _showOption(BuildContext context, String messageId, String userId){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return SafeArea(
          child: Column(
            children: [
              //report message
              ListTile(
                leading: Icon(Icons.flag),
                title: const Text('Report'),
                onTap: (){
                  Navigator.pop(context);
                  _reportMessage(context, messageId, userId);
                },
              ),
             
              //block user
              ListTile(
                leading: Icon(Icons.block),
                title: const Text('Block User'),
                onTap: (){
                  Navigator.pop(context);
                  _blockUser(context, userId);
                },
              ),
          
              //cancel
              ListTile(
                leading: Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  //report message
  void _reportMessage(BuildContext context, String messageId, String userId){

    //show dialog for conformatioin
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Report Message'),
          content: const Text('Are you sure you want to report this message?'),
          actions: [
            TextButton(
              onPressed: (){
                ChatService().reportMessage(messageId, userId);
                Navigator.pop(context);
              },
              child: Text('Yes',style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child:Text('No',style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
            ),
          ],
        );
      },
    );
  }

  //delete message
  void _deleteMessage(BuildContext context, String messageId, String receiverId){
    // ChatService().deleteMessage(messageId);

     //show dialog for conformatioin
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Delete Message'),
          content: const Text('Are you sure you want delete this message?'),
          actions: [
            TextButton(
              onPressed: (){
                ChatService().deleteMessage(messageId, receiverId);
                Navigator.pop(context);
              },
              child: Text('Yes',style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child:Text('No',style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
            ),
          ],
        );
      },
    );
  }

  //block user
  void _blockUser(BuildContext context,String userId){

     //show dialog for conformatioin
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Block Message'),
          content: const Text('Are you sure you want block this user?'),
          actions: [
            TextButton(
              onPressed: (){
                ChatService().blockUser(userId);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Yes',style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child:Text('No',style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
            ),
          ],
        );
      },
    );
  }


  //show options for delete
  void _showDeleteOption(BuildContext context, String messageId,String receiverId){
    showModalBottomSheet(
      context: context,
      builder: (context){
        return SafeArea(
          child: Column(
            children: [
              //delete message
              ListTile(
                leading: Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: (){
                  Navigator.pop(context);
                  _deleteMessage( context, messageId, receiverId);
                },
              ),
          
              //cancel
              ListTile(
                leading: Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
