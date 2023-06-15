import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pku_online/page/chat_page.dart';

class ChatListScreen extends StatelessWidget {
  final List<dynamic> doctors;
  final List<dynamic> users;

  ChatListScreen({required this.doctors, required this.users});

  Future<bool> isCurrentUserDoctor(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Booking')
        .where('doctorUID', isEqualTo: userId)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // Handle the case where the user is not authenticated
      return Scaffold(
        body: Center(
          child: Text('User not authenticated'),
        ),
      );
    }

    return FutureBuilder<bool>(
      future: isCurrentUserDoctor(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while checking user role
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final bool isCurrentUserDoctor = snapshot.data ?? false;

        return Scaffold(
          appBar: AppBar(
            title: Text('Chat List'),
          ),
          body: isCurrentUserDoctor
              ? ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userName = user['name'];
                    final lastMessage = user['lastMessage'];
                    final avatar = user['avatar'];

                    return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(avatar),
                      ),
                      title: Text(
                        userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        lastMessage != null ? lastMessage : 'Start Chatting',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(selectedDoctor: user),
                          ),
                        );
                      },
                    );
                  },
                )
              : ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    final doctorName = doctor['doctorName'];
                    final lastMessage = doctor['lastMessage'];
                    final imageUrl = doctor['imageUrl'];

                    return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                      title: Text(
                        'Dr. $doctorName',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        lastMessage != null ? lastMessage : 'Start Chatting',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(selectedDoctor: doctor),
                          ),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
