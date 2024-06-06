// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMatchPage extends StatefulWidget {
  AddMatchPage({super.key, required this.uid});

  String uid;

  @override
  _AddMatchPageState createState() => _AddMatchPageState();
}

class _AddMatchPageState extends State<AddMatchPage> {
  bool isDoubleMatch = false;
  List<String> players = [];
  late String team1Player1, team1Player2, team2Player1, team2Player2;
  DateTime matchDate = DateTime.now();
  List<Map<String, int>> sets = [];
  int setNumber = 0;
  int scoreSetPlayer1 = 0, scoreSetPlayer2 = 0;

  void _addSet() {
    setState(() {
      sets.add({'team1': 0, 'team2': 0});
      setNumber++;
    });
  }

  void fetchTeams() async {
    try {
      // Lấy dữ liệu từ Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('players').get();
      List<String> fetchedTeams = [];

      // Duyệt qua các tài liệu và thêm tên player vào danh sách
      for (var doc in snapshot.docs) {
        fetchedTeams
            .add(doc['username'].toString()); // Thêm player vào danh sách
      }

      setState(() {
        players = fetchedTeams;
      });
    } catch (e) {
      print("Lỗi khi lấy dữ liệu: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  // void updateTotalScores() {
  //   scoreSetPlayer1 = 0;
  //   scoreSetPlayer2 = 0;
  //   for (var set in sets) {
  //     scoreSetPlayer1 += set['team1']!;
  //     scoreSetPlayer2 += set['team2']!;
  //   }
  // }

  void checkSetResult(List set) {
    if (sets.isNotEmpty) {
      for (var set in sets) {
        if ((set['team1']! >= 11 || set['team2']! >= 11) &&
            (set['team1']! - set['team2']!).abs() >= 2) {
          if (set['team1']! > set['team2']!) {
            scoreSetPlayer1++;
          } else {
            scoreSetPlayer2++;
          }
        }
      }

      // final latestSet = sets.last;
      // final team1Score = latestSet['team1']!;
      // final team2Score = latestSet['team2']!;

      // Kiểm tra nếu một trong hai đội đạt hoặc vượt qua 11 điểm với sự chênh lệch 2 điểm
    }
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String clubId = '';
  String matchId = '';

  void _saveMatch() async {
    QuerySnapshot clubSnapshot = await firestore
        .collection('clubs')
        .where('uid', isEqualTo: widget.uid)
        .get();

    // Nếu không tìm thấy câu lạc bộ, in ra thông báo và không thêm dữ liệu vào Firestore
    if (clubSnapshot.docs.isNotEmpty) {
      clubId = clubSnapshot.docs.first.id;
      print('Không tìm thấy câu lạc bộ cho người chơi có ID: ${widget.uid}');
    }

    checkSetResult(sets);

    final matchData = {
      'isDoubleMatch': 0,
      'time': matchDate.toIso8601String(),
      'team1': team1Player1,
      'team2': team2Player1,
      'scoreSetPlayer1': scoreSetPlayer1,
      'scoreSetPlayer2': scoreSetPlayer2,
      'sets': sets,
      'setNumber': setNumber,
      'status': 2,
    };

    FirebaseFirestore.instance
        .collection('clubs')
        .doc(clubId)
        .collection('matches')
        .doc('${matchDate.month}')
        .collection('${matchDate.day}')
        .add(matchData)
        .then((_) {
      // Show success message or navigate back
    }).catchError((error) {
      // Show error message
    });

    FirebaseFirestore.instance.collection('matches').add(matchData).then((_) {
      // Show success message or navigate back
    }).catchError((error) {
      // Show error message
    });

    if (scoreSetPlayer1 > scoreSetPlayer2) {
      // Map<String, dynamic> data = {
      //   '$team1Player1': 'value1',
      //   '$team1Player2': 'value2',
      // };

      // Ghi đè document với ID cụ thể
      FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubId)
          .collection('ranking')
          .doc('${matchDate.month}')
          .update({
        team1Player1: FieldValue.increment(10),
      }).then((_) {
        print("Document successfully written!");
      }).catchError((error) {
        print("Error writing document: $error");
      });
    } else {
      FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubId)
          .collection('ranking')
          .doc('${matchDate.month}')
          .update({
        team1Player2: FieldValue.increment(10),
      }).then((_) {
        print("Document successfully written!");
      }).catchError((error) {
        print("Error writing document: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Match'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Double Match'),
              value: isDoubleMatch,
              onChanged: (bool value) {
                setState(() {
                  isDoubleMatch = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Team 1 Player 1'),
              items: players.map((String player) {
                return DropdownMenuItem<String>(
                  value: player,
                  child: Text(player),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  team1Player1 = newValue!;
                });
              },
            ),
            if (isDoubleMatch)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Team 1 Player 2'),
                items: players.map((String player) {
                  return DropdownMenuItem<String>(
                    value: player,
                    child: Text(player),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    team1Player2 = newValue!;
                  });
                },
              ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Team 2 Player 1'),
              items: players.map((String player) {
                return DropdownMenuItem<String>(
                  value: player,
                  child: Text(player),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  team2Player1 = newValue!;
                });
              },
            ),
            if (isDoubleMatch)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Team 2 Player 2'),
                items: players.map((String player) {
                  return DropdownMenuItem<String>(
                    value: player,
                    child: Text(player),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    team2Player2 = newValue!;
                  });
                },
              ),
            ListTile(
              title: Text("Match Date: ${matchDate.toLocal()}".split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: matchDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != matchDate) {
                  setState(() {
                    matchDate = picked!;
                  });
                }
              },
            ),
            ...sets.asMap().entries.map((entry) {
              int index = entry.key;
              // Map<String, int> set = entry.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Set ${index + 1}'),
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Team 1 Score'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          sets[index]['team1'] = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Team 2 Score'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          sets[index]['team2'] = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              );
            }),
            ElevatedButton(
              onPressed: _addSet,
              child: const Text('Add Set'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveMatch,
              child: const Text('Save Match'),
            ),
          ],
        ),
      ),
    );
  }
}
