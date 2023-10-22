class Connection {
  final List? connections;
  final List? inBoundRequests;
  final List? outBoundRequests;
  final List? friends;

  Connection({
    this.connections,
    this.inBoundRequests,
    this.outBoundRequests,
    this.friends,
  });

  factory Connection.fromDocument(Map<String, dynamic> doc) {
    return Connection(
      connections: doc['connections']  ?? [],
      inBoundRequests: doc['inBoundRequests'] ?? [],
      outBoundRequests: doc['outBoundRequests'] ?? [],
      friends: doc['friends'] ?? [],
    );
    try {
      return Connection(
        connections: doc['connections'] as List ?? [],
        inBoundRequests: doc['inBoundRequests'] as List?? [],
        outBoundRequests: doc['outBoundRequests'] as List?? [],
        friends: doc['friends'] as List?? [],
      );
    } catch (e) {
      print('****** CONNECTION MODEL ******');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'connections': connections!,
      'inBoundRequests': inBoundRequests!,
      'outBoundRequests': outBoundRequests!,
      'friends': friends!,
    };
  }
}
