import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';

class ColorCard extends StatelessWidget {
  final String? title, subTitle;
  final Color? color;

  const ColorCard({this.title, this.subTitle, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(padding * 2),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(padding / 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title!, textScaleFactor: 1.5, style: TextStyle(color: Colors.white)),
                SizedBox(height: 15),
                Text(subTitle!, style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Column(
            children: [
              Icon(Icons.arrow_forward, color: Colors.white, size: 30),
            ],
          )
        ],
      ),
    );
  }
}
