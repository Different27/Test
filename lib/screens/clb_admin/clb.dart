import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../widgets/components/consts/clb_consts/clb_list_constants.dart';
import '../../widgets/model/clb_list.dart';
import 'creat_club_screen.dart';

class ClubListScreen extends StatefulWidget {
  ClubListScreen({super.key, required this.uid});

  String uid;

  @override
  _ClubListScreenState createState() => _ClubListScreenState();
}

class _ClubListScreenState extends State<ClubListScreen> {
  final List<Club> clubs = ClbListConstants.clubs;
  int id_right = 3;

  void addClub(Club club) {
    setState(() {
      clubs.add(club);
    });
  }

  void updateClub(int index, Club club) {
    setState(() {
      clubs[index] = club;
    });
  }

  void deleteClub(int index) {
    setState(() {
      clubs.removeAt(index);
    });
  }

  void navigateToAddClub({int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateClubScreen(
          onAddClub: addClub,
          onUpdateClub: updateClub,
          club: index != null ? clubs[index] : null,
          index: index,
          uid: widget.uid,
        ),
      ),
    );
  }

  void navigateToClubDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClubDetailsScreen(club: clubs[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Danh sách CLB',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.none),
        ),
      ),
      body: ListView.builder(
        itemCount: clubs.length,
        itemBuilder: (context, index) {
          final club = clubs[index];
          return Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              title: Row(
                children: [
                  Text(
                    club.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Text(
                club.location,
                style: const TextStyle(fontSize: 17),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (id_right != 3)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => navigateToAddClub(index: index),
                    ),
                  if (id_right != 3)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteClub(index),
                    ),
                ],
              ),
              onTap: () => navigateToClubDetails(index),
            ),
          );
        },
      ),
      floatingActionButton: id_right != 3
          ? FloatingActionButton(
              onPressed: navigateToAddClub,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class ClubDetailsScreen extends StatelessWidget {
  final Club club;

  const ClubDetailsScreen({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(club.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: club.imageUrl.isNotEmpty
                    ? FileImage(File(club.imageUrl))
                    : null,
                child: club.imageUrl.isEmpty
                    ? const Icon(Icons.camera_alt, size: 80, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text('Owner: ${club.owner}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Location: ${club.location}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Description: ${club.description}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
                'Founding Date: ${DateFormat('dd/MM/yyyy').format(club.foundingDate)}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Active Years: ${club.activeYears}',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
