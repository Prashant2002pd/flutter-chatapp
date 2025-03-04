import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test3/components/my_backbutton.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  // current user
  final User? user = FirebaseAuth.instance.currentUser;

  //get current user data
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    return await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserData(),
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
          Map<String, dynamic>?user = snapshot.data!.data();

          

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      MyBackbutton(),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Icon(
                  Icons.person,
                  size: 100,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    user!['username'],
                    style: const TextStyle(fontSize: 25),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                   user!['email'],
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ]
            ),
          );
          }else{
            return Text("No data found");
          }
         },
         )
    );
  }
}