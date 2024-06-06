import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/components/consts/clb_consts/clb_constants.dart';
import '../../widgets/components/ranking/custom_ranking.dart';
import '../../widgets/components/ranking/list_member.dart';
import '../../widgets/components/ranking/list_ranking.dart';
import '../../widgets/model/club_model.dart';

class RankingScreen extends StatefulWidget {
  RankingScreen({super.key, required this.uid});

  String uid;
  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final Club club = ClbConstants.clubInfo;
  int selectedIndex = 1;
  final List<Member> items = ClbConstants.MemberList;

  final List<String> rank = [];
  @override
  void initState() {
    super.initState();
    items.sort((a, b) {
      return double.parse(b.win_rate.replaceAll('%', ''))
          .compareTo(double.parse(a.win_rate.replaceAll('%', '')));
    });
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // void fetchTeams() async {
  //   try {
  //     // Lấy dữ liệu từ Firestore
  //     QuerySnapshot snapshot = (await FirebaseFirestore.instance
  //         .collection('clubs')
  //         .doc('uid')
  //         .collection('ranking')
  //         .doc(6)
  //         .get()) as QuerySnapshot<Object?>;
  //     List<String> fetchedTeams = [];

  //     // Duyệt qua các tài liệu và thêm tên player vào danh sách
  //     for (var doc in snapshot.docs) {
  //       fetchedTeams.add(
  //           [doc['username'].toString(), doc]); // Thêm player vào danh sách
  //     }

  //     setState(() {
  //       teams = fetchedTeams;
  //     });
  //   } catch (e) {
  //     print("Lỗi khi lấy dữ liệu: $e");
  //   }
  // }

  Widget buildSelectedContent(int index) {
    switch (index) {
      case 0:
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 35.0, top: 16.0, bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('Tuyển thủ', style: TextStyle(fontSize: 18)),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('Thứ hạng', style: TextStyle(fontSize: 18)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('Điểm', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 2, left: 10, right: 10),
                height: 4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return SampleItemWidget(
                    member: items[index],
                    index: index,
                    onTap: (item) {
                      print(item.name); // In ra tên của mục được nhấn
                    },
                  );
                },
                childCount: items.length,
              ),
            ),
          ],
        );
      // return ListView.builder(
      //         shrinkWrap: true,
      //         physics: ScrollPhysics(),
      //         itemCount: items.length,
      //         itemBuilder: (context, index) {
      //           return SampleItemWidget(
      //             item: items[index],
      //             onTap: (item) {
      //               print(item.id); // In ra ID của mục được nhấn
      //             },
      //             );
      //           },
      //         );
      case 1:
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 35.0, top: 16.0, bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('Tuyển thủ', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 2, left: 10, right: 10),
                height: 4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return SampleMemberWidget(
                    member: items[index],
                    index: index,
                    onTap: (item) {
                      print(item.name); // In ra tên của mục được nhấn
                    },
                  );
                },
                childCount: items.length,
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Câu Lạc Bộ',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.none),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ClipOval(
              child: Image.asset(
                club.imageUrl,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(club.name,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Quản lý CLB: ${club.owner}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Địa chỉ: ${club.location}',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(
                        12.0), // Bạn có thể chỉnh sửa giá trị này để thay đổi độ bo tròn
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ClubListScreen()));
                    },
                    child: const Padding(
                      // Thêm padding để khoảng cách giữa text và biên container đẹp hơn
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Quản lý',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: <Widget>[
                TransparentButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  }, // set text color to white
                  isSelected: selectedIndex == 1,
                  child: const Text('Thành viên',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
                const SizedBox(height: 20),
                TransparentButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  }, // set text color to white
                  isSelected: selectedIndex == 0,
                  child: const Text('Xếp hạng',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
              ],
            ),
          ),
          // SizedBox(height: 15),
          // const Padding(
          //   padding: EdgeInsets.only(left: 35.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         flex: 2,
          //           child: Text('Tuyển thủ',style: TextStyle(fontSize: 18),)
          //       ),
          //       SizedBox(width: 40,),
          //       Expanded(
          //         flex: 2,
          //           child: Text('Xếp hạng',style: TextStyle(fontSize: 18))
          //       ),
          //       Expanded(
          //         flex: 1,
          //           child: Text('Thắng',style: TextStyle(fontSize: 18))
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 5,),
          // Container(
          //   margin: EdgeInsets.only(bottom: 2,left: 10,right: 10),
          //   height: 4,
          //   width: MediaQuery.of(context).size.width,
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade600,
          //     borderRadius: BorderRadius.all(Radius.circular(12)),
          //   ),
          // ),
          Expanded(child: buildSelectedContent(selectedIndex)),
        ],
      ),
    );
  }
}
