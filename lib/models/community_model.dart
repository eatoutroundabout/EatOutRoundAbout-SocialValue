class Community {
  final String? communityID;
  final String? businessProfileID;
  final String? communityName;
  final List? admin;
  final String? communityIcon;
  final String? communityDescription;
  final String? communityRules;
  final String? communityImage;
  final num? membersCount;
  final num? createdDateTime;
  final List? nameSearch;
  final bool? public;
  final bool? showPosts;

  Community({
    this.communityName,
    this.communityIcon,
    this.communityDescription,
    this.communityRules,
    this.communityID,
    this.businessProfileID,
    this.admin,
    this.communityImage,
    this.membersCount,
    this.createdDateTime,
    this.nameSearch,
    this.public,
    this.showPosts,
  });

  factory Community.fromDocument(Map<String,dynamic> doc) {
    try {
      return Community(
        communityID: doc['communityID'] as String,
        businessProfileID: doc['businessProfileID']as String,
        admin: doc['admin']as List,
        communityName: doc['communityName']as String,
        communityIcon: doc['communityIcon']as String,
        communityDescription: doc['communityDescription']as String ?? 'Welcome to the community',
        communityRules: doc['communityRules'] as String?? '',
        communityImage: doc['communityImage'] as String?? '',
        membersCount: doc['membersCount'] as num?? 0,
        createdDateTime: doc['createdDateTime'] as num?? 0,
        nameSearch: doc['nameSearch']as List,
        public: doc['public'] as bool?? true,
        showPosts: doc['showPosts'] as bool?? true,
      );
    } catch (e) {
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'communityName': communityName!,
      'communityIcon': communityIcon!,
      'communityDescription': communityDescription!,
      'communityRules': communityRules!,
      'communityID': communityID!,
      'businessProfileID': businessProfileID!,
      'admin': admin!,
      'communityImage': communityImage!,
      'membersCount': membersCount!,
      'createdDateTime': createdDateTime!,
      'nameSearch': nameSearch!,
      'public': public!,
      'showPosts': showPosts!,
    };
  }
}
