import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? accountID;
  final String? businessProfileID;
    final String? eventCode;
  final String? userID;
  final String? bookingLink;
  final String? facebookLink;
  final String? linkedInLink;
  final String? otherLink;
  final Timestamp? creationDate;
  final String? description;
  final List? attendeeUserIDs;
  final Timestamp? eventDateTimeFrom;
  final Timestamp? eventDateTimeTo;
  final String? eventID;
  final List? eventImages;
  final String? eventTitle;
  final String? eventType;
  final num? capacity;
  final num? pricePerHead;
  final bool? publicEvent;
  final String? summary;
  final String? category;
  final String? streetAddress;
  final String? townCity;
  final String? postCode;
  final String? eventBriteEventID;
  final String? eventBriteOrgID;
  final List? checkedInUserIDs;
  bool? privacyPolicy;
  bool? tnc;
  bool? approved;

  Event({
    this.accountID,
    this.businessProfileID,
        this.eventCode,
    this.userID,
    this.bookingLink,
    this.facebookLink,
    this.linkedInLink,
    this.otherLink,
    this.creationDate,
    this.description,
    this.attendeeUserIDs,
    this.eventDateTimeFrom,
    this.eventDateTimeTo,
    this.eventID,
    this.eventImages,
    this.eventTitle,
    this.eventType,
    this.capacity,
    this.pricePerHead,
    this.publicEvent,
    this.summary,
    this.category,
    this.streetAddress,
    this.townCity,
    this.postCode,
    this.eventBriteEventID,
    this.eventBriteOrgID,
    this.checkedInUserIDs,
    this.privacyPolicy,
    this.tnc,
    this.approved,
  });

  factory Event.fromDocument(Map<String, dynamic> doc) {
    try {
      return Event(
        accountID: doc['accountID'] as String?? null,
        businessProfileID: doc['businessProfileID'] as String?? null,
        eventCode: doc['eventCode'] as String?? '',
        userID: doc['userID'] as String?? '',
        bookingLink: doc['bookingLink'] as String?? '',
        facebookLink: doc['facebookLink'] as String?? '',
        linkedInLink: doc['linkedInLink'] as String?? '',
        otherLink: doc['otherLink'] as String?? '',
        creationDate: doc['creationDate'] as Timestamp?? Timestamp.now(),
        description: doc['description'] as String?? '',
        attendeeUserIDs: doc['attendeeUserIDs'] as List?? [],
        eventDateTimeFrom: doc['eventDateTimeFrom'] as Timestamp?? Timestamp.now(),
        eventDateTimeTo: doc['eventDateTimeTo'] as Timestamp?? Timestamp.now(),
        eventID: doc['eventID'] as String?? '',
        eventImages: doc['eventImages'] as List?? [''],
        eventTitle: doc['eventTitle'] as String?? '',
        eventType: doc['eventType'] as String?? '',
        capacity: doc['capacity'] as num?? 0,
        pricePerHead: doc['pricePerHead'] as num?? 0,
        publicEvent: doc['publicEvent'] as bool?? false,
        summary: doc['summary'] as String?? '',
        category: doc['category'] as String?? '',
        streetAddress: doc['streetAddress'] as String?? '',
        townCity: doc['townCity'] as String?? '',
        postCode: doc['postCode'] as String?? '',
        eventBriteEventID: doc['eventBriteEventID'] as String?? '',
        eventBriteOrgID: doc['eventBriteOrgID'] as String?? '',
        checkedInUserIDs: doc['checkedInUserIDs'] as List?? [],
        privacyPolicy: doc['privacyPolicy'] as bool?? true,
        tnc: doc['tnc'] as bool?? true,
        approved: doc['approved'] as bool?? false,
      );
    } catch (e) {
      print('****** EVENT MODEL ******');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'accountID': accountID!,
      'businessProfileID': businessProfileID!,
            'eventCode': eventCode!,
      'userID': userID!,
      'bookingLink': bookingLink!,
      'facebookLink': facebookLink!,
      'linkedInLink': linkedInLink!,
      'otherLink': otherLink!,
      'creationDate': creationDate!,
      'description': description!,
      'attendeeUserIDs': attendeeUserIDs!,
      'eventDateTimeFrom': eventDateTimeFrom!,
      'eventDateTimeTo': eventDateTimeTo!,
      'eventID': eventID!,
      'eventImages': eventImages!,
      'eventTitle': eventTitle!,
      'eventType': eventType!,
      'capacity': capacity!,
      'pricePerHead': pricePerHead!,
      'publicEvent': publicEvent!,
      'summary': summary!,
      'category': category!,
      'streetAddress': streetAddress!,
      'townCity': townCity!,
      'postCode': postCode!,
      'eventBriteEventID': eventBriteEventID!,
      'eventBriteOrgID': eventBriteOrgID!,
      'checkedInUserIDs': checkedInUserIDs!,
      'privacyPolicy': privacyPolicy!,
      'tnc': tnc!,
      'approved': approved!,
    };
  }
}
