import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pku_online/page/chat_page.dart';

class ChatListScreen extends StatelessWidget {
  final List<dynamic> doctors;
  final Function(dynamic) onDoctorSelected;

  ChatListScreen({required this.doctors, required this.onDoctorSelected});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId == null) {
      // Handle the case where the user is not authenticated
      return Scaffold(
        body: Center(
          child: Text('User not authenticated'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat List'),
      ),
      body: ListView.separated(
        itemCount: doctors.length,
        separatorBuilder: (context, index) => Divider(height: 0),
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          final doctorName = doctor['doctorName'];
          final lastMessage = doctor['lastMessage'];
          final imageUrl = doctor['imageUrl'];

          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    builder: (context) => ChatPage(selectedDoctor: doctor),
                  ));
            },
          );
        },
      ),
    );
  }
}
