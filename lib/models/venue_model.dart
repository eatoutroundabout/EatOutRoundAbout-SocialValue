class Venue {
  final String? accountID;
  final String? accountAdmin;
  final List? receptionist;
  final String? customerPromoCode;
  final String? staffPromoCode;
  final String? venueID;
  final String? venueName;
  final String? streetAddress;
  final String? townCity;
  final String? postCode;
  final num? noEmployees;
  final String? venueDescription;
  final String? venuePhoneNumber;
  final String? venueBookingLink;
  final String? website;
  final String? logo;
  final List? images;
  final String? coverURL;
  final bool? dogFriendly;
  final bool? acceptTableBooking;
  bool? paused;
  final bool? approved;
  final bool? goodToGo;
  final bool? goodToGoCertificateApproved;
  final bool? wheelChairAccess;
  final bool? preTheatreDining;
  final bool? takeaway;
  final bool? showTips;
  final List? foodTypes;
  final List? dietaryPreferences;
  final List? intolerances;
  final List? allergies;
  final num? averageRating;
  final num? totalRatingsCount;
  final String? venueImpactStatus;
  final Days? monday, tuesday, wednesday, thursday, friday, saturday, sunday;
  final String? lepRestricted;
  final String? localAuthRestricted;
  final String? wardRestricted;
  final String? venueRestricted;
  final String? bidRestricted;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? linkedin;

  Venue({
    this.accountID,
    this.accountAdmin,
    this.receptionist,
    this.customerPromoCode,
    this.staffPromoCode,
    this.venueID,
    this.venueName,
    this.streetAddress,
    this.townCity,
    this.postCode,
    this.noEmployees,
    this.venueDescription,
    this.venueBookingLink,
    this.website,
    this.venuePhoneNumber,
    this.logo,
    this.images,
    this.coverURL,
    this.paused,
    this.dogFriendly,
    this.acceptTableBooking,
    this.approved,
    this.goodToGo,
    this.goodToGoCertificateApproved,
    this.wheelChairAccess,
    this.preTheatreDining,
    this.takeaway,
    this.showTips,
    this.foodTypes,
    this.dietaryPreferences,
    this.intolerances,
    this.allergies,
    this.averageRating,
    this.totalRatingsCount,
    this.venueImpactStatus,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.lepRestricted,
    this.localAuthRestricted,
    this.wardRestricted,
    this.venueRestricted,
    this.bidRestricted,
    this.facebook,
    this.instagram,
    this.twitter,
    this.linkedin,
  });

  factory Venue.fromDocument(Map<String, dynamic> doc) {
    return Venue(
      accountID: doc['accountID'] ?? ' ',
      accountAdmin: doc['accountAdmin'] ?? '',
      receptionist: doc['receptionist'] ?? [],
      customerPromoCode: doc['customerPromoCode'] ?? '',
      staffPromoCode: doc['staffPromoCode'] ?? '',
      venueID: doc['venueID'] ?? '',
      venueName: doc['venueName'] ?? '',
      streetAddress: doc['streetAddress'] ?? '',
      townCity: doc['townCity'] ?? '',
      postCode: doc['postCode'] ?? '',
      noEmployees: doc['noEmployees'] ?? 0,
      venueDescription: doc['venueDescription'] ?? '',
      venueBookingLink: doc['venueBookingLink'] ?? '',
      website: doc['website'] ?? '',
      venuePhoneNumber: doc['venuePhoneNumber'] ?? '',
      logo: doc['logo'] ?? '',
      images: doc['images'] ?? doc['coverURL'] ?? ''??[],
      coverURL: doc['coverURL'] ?? '',
      paused: doc['paused'] ?? false,
      dogFriendly: doc['dogFriendly'] ?? false,
      acceptTableBooking: doc['acceptTableBooking'] ?? false,
      approved: doc['approved'] ?? false,
      goodToGo: doc['goodToGo'] ?? false,
      goodToGoCertificateApproved: doc['goodToGoCertificateApproved'] ?? false,
      wheelChairAccess: doc['wheelChairAccess'] ?? false,
      preTheatreDining: doc['preTheatreDining'] ?? false,
      takeaway: doc['takeaway'] ?? false,
      showTips: doc['showTips'] ?? false,
      foodTypes: doc['foodTypes'] ?? [],
      dietaryPreferences: doc['dietaryPreferences'] ?? [],
      intolerances: doc['intolerances'] ?? [],
      allergies: doc['allergies'] ?? [],
      monday: doc['monday'] != null ? Days.fromDocument(doc['monday']as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
      tuesday: doc['tuesday'] != null ? Days.fromDocument(doc['tuesday']as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
      wednesday: doc['wednesday'] != null ? Days.fromDocument(doc['wednesday']as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
      thursday: doc['thursday'] != null ? Days.fromDocument(doc['thursday']as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
      friday: doc['friday'] != null ? Days.fromDocument(doc['friday']as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
      saturday: doc['saturday'] != null ? Days.fromDocument(doc['saturday']as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
      sunday: doc['sunday'] != null ? Days.fromDocument(doc['sunday'] as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
      lepRestricted: doc['lepRestricted'] ?? '',
      localAuthRestricted: doc['localAuthRestricted'] ?? '',
      wardRestricted: doc['wardRestricted'] ?? '',
      venueRestricted: doc['venueRestricted'] ?? '',
      bidRestricted: doc['bidRestricted'] ?? '',
      facebook: doc['facebook'] ?? '',
      instagram: doc['instagram'] ?? '',
      twitter: doc['twitter'] ?? '',
      linkedin: doc['linkedin'] ?? '',
      averageRating: doc['averageRating'] ?? 0,
      totalRatingsCount: doc['totalRatingsCount'] ?? 0,
      venueImpactStatus: doc['venueImpactStatus'] ?? 'none',
    );
    try {
      return Venue(
        accountID: doc['accountID'] as String?? ' ',
        accountAdmin: doc['accountAdmin'] as String?? '',
        receptionist: doc['receptionist'] as List?? [],
        customerPromoCode: doc['customerPromoCode'] as String?? '',
        staffPromoCode: doc['staffPromoCode'] as String?? '',
        venueID: doc['venueID'] as String?? '',
        venueName: doc['venueName'] as String?? '',
        streetAddress: doc['streetAddress'] as String?? '',
        townCity: doc['townCity'] as String?? '',
        postCode: doc['postCode'] as String?? '',
        noEmployees: doc['noEmployees'] as num?? 0,
        venueDescription: doc['venueDescription'] as String?? '',
        venueBookingLink: doc['venueBookingLink'] as String?? '',
        website: doc['website'] as String?? '',
        venuePhoneNumber: doc['venuePhoneNumber'] as String?? '',
        logo: doc['logo'] as String?? '',
        images: doc[['images'] as String?? [doc['coverURL'] as String?? '']]as List??[],
        coverURL: doc['coverURL'] as String?? '',
        paused: doc['paused'] as bool?? false,
        dogFriendly: doc['dogFriendly'] as bool?? false,
        acceptTableBooking: doc['acceptTableBooking'] as bool?? false,
        approved: doc['approved'] as bool?? false,
        goodToGo: doc['goodToGo'] as bool?? false,
        goodToGoCertificateApproved: doc['goodToGoCertificateApproved'] as bool?? false,
        wheelChairAccess: doc['wheelChairAccess'] as bool?? false,
        preTheatreDining: doc['preTheatreDining'] as bool?? false,
        takeaway: doc['takeaway'] as bool?? false,
        showTips: doc['showTips'] as bool?? false,
        foodTypes: doc['foodTypes'] as List?? [],
        dietaryPreferences: doc['dietaryPreferences'] as List?? [],
        intolerances: doc['intolerances'] as List?? [],
        allergies: doc['allergies'] as List?? [],
        monday: doc['monday'] != null ? Days.fromDocument(doc['monday']as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
        tuesday: doc['tuesday'] != null ? Days.fromDocument(doc['tuesday']as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
        wednesday: doc['wednesday'] != null ? Days.fromDocument(doc['wednesday']as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
        thursday: doc['thursday'] != null ? Days.fromDocument(doc['thursday']as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
        friday: doc['friday'] != null ? Days.fromDocument(doc['friday']as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
        saturday: doc['saturday'] != null ? Days.fromDocument(doc['saturday']as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
        sunday: doc['sunday'] != null ? Days.fromDocument(doc['sunday'] as Map<dynamic,dynamic>) : Days(isOpen: false, accept: false, open: 0, close: 0),
        lepRestricted: doc['lepRestricted'] as String?? '',
        localAuthRestricted: doc['localAuthRestricted'] as String?? '',
        wardRestricted: doc['wardRestricted'] as String?? '',
        venueRestricted: doc['venueRestricted'] as String?? '',
        bidRestricted: doc['bidRestricted'] as String?? '',
        facebook: doc['facebook'] as String?? '',
        instagram: doc['instagram'] as String?? '',
        twitter: doc['twitter'] as String?? '',
        linkedin: doc['linkedin'] as String?? '',
        averageRating: doc['averageRating'] as num?? 0,
        totalRatingsCount: doc['totalRatingsCount'] as num?? 0,
        venueImpactStatus: doc['venueImpactStatus'] as String?? 'none',
      );
    } catch (e) {
      print('########## VENUE MODEL ###########');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'accountID': accountID!,
      'accountAdmin': accountAdmin!,
      'receptionist': receptionist!,
      'customerPromoCode': customerPromoCode!,
      'staffPromoCode': staffPromoCode!,
      'venueID': venueID!,
      'venueName': venueName!,
      'streetAddress': streetAddress!,
      'townCity': townCity!,
      'postCode': postCode!,
      'noEmployees': noEmployees!,
      'venueDescription': venueDescription!,
      'venueBookingLink': venueBookingLink!,
      'website': website!,
      'venuePhoneNumber': venuePhoneNumber!,
      'logo': logo!,
      'images': images!,
      'coverURL': coverURL!,
      'paused': paused!,
      'dogFriendly': dogFriendly!,
      'acceptTableBooking': acceptTableBooking!,
      'approved': approved!,
      'goodToGo': goodToGo!,
      'goodToGoCertificateApproved': goodToGoCertificateApproved!,
      'wheelChairAccess': wheelChairAccess!,
      'preTheatreDining': preTheatreDining!,
      'takeaway': takeaway!,
      'showTips': showTips!,
      'foodTypes': foodTypes!,
      'dietaryPreferences': dietaryPreferences!,
      'intolerances': intolerances!,
      'allergies': allergies!,
      'monday': monday!.toMap(),
      'tuesday': tuesday!.toMap(),
      'wednesday': wednesday!.toMap(),
      'thursday': thursday!.toMap(),
      'friday': friday!.toMap(),
      'saturday': saturday!.toMap(),
      'sunday': sunday!.toMap(),
      'lepRestricted': lepRestricted!,
      'localAuthRestricted': localAuthRestricted!,
      'wardRestricted': wardRestricted!,
      'venueRestricted': venueRestricted!,
      'bidRestricted': bidRestricted!,
      'facebook': facebook!,
      'instagram': instagram!,
      'twitter': twitter!,
      'linkedin': linkedin!,
      'averageRating': averageRating!,
      'totalRatingsCount': totalRatingsCount!,
      'venueImpactStatus': venueImpactStatus!,
    };
  }
}

class Days {
  num? open;
  num? close;
  bool? accept;
  bool? isOpen;

  Days({this.open, this.close, this.accept, this.isOpen});

  factory Days.fromDocument(Map doc) {
    try {
      return Days(
        open: doc['open'] ?? '',
        close: doc['close'] ?? '',
        accept: doc['accept'] ?? true,
        isOpen: doc['isOpen'] ?? true,
      );
    } catch (e) {
      print('#########  Days  #########');
      print(e);
      return null!;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'open': open,
      'close': close,
      'accept': accept,
      'isOpen': isOpen,
    };
  }
}
