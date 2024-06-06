import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_project/screens/single_match/on_match_screen.dart';
import 'package:test_project/widgets/match_controller/pick_team.dart';

class MatchScreen extends StatefulWidget {
  MatchScreen({super.key, required this.uid});

  String uid;

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

enum num_people_Selection { single, double }

enum num_match_Selection { single, triple, penta }

class _MatchScreenState extends State<MatchScreen> {
  String? selectedTeam1;
  String? selectedTeam2;
  int? numberMatch = 1;

  void updateSelectedTeam1(String team) {
    setState(() {
      selectedTeam1 = team;
    });
  }

  void updateSelectedTeam2(String team) {
    setState(() {
      selectedTeam2 = team;
    });
  }

  bool isPressed = false;

  DateTime? selectedDate = DateTime.now();
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Ngày ban đầu khi mở cửa sổ chọn ngày
      firstDate: DateTime(2000), // Ngày đầu tiên có thể chọn
      lastDate: DateTime(2100), // Ngày cuối cùng có thể chọn
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Cập nhật giá trị ngày đã chọn
      });
    }
  }

  Widget _buildDateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectDate(context), // Gọi hàm xử lý khi nút được nhấn
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Colors.grey.shade100), // Đặt màu xám cho nền của nút
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Căn giữa theo chiều ngang của màn hình
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width /
                2, // Đặt chiều rộng bằng một nửa chiều rộng của màn hình
            height: 50,
            alignment: Alignment.center, // Căn giữa ô chọn ngày
            child: selectedDate != null
                ? Text(
                    "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                : IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
          ),
        ],
      ),
    );
  }

  num_people_Selection selected = num_people_Selection.single;

  Widget buildCardPeople(num_people_Selection type) {
    return SizedBox(
      width: 105,
      height: 105,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: selected == type ? Colors.green : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                type == num_people_Selection.single
                    ? Icons.person
                    : Icons.people, // Icon đơn hoặc đôi
                size: 25,
                color: Colors.black,
              ),
              Text(
                type == num_people_Selection.single
                    ? 'Đơn'
                    : 'Đôi', // Chữ 'đơn' hoặc 'đôi'
                style: const TextStyle(fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }

  num_match_Selection selected_match = num_match_Selection.single;
  String getText(num_match_Selection type) {
    switch (type) {
      case num_match_Selection.single:
        return '1 Séc';
      case num_match_Selection.triple:
        return '3 Séc';
      case num_match_Selection.penta: // Thêm trường hợp mới
        return '5 Séc';
    }
  }

  Widget buildCardMatch(num_match_Selection type) {
    return SizedBox(
      width: 85,
      height: 85,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        color: selected_match == type ? Colors.green : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getText(type), // Chữ 'đơn' hoặc 'đôi'
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String clubId = '';
  String matchId = '';

  void _saveMatch() async {
    try {
      // Kiểm tra xem có câu lạc bộ nào có ID người chơi trùng với UID đã có không
      QuerySnapshot clubSnapshot = await firestore
          .collection('clubs')
          .where('uid', isEqualTo: widget.uid)
          .get();

      // Nếu không tìm thấy câu lạc bộ, in ra thông báo và không thêm dữ liệu vào Firestore
      if (clubSnapshot.docs.isNotEmpty) {
        clubId = clubSnapshot.docs.first.id;
        print('Không tìm thấy câu lạc bộ cho người chơi có ID: ${widget.uid}');
      }

      Map<String, dynamic> newMatch = {
        'isDoubleMatch': 0,
        'team1': selectedTeam1,
        'team2': selectedTeam2,
        'setNumber': numberMatch,
        'month': selectedDate!.month,
        'day': selectedDate!.day,
        'scoreSetPlayer1': 0,
        'scoreSetPlayer2': 0,
        'sets': {
          for (int i = 1; i <= numberMatch!; i++) {'team1': 0, 'team2': 0}
        },
        'status': 1, //0 : chưa đấu, 1: đang đấu, 2: đã đấu, 3: bị hoãn-trễ,
      };

      await firestore
          .collection('clubs')
          .doc(clubId)
          .collection('matches')
          .doc(selectedDate!.month.toString())
          .collection(selectedDate!.day.toString())
          .add(newMatch)
          .then((docRef) {
        matchId = docRef.id;
        print('Trận đấu được tạo với ID: $matchId');
      });
    } catch (error) {
      print("Error saving match: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tuỳ chỉnh trận đấu',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: _buildDateButton(context),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected =
                                  num_people_Selection.single; // Chọn 'đơn'
                            });
                          },
                          child: buildCardPeople(num_people_Selection.single),
                        ),
                        const SizedBox(width: 50),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected =
                                  num_people_Selection.double; // Chọn 'đôi'
                            });
                          },
                          child: buildCardPeople(num_people_Selection.double),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected_match =
                                  num_match_Selection.single; // Chọn 'đơn'
                            });
                            numberMatch = 1;
                          },
                          child: buildCardMatch(num_match_Selection.single),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected_match =
                                  num_match_Selection.triple; // Chọn 'đôi'
                            });
                            numberMatch = 3;
                          },
                          child: buildCardMatch(num_match_Selection.triple),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected_match =
                                  num_match_Selection.penta; // Chọn 'đôi'
                            });
                            numberMatch = 5;
                          },
                          child: buildCardMatch(num_match_Selection.penta),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      color: Colors.pink.shade50,
                      margin: const EdgeInsets.only(left: 12, right: 12),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Đội 1',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black),
                                ),
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      AssetImage("assets/logo.jpg"),
                                ),
                                Text('Đội 2',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 15.0),
                                child: PickTeams(
                                    onTeamSelected: updateSelectedTeam1,
                                    uid: widget.uid),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 15.0),
                                child: PickTeams(
                                    onTeamSelected: updateSelectedTeam2,
                                    uid: widget.uid),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 12, right: 12),
                          height: 55,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.green.shade200,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _saveMatch();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MatchScreen(uid: widget.uid)),
                              );
                            },
                            child: const Center(
                                child: Text(
                              'Lưu',
                              style: TextStyle(fontSize: 25),
                            )),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          height: 55,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.red.shade200,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _saveMatch();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OnMatchScreen(
                                          matchId: matchId,
                                          selectedTeam1: selectedTeam1,
                                          selectedTeam2: selectedTeam2,
                                          numberMatch: numberMatch,
                                        )),
                              );
                            },
                            child: const Center(
                                child: Text(
                              'Bắt đầu chơi',
                              style: TextStyle(fontSize: 25),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
