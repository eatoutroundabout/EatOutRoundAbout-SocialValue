class Greeting {
  final List? cards;
  final num? priority;
  final String? type;
  final String? venueID;

  Greeting({
    this.cards,
    this.priority,
    this.type,
    this.venueID,
  });

  factory Greeting.fromDocument(Map<String, Object> doc) {
    try {
      return Greeting(
        cards: doc['cards'] as List?? [],
        priority: doc['priority'] as num?? 0,
        type: doc['type'] as String?? '',
        venueID: doc['venueID'] as String?? '',
      );
    } catch (e) {
      print('########## GREETINGS MODEL ###########');
      print(e);
      return null!;
    }
  }
}
