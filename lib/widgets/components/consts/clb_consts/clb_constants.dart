import 'package:test_project/widgets/model/club_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClbConstants {
  static Club clubInfo = Club(
    name: 'CLB Bóng Bàn Resco',
    owner: 'Nguyễn Văn A',
    location: '123 Đường ABC, Quận 1, TP.HCM',
    description: "A great club for ping pong enthusiasts.",
    members: MemberList,
    imageUrl: 'assets/categories/book_img.png',
    foundingDate: DateTime.now(),
    activeYears: 2014,
  );

  static List<Member> MemberList = [
    Member(
      image: "assets/categories/book_img.png",
      name: "A",
      role: 'Thành viên',
      win_rate: '50',
    ),
    Member(
      image: "assets/categories/notification-bell.png",
      name: "B",
      role: 'Thành viên',
      win_rate: '60',
    ),
    Member(
      image: "assets/categories/logo.png",
      name: "C",
      role: 'Thành viên',
      win_rate: '70',
    ),
    Member(
      image: "assets/categories/medal.png",
      name: "D",
      role: 'Thành viên',
      win_rate: '80',
    ),
    Member(
      image: "assets/categories/watch.png",
      name: "E",
      role: 'Thành viên',
      win_rate: '90',
    ),
    Member(
      image: "assets/categories/fashion.png",
      name: "F",
      role: 'Thành viên',
      win_rate: '85',
    ),
    Member(
      image: "assets/categories/shoes.png",
      name: "G",
      role: 'Thành viên',
      win_rate: '75',
    ),
    Member(
      image: "assets/categories/cosmetics.png",
      name: "H",
      role: 'Thành viên',
      win_rate: '65',
    ),
  ];
}
