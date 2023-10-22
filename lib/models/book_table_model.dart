import 'package:cloud_firestore/cloud_firestore.dart';

class BookTableModel {
  final bool? confirmed;
  final num? noAttendees;
  final String? userID;
  final String? eventID;
  final String? venueID;
  final Timestamp? startTime;

  BookTableModel({
    this.confirmed,
    this.noAttendees,
    this.userID,
    this.eventID,
    this.venueID,
    this.startTime,
  });

  factory BookTableModel.fromDocument(Map<String, dynamic> doc) {
    try {
      return BookTableModel(
        confirmed: doc['confirmed'] as bool ?? false,
        noAttendees: doc['noAttendees'] as num ?? 0,
        userID: doc['userID'] as String ?? '',
        eventID: doc['eventID'] as String ?? '',
        venueID: doc['venueID'] as String?? '',
        startTime: doc['startTime'] as Timestamp?? Timestamp.now(),
      );
    } catch (e) {
      print('****** EVENTS MODEL ******');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'confirmed': confirmed!,
      'noAttendees': noAttendees!,
      'userID': userID!,
      'eventID': eventID!,
      'venueID': venueID!,
      'startTime': startTime!,
    };
  }
}
