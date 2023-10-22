import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String? notificationID;
  final String? type;
  final String? receiverUserID;
  final String? senderUserID;
  final String? eventID;
  final String? venueID;
  final String? chatRoomID;
  final Timestamp? creationDate;

  NotificationModel({
    this.notificationID,
    this.type,
    this.receiverUserID,
    this.senderUserID,
    this.eventID,
    this.venueID,
    this.chatRoomID,
    this.creationDate,
  });

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    try {
      Map<String, dynamic> snapshot = doc.data() as Map<String,dynamic>;
      DateTime date = DateTime(2021);
      return NotificationModel(
        notificationID: snapshot.containsKey('notificationID') ? doc.get('notificationID') : '',
        type: snapshot.containsKey('type') ? doc.get('type') : '',
        receiverUserID: snapshot.containsKey('receiverUserID') ? doc.get('receiverUserID') : '',
        senderUserID: snapshot.containsKey('senderUserID') ? doc.get('senderUserID') : '',
        eventID: snapshot.containsKey('eventID') ? doc.get('eventID') : '',
        venueID: snapshot.containsKey('venueID') ? doc.get('venueID') : '',
        chatRoomID: snapshot.containsKey('chatRoomID') ? doc.get('chatRoomID') : '',
        creationDate: snapshot.containsKey('creationDate') ? doc.get('creationDate') : Timestamp.fromDate(date),
      );
    } catch (e) {
      print('****** NOTIFICATION MODEL ******');
      print(e);
      return null!;
    }
  }
}
