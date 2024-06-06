import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.uid});

  final String uid;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Meeting> meetings = [];

  @override
  void initState() {
    super.initState();
    fetchMeetings();
  }

  String clubId = '';

  void fetchMeetings() async {
    try {
      QuerySnapshot clubSnapshot = await FirebaseFirestore.instance
          .collection('clubs')
          .where('uid', isEqualTo: widget.uid)
          .get();

      // Nếu không tìm thấy câu lạc bộ, in ra thông báo và không thêm dữ liệu vào Firestore
      if (clubSnapshot.docs.isNotEmpty) {
        clubId = clubSnapshot.docs.first.id;
        print('Đã tìm thấy câu lạc bộ cho người chơi có ID: ${widget.uid}');
      } else {
        print('Không tìm thấy câu lạc bộ cho người chơi có ID: ${widget.uid}');
        return;
      }

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('matches').get();
      List<Meeting> fetchedMeetings = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime startTime = DateTime.parse(data['time']);
        String eventName = '${data['team1']} vs ${data['team2']}';
        print(data['team2']);

        return Meeting(
          eventName,
          startTime,
          startTime.add(
            const Duration(minutes: 20),
          ), // Giả sử mỗi trận đấu kéo dài 20 phút
          Colors.blue,
          false,
        );
      }).toList();

      setState(() {
        print(fetchedMeetings[0].eventName);
        meetings = fetchedMeetings;
      });
    } catch (error) {
      print('Lỗi khi lấy dữ liệu: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: MeetingDataSource(meetings),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(
    this.eventName,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
  );

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
