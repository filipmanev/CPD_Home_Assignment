import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WinnersPage extends StatelessWidget {
  const WinnersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Winners')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('winners')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading winners'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final winners = snapshot.data!.docs;
          if (winners.isEmpty) {
            return const Center(child: Text('No winners yet'));
          }
          return ListView.builder(
            itemCount: winners.length,
            itemBuilder: (context, index) {
              var winnerData = winners[index].data() as Map<String, dynamic>;
              String name = winnerData['name'] ?? 'No Name';
              String imageUrl = winnerData['imageUrl'] ?? '';
              return ListTile(
                leading:
                    imageUrl.isNotEmpty
                        ? Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.image),
                title: Text(name),
              );
            },
          );
        },
      ),
    );
  }
}
