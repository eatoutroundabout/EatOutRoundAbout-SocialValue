import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessProfile {
  String? accountID;
  String? businessName;
  String? businessProfileID;
  Timestamp? creationDate;
  String? description;
  String? logo;
  String? summary;
  String? userID;
  String? streetAddress;
  String? townCity;
  String? postcode;
  String? localAuth;
  String? facebook;
  String? instagram;
  String? twitter;
  String? linkedIn;
  bool? privacyPolicy;
  bool? tnc;
  num? lm3ImpactValue;

  BusinessProfile({
    this.accountID,
    this.businessName,
    this.businessProfileID,
    this.creationDate,
    this.description,
    this.logo,
    this.summary,
    this.userID,
    this.streetAddress,
    this.townCity,
    this.postcode,
    this.localAuth,
    this.facebook,
    this.instagram,
    this.twitter,
    this.linkedIn,
    this.privacyPolicy,
    this.tnc,
    this.lm3ImpactValue,
  });

  factory BusinessProfile.fromDocument(Map<String, dynamic> doc) {
    return BusinessProfile(
      accountID: doc['accountID'] ?? '',
      businessName: doc['businessName'] ?? '',
      businessProfileID: doc['businessProfileID'] ?? '',
      creationDate: doc['creationDate'] ?? Timestamp.now(),
      description: doc['description'] ?? '',
      logo: doc['logo'] ?? '',
      summary: doc['summary'] ?? '',
      userID: doc['userID'] ?? '',
      streetAddress: doc['streetAddress'] ?? '',
      townCity: doc['townCity'] ?? '',
      postcode: doc['postcode'] ?? '',
      localAuth: doc['localAuth'] ?? '',
      facebook: doc['facebook'] ?? '',
      instagram: doc['instagram'] ?? '',
      twitter: doc['twitter'] ?? '',
      linkedIn: doc['linkedIn'] ?? '',
      privacyPolicy: doc['privacyPolicy'] ?? true,
      tnc: doc['tnc'] ?? true,
      lm3ImpactValue: doc['lm3ImpactValue'] ?? 0,
    );
    try {
      return BusinessProfile(
        accountID: doc['accountID'] as String?? '',
        businessName: doc['businessName'] as String?? '',
        businessProfileID: doc['businessProfileID'] as String?? '',
        creationDate: doc['creationDate'] as Timestamp?? Timestamp.now(),
        description: doc['description'] as String?? '',
        logo: doc['logo'] as String?? '',
        summary: doc['summary'] as String?? '',
        userID: doc['userID'] as String?? '',
        streetAddress: doc['streetAddress'] as String?? '',
        townCity: doc['townCity'] as String?? '',
        postcode: doc['postcode'] as String?? '',
        localAuth: doc['localAuth'] as String?? '',
        facebook: doc['facebook'] as String?? '',
        instagram: doc['instagram'] as String?? '',
        twitter: doc['twitter'] as String?? '',
        linkedIn: doc['linkedIn'] as String?? '',
        privacyPolicy: doc['privacyPolicy'] as bool?? true,
        tnc: doc['tnc'] as bool?? true,
        lm3ImpactValue: doc['lm3ImpactValue'] as num?? 0,
      );
    } catch (e) {
      print(e);
      return null!;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'accountID': accountID,
      'businessName': businessName,
      'businessProfileID': businessProfileID,
      'creationDate': creationDate,
      'description': description,
      'logo': logo,
      'summary': summary,
      'userID': userID,
      'streetAddress': streetAddress,
      'townCity': townCity,
      'postcode': postcode,
      'localAuth': localAuth,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'linkedIn': linkedIn,
      'privacyPolicy': privacyPolicy,
      'tnc': tnc,
      'lm3ImpactValue': lm3ImpactValue,
    };
  }
}
