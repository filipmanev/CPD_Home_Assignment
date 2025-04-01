import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WinnersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Winners'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('winners')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading winners'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final winners = snapshot.data!.docs;
          if (winners.isEmpty) {
            return Center(child: Text('No winners yet'));
          }
          return ListView.builder(
            itemCount: winners.length,
            itemBuilder: (context, index) {
              var winnerData = winners[index].data() as Map<String, dynamic>;
              String name = winnerData['name'] ?? 'No Name';
              String imageUrl = winnerData['imageUrl'] ?? '';
              return ListTile(
                leading: imageUrl.isNotEmpty
                    ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                    : Icon(Icons.image),
                title: Text(name),
              );
            },
          );
        },
      ),
    );
  }
}
