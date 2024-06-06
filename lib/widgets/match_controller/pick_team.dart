import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PickTeams extends StatefulWidget {
  final Function(String) onTeamSelected;
  final String uid;

  const PickTeams({super.key, required this.onTeamSelected, required this.uid});

  @override
  _PickTeamsState createState() => _PickTeamsState();
}

class _PickTeamsState extends State<PickTeams> {
  List<String> teams = []; // Danh sách các đội bóng
  String selectedTeam = 'Chọn ...';

  @override
  void initState() {
    super.initState();
    fetchTeams();
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
        teams = fetchedTeams;
      });
    } catch (e) {
      print("Lỗi khi lấy dữ liệu: $e");
    }
  }

  void _showTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn đội'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                // Hiển thị danh sách các đội bóng
                ...teams.map(
                  (team) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTeam = team; // Chọn đội bóng từ danh sách
                      });
                      Navigator.pop(context); // Đóng hộp thoại
                      widget.onTeamSelected(
                          selectedTeam); // Gọi callback để truyền dữ liệu lên widget cha
                    },
                    child: Text(
                      team,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showTeamDialog(context); // Hiển thị hộp thoại khi người dùng bấm vào
      },
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            selectedTeam,
            style: const TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
