import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';

Future<T>? showSlideDialog<T>({
  @required BuildContext? context,
  @required Widget? child,
  double? top,
}) {
  assert(context != null);
  assert(child != null);

   showGeneralDialog(
    context: context!,
    barrierDismissible: true,
    transitionDuration: Duration(milliseconds: 200),
    barrierLabel: 'Settings',
    barrierColor: Colors.black.withOpacity(0.5),
    useRootNavigator: false,
    pageBuilder: (context, __, _) {
      return Material(
        color: appBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: child,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: CurvedAnimation(parent: animation, curve: Curves.easeOut).drive(Tween<Offset>(begin: Offset(0, 1), end: Offset(0, top!))),
        child: child,
      );
    },
  );
}
