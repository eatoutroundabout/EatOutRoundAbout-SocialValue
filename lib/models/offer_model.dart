import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  bool? success;
  String? message;
  List<Offer>? data;

  OfferModel({this.success, this.message, this.data});

  OfferModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? '';
    if (json['data'] != null) {
      data = <Offer>[];
      json['data'].forEach((v) {
        data!.add(new Offer.fromDocument(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Offer {
  String? businessProfileID;
  String? accountID;
  String? offerID;
  String? postCode;
  String? businessProfileLocalAuth;
  String? title;
  String? description;
  String? offering;
  String? promoImage;
  String? quote;
  String? type;
  String? website;
  Timestamp ?creationDate;
  bool? approved;

  Offer({
    this.businessProfileID,
    this.accountID,
    this.offerID,
    this.postCode,
    this.businessProfileLocalAuth,
    this.title,
    this.description,
    this.offering,
    this.promoImage,
    this.quote,
    this.type,
    this.website,
    this.creationDate,
    this.approved,
  });

  Offer.fromDocument(Map<String, dynamic> json) {
    businessProfileID = json['businessProfileID'] as String?? '';
    accountID = json['accountID'] as String?? '';
    offerID = json['offerID'] as String?? '';
    postCode = json['postCode'] as String?? '';
    businessProfileLocalAuth = json['businessProfileLocalAuth'] as String?? '';
    title = json['title'] as String?? '';
    description = json['description'] as String?? '';
    offering = json['offering'] as String?? '';
    promoImage = json['promoImage'] as String?? '';
    quote = json['quote'] as String?? '';
    type = json['type'] as String?? '';
    website = json['website'] as String?? '';
    creationDate = json['creationDate'] as Timestamp?? Timestamp.now();
    approved = json['approved'] as bool?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessProfileID'] = this.businessProfileID;
    data['accountID'] = this.accountID;
    data['offerID'] = this.offerID;
    data['postCode'] = this.postCode;
    data['businessProfileLocalAuth'] = this.businessProfileLocalAuth;
    data['title'] = this.title;
    data['description'] = this.description;
    data['offering'] = this.offering;
    data['promoImage'] = this.promoImage;
    data['quote'] = this.quote;
    data['type'] = this.type;
    data['website'] = this.website;
    data['creationDate'] = this.creationDate;
    data['approved'] = this.approved;
    return data;
  }
}
