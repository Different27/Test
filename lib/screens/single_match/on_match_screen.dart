import 'package:flutter/material.dart';
import '../../widgets/match_controller/plus_score.dart';
import '../../widgets/nav_bar.dart';

class OnMatchScreen extends StatefulWidget {
  late String matchId;
  late dynamic selectedTeam1;
  late dynamic selectedTeam2;
  late dynamic numberMatch;
  OnMatchScreen(
      {super.key,
      required this.matchId,
      required this.selectedTeam1,
      required this.selectedTeam2,
      required this.numberMatch});

  @override
  State<OnMatchScreen> createState() => _OnMatchScreenState();
}

class _OnMatchScreenState extends State<OnMatchScreen> {
  int scoreFromPlusScore1 = 0; // Biến để lưu trữ điểm nhận được từ PlusScore
  int scoreFromPlusScore2 = 0; // Biến để lưu trữ điểm nhận được từ PlusScore

  int _count1 = 0;
  int _count2 = 0;

  void _handleScoreSelected1(int score) {
    setState(() {
      scoreFromPlusScore1 = score;
      _count1 = score;
    });
    _winnerMatch(); // Gọi _winnerMatch sau mỗi lần cập nhật điểm số đội 1
  }

  void _handleScoreSelected2(int score) {
    setState(() {
      scoreFromPlusScore2 = score;
      _count2 = score;
    });
    _winnerMatch(); // Gọi _winnerMatch sau mỗi lần cập nhật điểm số đội 2
  }

  int set_count1 = 0;
  int set_count2 = 0;
  int max_point = 11;

  void _showMatchResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Match Result'),
        content: const Text('Trận đấu kết thúc'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _winnerMatch() {
    setState(() {
      if (set_count1 == widget.numberMatch ||
          set_count2 == widget.numberMatch) {
        return _showMatchResultDialog();
      }
      if ((set_count1 == 2 && widget.numberMatch == 3) ||
          (set_count2 == 2 && widget.numberMatch == 3)) {
        return _showMatchResultDialog();
      }
      if ((set_count1 == 3 && widget.numberMatch == 5) ||
          (set_count2 == 3 && widget.numberMatch == 5)) {
        return _showMatchResultDialog();
      }
    });
  }

  void _incrementCount1() {
    setState(() {
      if (_count1 < max_point) {
        _count1++;
      } else {
        _count1 = scoreFromPlusScore1;
        set_count1++;
      }
    });
    _winnerMatch(); // Gọi _winnerMatch sau mỗi lần tăng điểm số đội 1
  }

  void _decrementCount1() {
    setState(() {
      if (_count1 > 0) {
        _count1--;
      } else {
        _count1 = 0;
      }
    });
  }

  void _incrementCount2() {
    setState(() {
      if (_count2 < max_point) {
        _count2++;
      } else {
        _count2 = scoreFromPlusScore2;
        set_count2++;
      }
    });
    _winnerMatch(); // Gọi _winnerMatch sau mỗi lần tăng điểm số đội 2
  }

  void _decrementCount2() {
    setState(() {
      if (_count2 > 0) {
        _count2--;
      } else {
        _count2 = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Đặt mainAxisAlignment thành start để hình ảnh đầu tiên ở bên trái
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage("assets/logo.jpg"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('PingLog',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.none)),
                      Spacer(),
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage("assets/logo.jpg"),
                      ),
                    ],
                  )),
              Container(
                color: Colors.pink.shade50,
                margin: const EdgeInsets.only(top: 20, left: 12, right: 12),
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
                            style: TextStyle(fontSize: 25, color: Colors.black),
                          ),
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage("assets/logo.jpg"),
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                15), // Đặt bán kính cong ở đây
                          ),
                          height: 125,
                          width: 138,
                          child: Center(
                            child: Text(
                              widget.selectedTeam1,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                15), // Đặt bán kính cong ở đây
                          ),
                          height: 125,
                          width: 138,
                          child: Center(
                            child: Text(
                              widget.selectedTeam2,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 70,
                    height: 60,
                    child: Card(
                      child: Center(
                        child: Text(
                          set_count1.toString(),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 130,
                  ),
                  SizedBox(
                    width: 70,
                    height: 60,
                    child: Card(
                      child: Center(
                        child: Text(
                          set_count2.toString(),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _incrementCount1();
                        },
                        child: Image.asset(
                          'assets/plus.png',
                          height: 60,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        height: 90,
                        child: Card(
                          child: Center(
                            child: Text(
                              _count1.toString(),
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _decrementCount1();
                        },
                        child: Image.asset(
                          'assets/minus.png',
                          height: 60,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Column(
                      children: [
                        const Text(
                          '<Điểm Chấp>',
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: SizedBox(
                                width: 50,
                                height: 55,
                                child: Center(
                                  child: PlusScore(
                                      onScoreSelected: _handleScoreSelected1),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: SizedBox(
                                width: 50,
                                height: 55,
                                child: Center(
                                  child: PlusScore(
                                      onScoreSelected: _handleScoreSelected2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _incrementCount2();
                        },
                        child: Image.asset(
                          'assets/plus.png',
                          height: 60,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        height: 90,
                        child: Card(
                          child: Center(
                            child: Text(
                              _count2.toString(),
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _decrementCount2();
                        },
                        child: Image.asset(
                          'assets/minus.png',
                          height: 60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 12, right: 12),
                    height: 55,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.green.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TestBottomNavWithAnimatedIcons(
                                      uid: 'djkvndskjnvkjsvnjs')),
                        );
                      },
                      child: const Center(
                          child: Text(
                        'Kết thúc',
                        style: TextStyle(fontSize: 25),
                      )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    height: 55,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.red.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                        child: Text(
                      'Chơi tiếp',
                      style: TextStyle(fontSize: 25),
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
