class UserList {
  final List<User>? userList;

  UserList({
    this.userList,
  });

  factory UserList.fromJson(List<dynamic> parsedJson) {
    List<User> userList = parsedJson.map((i) => User.fromJson(i)).toList();
    return UserList(userList: userList);
  }
}

class User {
  final String? accountID;
  final String? userID;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobile;
  final String? photoURL;
  final List? usedPromoCodes;
  final String? employerName;
  final String? livePostcodeDocId;
  final String? niNumber;
  final String? workPostcodeDocId;
  final bool? showTips;
  final bool? isMarketing;
  final bool? isPushNotifications;
  final bool? isEconomyTips;
  final bool? presentProfile;
  final bool? eventVisibility;
  final bool? shareInCircle;
  final bool? isCircleUser;
  final bool? isAccountAdmin;
  final bool? isVenueAdmin;
  bool? unreadBadges;
  bool? unreadClaims;
  bool? unreadNotifications;
  bool? unreadMessages;
  final String? dob;
  final String? token;
  final String? userReferralCode;
  final String? jobTitle;
  final String? jobFunction;
  final String? helpYou;
  final String? jobLevel;
  final String? userBio;
  final String? status;
  final num? connections;
  final num? biteBalance;
  final List? services;
  final List? accountAdmin;
  final List? venueAdmin;
  final List? venueStaff;
  final List? businessProfileAdmin;
  final List? businessProfileStaff;
  final List? intolerances;
  final List? allergies;
  final bool? vegan;
  final bool? vegetarian;
  final bool? halal;
  final bool? paleo;
  final bool? ketogenic;
  final bool? smsUpdates;
  final bool? emailUpdates;
  final bool? retainInformation;

  User({
    this.accountID,
    this.userID,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.photoURL,
    this.usedPromoCodes,
    this.employerName,
    this.livePostcodeDocId,
    this.niNumber,
    this.workPostcodeDocId,
    this.showTips,
    this.isMarketing,
    this.isPushNotifications,
    this.isEconomyTips,
    this.presentProfile,
    this.eventVisibility,
    this.shareInCircle,
    this.isCircleUser,
    this.isAccountAdmin,
    this.isVenueAdmin,
    this.unreadBadges,
    this.unreadClaims,
    this.unreadNotifications,
    this.unreadMessages,
    this.dob,
    this.token,
    this.userReferralCode,
    this.jobTitle,
    this.jobFunction,
    this.helpYou,
    this.jobLevel,
    this.userBio,
    this.status,
    this.connections,
    this.biteBalance,
    this.services,
    this.accountAdmin,
    this.venueAdmin,
    this.venueStaff,
    this.businessProfileAdmin,
    this.businessProfileStaff,
    this.intolerances,
    this.allergies,
    this.vegan,
    this.vegetarian,
    this.halal,
    this.paleo,
    this.ketogenic,
    this.smsUpdates,
    this.emailUpdates,
    this.retainInformation,
  });

  factory User.fromJson(var json) {
    return User(
      photoURL: json['profilePic'],
      firstName: json['name'],
      userID: json['userID'],
    );
  }

  factory User.fromDocument(Map<String, dynamic> doc) {
    return User(
      accountID: doc['accountID'] ?? null,
      userID: doc['userID'] ?? '',
      firstName: doc['firstName'] ?? '',
      lastName: doc['lastName'] ?? '',
      email: doc['email'] ?? '',
      mobile: doc['mobile'] ?? '',
      photoURL: doc['photoURL'] ?? 'profile',
      usedPromoCodes: doc['usedPromoCodes'] ?? [],
      employerName: doc['employerName'].toString(),
      livePostcodeDocId: doc['livePostcodeDocId'] ?? '',
      niNumber: doc['niNumber'].toString(),
      workPostcodeDocId: doc['workPostcodeDocId'] ?? '',
      showTips: doc['showTips'] ?? false,
      isMarketing: doc['isMarketing'] ?? false,
      isPushNotifications: doc['isPushNotifications'] ?? false,
      isEconomyTips: doc['isEconomyTips'] ?? false,
      presentProfile: doc['presentProfile'] ?? false,
      eventVisibility: doc['eventVisibility'] ?? false,
      shareInCircle: doc['shareInCircle'] ?? false,
      isCircleUser: doc['isCircleUser'] ?? false,
      isAccountAdmin: doc['isAccountAdmin'] ?? false,
      isVenueAdmin: doc['isVenueAdmin'] ?? false,
      unreadBadges: doc['unreadBadges'] ?? false,
      unreadClaims: doc['unreadClaims'] ?? false,
      unreadNotifications: doc['unreadNotifications'] ?? false,
      unreadMessages: doc['unreadMessages'] ?? false,
      dob: doc['dob'] ?? '',
      token: doc['token'] ?? '',
      userReferralCode: doc['userReferralCode'] ?? '',
      jobTitle: doc['jobTitle'] ?? 'None',
      jobFunction: doc['jobFunction'] ?? 'None',
      helpYou: doc['helpYou'] ?? '',
      jobLevel: doc['jobLevel'] ?? 'None',
      userBio: doc['userBio'] ?? '',
      status: doc['status'] ?? '',
      connections: doc['connections'] ?? 0,
      biteBalance: doc['biteBalance'] ?? 0,
      services: doc['services'] ?? [],
      accountAdmin: doc['accountAdmin'] ?? [],
      venueAdmin: doc['venueAdmin'] ?? [],
      venueStaff: doc['venueStaff'] ?? [],
      businessProfileAdmin: doc['businessProfileAdmin'] ?? [],
      businessProfileStaff: doc['businessProfileStaff'] ?? [],
      intolerances: doc['intolerances'] ?? [],
      allergies: doc['allergies'] ?? [],
      vegan: doc['vegan'] ?? false,
      vegetarian: doc['vegetarian'] ?? false,
      halal: doc['halal'] ?? false,
      paleo: doc['paleo'] ?? false,
      ketogenic: doc['ketogenic'] ?? false,
      smsUpdates: doc['smsUpdates'] ?? false,
      emailUpdates: doc['emailUpdates'] ?? false,
      retainInformation: doc['retainInformation'] ?? false,
    );
   /* try {
      return User(
        accountID: doc['accountID'] as String?? null,
        userID: doc['userID'] as String?? '',
        firstName: doc['firstName'] as String?? '',
        lastName: doc['lastName'] as String?? '',
        email: doc['email'] as String?? '',
        mobile: doc['mobile'] as String?? '',
        photoURL: doc['photoURL'] as String?? 'profile',
        usedPromoCodes: doc['usedPromoCodes'] as List?? [],
        employerName: doc['employerName'] as String?? '',
        livePostcodeDocId: doc['livePostcodeDocId'] as String?? '',
        niNumber: doc['niNumber'] as String?? '',
        workPostcodeDocId: doc['workPostcodeDocId'] as String?? '',
        showTips: doc['showTips'] as bool?? false,
        isMarketing: doc['isMarketing'] as bool?? false,
        isPushNotifications: doc['isPushNotifications'] as bool?? false,
        isEconomyTips: doc['isEconomyTips'] as bool?? false,
        presentProfile: doc['presentProfile'] as bool?? false,
        eventVisibility: doc['eventVisibility'] as bool?? false,
        shareInCircle: doc['shareInCircle'] as bool?? false,
        isCircleUser: doc['isCircleUser'] as bool?? false,
        isAccountAdmin: doc['isAccountAdmin'] as bool?? false,
        isVenueAdmin: doc['isVenueAdmin'] as bool?? false,
        unreadBadges: doc['unreadBadges'] as bool?? false,
        unreadClaims: doc['unreadClaims'] as bool?? false,
        unreadNotifications: doc['unreadNotifications'] as bool?? false,
        unreadMessages: doc['unreadMessages'] as bool?? false,
        dob: doc['dob'] as String?? '',
        token: doc['token'] as String?? '',
        userReferralCode: doc['userReferralCode'] as String?? '',
        jobTitle: doc['jobTitle'] as String?? 'None',
        jobFunction: doc['jobFunction'] as String?? 'None',
        helpYou: doc['helpYou'] as String?? '',
        jobLevel: doc['jobLevel'] as String?? 'None',
        userBio: doc['userBio'] as String?? '',
        status: doc['status'] as String?? '',
        connections: doc['connections'] as num?? 0,
        biteBalance: doc['biteBalance'] as num?? 0,
        services: doc['services'] as List?? [],
        accountAdmin: doc['accountAdmin'] as List?? [],
        venueAdmin: doc['venueAdmin'] as List?? [],
        venueStaff: doc['venueStaff'] as List?? [],
        businessProfileAdmin: doc['businessProfileAdmin'] as List?? [],
        businessProfileStaff: doc['businessProfileStaff'] as List?? [],
        intolerances: doc['intolerances'] as List?? [],
        allergies: doc['allergies'] as List?? [],
        vegan: doc['vegan'] as bool?? false,
        vegetarian: doc['vegetarian'] as bool?? false,
        halal: doc['halal'] as bool?? false,
        paleo: doc['paleo'] as bool?? false,
        ketogenic: doc['ketogenic'] as bool?? false,
        smsUpdates: doc['smsUpdates'] as bool?? false,
        emailUpdates: doc['emailUpdates'] as bool?? false,
        retainInformation: doc['retainInformation'] as bool?? false,
      );
    } catch (e) {
      print('****** USER MODEL ******');
      print(e);
      return null!;
    }*/
  }

  Map<String, Object> toJson() {
    return {
      'accountID': accountID!,
      'userID': userID!,
      'firstName': firstName!,
      'lastName': lastName!,
      'email': email!,
      'mobile': mobile!,
      'photoURL': photoURL!,
      'usedPromoCodes': usedPromoCodes!,
      'employerName': employerName!,
      'livePostcodeDocId': livePostcodeDocId!,
      'niNumber': niNumber!,
      'workPostcodeDocId': workPostcodeDocId!,
      'showTips': showTips!,
      'isMarketing': isMarketing!,
      'isPushNotifications': isPushNotifications!,
      'isEconomyTips': isEconomyTips!,
      'presentProfile': presentProfile!,
      'eventVisibility': eventVisibility!,
      'shareInCircle': shareInCircle!,
      'isCircleUser': isCircleUser!,
      'isAccountAdmin': isAccountAdmin!,
      'isVenueAdmin': isVenueAdmin!,
      'unreadBadges': unreadBadges!,
      'unreadClaims': unreadClaims!,
      'unreadNotifications': unreadNotifications!,
      'unreadMessages': unreadMessages!,
      'dob': dob!,
      'token': token!,
      'userReferralCode': userReferralCode!,
      'jobTitle': jobTitle!,
      'jobFunction': jobFunction!,
      'helpYou': helpYou!,
      'jobLevel': jobLevel!,
      'userBio': userBio!,
      'status': status!,
      'connections': connections!,
      'biteBalance': biteBalance!,
      'services': services!,
      'accountAdmin': accountAdmin!,
      'venueAdmin': venueAdmin!,
      'venueStaff': venueStaff!,
      'businessProfileAdmin': businessProfileAdmin!,
      'businessProfileStaff': businessProfileStaff!,
      'intolerances': intolerances!,
      'allergies': allergies!,
      'vegan': vegan!,
      'vegetarian': vegetarian!,
      'halal': halal!,
      'paleo': paleo!,
      'ketogenic': ketogenic!,
      'smsUpdates': smsUpdates!,
      'emailUpdates': emailUpdates!,
      'retainInformation': retainInformation!,
    };
  }
}
