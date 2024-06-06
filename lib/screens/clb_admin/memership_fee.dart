import 'dart:ui';

import 'package:flutter/material.dart';

import '../../widgets/model/membership_model.dart';

class MemberShipWidget extends StatelessWidget {
  final Member member;
  final int index;
  final void Function(Member)? onTap;

  MemberShipWidget({
    Key? key,
    required this.member,
    required this.index,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: AssetImage(member.image),
      ),
      title: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              member.name,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Số tiền: ${member.fee.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: Icon(
              member.isPaid ? Icons.check : Icons.close,
              color: member.isPaid ? Colors.green : Colors.red,
            ),
            onPressed: onTap != null ? () => onTap!(member) : null,
          ),
        ],
      ),
    );
  }
}
