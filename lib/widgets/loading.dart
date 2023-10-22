import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';

class LoadingData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(borderRadius: BorderRadius.circular(padding / 2), child: Image.asset('assets/images/loading.gif', height: 70)),
    );
  }
}
