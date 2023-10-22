class Conversation {
  final String? chatRoomID;
  final List? users;
  final String? lastMessage;
  final int? lastMessageTime;

  Conversation({
    this.users,
    this.lastMessage,
    this.lastMessageTime,
    this.chatRoomID,
  });

  factory Conversation.fromDocument(Map<String, dynamic> doc) {
    try {
      return Conversation(
        chatRoomID: doc['chatRoomID']as String,
        users: doc['users']as List,
        lastMessage: doc['lastMessage'] as String,
        lastMessageTime: doc['lastMessageTime'] as int,
      );
    } catch (e) {
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'chatRoomID': chatRoomID!,
      'users': users!,
      'lastMessage': lastMessage!,
      'lastMessageTime': lastMessageTime!,
    };
  }
}
