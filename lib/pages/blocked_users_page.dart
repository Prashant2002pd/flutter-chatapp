import 'package:flutter/material.dart';
import 'package:test3/services/chat_service.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blocked Users')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: ChatService().getBlockedUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('An error occurred'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _blockedUserTile(context, user['username'], user['email'], user['uid']);
            },
          );
        },
      ),
    );
  }


  Widget _blockedUserTile(BuildContext context, String username, String email, String uid) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username),
              Text(email),
            ],
          ),
          IconButton(
            icon: Icon(Icons.block),
            onPressed: () {
              // Unblock user
              showDialog(
                context: context,
               builder: (context){
                return AlertDialog(
                      title: const Text('Block Message'),
                      content:
                          const Text('Are you sure you want unblock this user?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            ChatService().unblockUser(uid);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                        ),
                      ],
                    );
               }
            );
            },
          ),
        ],
      ),
    );
  }

}