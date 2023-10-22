import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String? sentBy;
  final String? message;
  final String? chatRoomID;
  final int? time;

  Chat({
    this.sentBy,
    this.chatRoomID,
    this.time,
    this.message,
  });

  factory Chat.fromDocument(DocumentSnapshot documentSnapshot) {
    try {
      Map<String, dynamic> doc = documentSnapshot.data() as Map<String, dynamic>;
      return Chat(
        time: doc['time'],
        message: doc['message'],
        chatRoomID: doc['chatRoomID'],
        sentBy: doc['sentBy'],
      );
    } catch (e) {
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'sentBy': sentBy!,
      'chatRoomID': chatRoomID!,
      'time': time!,
      'message': message!,
    };
  }
}
