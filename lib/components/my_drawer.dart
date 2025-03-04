import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [

              //drawer header
              DrawerHeader(
                child:Icon(
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.inversePrimary,

                  ) ,
                ),
          
              //home button
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  title: const Text('H O M E'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
          
              //profile button
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  title: const Text('P R O F I L E'),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ),

              //settings button
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  title: const Text('S E T T I N G S'),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              )

            ],
          ),

          //logout button
          Padding(
                padding: const EdgeInsets.only(left: 24.0, bottom: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  title: const Text('L O G O U T'),
                  onTap: () {
                    Navigator.pop(context);

                    
                   FirebaseAuth.instance.signOut();
                    
                  Navigator.pushNamed(context, '/login');
                  },
                ),
              )
        ],
      )
    );
  }
}