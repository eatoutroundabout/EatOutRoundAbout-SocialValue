class CommunityMember {
  final String? userID;
  final String? communityID;
  final bool? approved;
  final int? createdDateTime;

  CommunityMember({
    this.communityID,
    this.userID,
    this.createdDateTime,
    this.approved,
  });

  factory CommunityMember.fromDocument(Map<String, dynamic> doc) {
    try {
      return CommunityMember(
        userID: doc['userID'] as String,
        communityID: doc['communityID'] as String,
        approved: doc['approved'] as bool?? true,
        createdDateTime: doc['createdDateTime'] as int,
      );
    } catch (e) {
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'communityID': communityID!,
      'userID': userID!,
      'createdDateTime': createdDateTime!,
      'approved': approved!,
    };
  }
}
