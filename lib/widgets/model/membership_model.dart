class Member {
  final String name;
  final String image;
  final String win_rate;
  bool isPaid;
  double fee;

  Member({
    required this.name,
    required this.image,
    required this.win_rate,
    this.isPaid = false,
    this.fee = 0.0,
  });
}

