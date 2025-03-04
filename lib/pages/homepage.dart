import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test3/components/my_backbutton.dart';
import 'package:test3/components/my_drawer.dart';
import 'package:test3/components/user_tile.dart';
import 'package:test3/pages/chat_page.dart';
import 'package:test3/services/authservice.dart';
import 'package:test3/services/chat_service.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body:Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: ChatService().getUsers(),
              builder: (context, snapshot){
            
                //loading..
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
            
                //error
                if(snapshot.hasError){
                  return Center(child: Text("Error: ${snapshot.error}" ));
                }
            
                //data recived
                if(snapshot.hasData){
                  return ListView(
                    children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),

    );
  }


  //buld individual user list item
  Widget _buildUserListItem(Map<String, dynamic>userData, BuildContext context){
      return UserTile(
                        text:userData['username'],
                        onTap:(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                reciverEmail: userData['username'],
                                receiverId:userData['uid'],
                              ),
                            ),
                          );
                        }
                      );
  }
}



                      