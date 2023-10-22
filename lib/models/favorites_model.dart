import 'package:flutter/material.dart';

@immutable
class Favorite {
  const Favorite({
    this.userID,
    this.venueID,
  });

  final String? userID;
  final String? venueID;

  factory Favorite.fromDocument(Map<String,dynamic> doc) {
    try {
      return Favorite(
        userID: doc['userID'] as String?? '',
        venueID: doc['venueID'] as String?? '',
      );
    } catch (e) {
      print('****** FAVORITE MODEL ******');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'userID': userID!,
      'venueID': venueID!,
    };
  }
}
