import 'package:cloud_firestore/cloud_firestore.dart';

class VoucherCampaign {
  final String? accountID;
  final String? bidRestricted;
  final Timestamp? campaignEnd;
  final Timestamp? campaignCreationDate;
  final String? campaignID;
  final String? campaignName;
  final Timestamp? campaignStart;
  final String? displayMessage;
  final bool? isMarketing;
  final bool? isPersonalised;
  final String? lepRestricted;
  final String? localAuthRestricted;
  final num? noVouchers;
  final String? userID;
  final String? voucherDesign;
  final String? voucherID;
  final String? voucherSubType;
  final String? voucherType;
  final String? offerDescription;
  final String? offerLink;
  final String? offerLinkText;
  final String? offerTitle;
  final String? wardRestricted;
  final String? venueRestricted;
  final bool? claimVoucherButton;
  final String? logoURL;
  final String? coverURL;

  VoucherCampaign({
    this.accountID,
    this.bidRestricted,
    this.campaignEnd,
    this.campaignCreationDate,
    this.campaignID,
    this.campaignName,
    this.campaignStart,
    this.displayMessage,
    this.isMarketing,
    this.isPersonalised,
    this.lepRestricted,
    this.localAuthRestricted,
    this.noVouchers,
    this.userID,
    this.voucherDesign,
    this.voucherID,
    this.voucherSubType,
    this.voucherType,
    this.offerDescription,
    this.offerLink,
    this.offerLinkText,
    this.offerTitle,
    this.wardRestricted,
    this.venueRestricted,
    this.claimVoucherButton,
    this.logoURL,
    this.coverURL,
  });

  factory VoucherCampaign.fromDocument(Map<String, dynamic> doc) {
    try {
      return VoucherCampaign(
        accountID: doc['accountID'] as String??'',
        bidRestricted: doc['bidRestricted'] as String?? '',
        campaignEnd: doc['campaignEnd'] as Timestamp?? null,
        campaignCreationDate: doc['campaignCreationDate'] as Timestamp?? null,
        campaignID: doc['campaignID'] as String?? '',
        campaignName: doc['campaignName'] as String?? '',
        campaignStart: doc['campaignStart'] as Timestamp?? null,
        displayMessage: doc['displayMessage'] as String?? '',
        isMarketing: doc['isMarketing'] as bool?? false,
        isPersonalised: doc['isPersonalised'] as bool?? false,
        lepRestricted: doc['lepRestricted'] as String?? '',
        localAuthRestricted: doc['localAuthRestricted'] as String?? '',
        noVouchers: doc['noVouchers'] as num?? 0,
        userID: doc['userID'] as String?? '',
        voucherDesign: doc['voucherDesign'] as String?? '',
        voucherID: doc['voucherID'] as String?? '',
        voucherSubType: doc['voucherSubType'] as String?? '',
        voucherType: doc['voucherType'] as String?? '',
        offerDescription: doc['offerDescription'] as String?? '',
        offerLink: doc['offerLink'] as String?? '',
        offerLinkText: doc['offerLinkText'] as String?? '',
        offerTitle: doc['offerTitle'] as String?? '',
        wardRestricted: doc['wardRestricted'] as String?? '',
        venueRestricted: doc['venueRestricted'] as String?? '',
        claimVoucherButton: doc['claimVoucherButton'] as bool?? false,
        logoURL: doc['logoURL'] as String?? '',
        coverURL: doc['coverURL'] as String?? '',
      );
    } catch (e) {
      print('****** VOUCHER CAMPAIGNS MODEL ******');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'accountID': accountID!,
      'bidRestricted': bidRestricted!,
      'campaignEnd': campaignEnd!,
      'campaignCreationDate': campaignCreationDate!,
      'campaignID': campaignID!,
      'campaignName': campaignName!,
      'campaignStart': campaignStart!,
      'displayMessage': displayMessage!,
      'isMarketing': isMarketing!,
      'isPersonalised': isPersonalised!,
      'lepRestricted': lepRestricted!,
      'localAuthRestricted': localAuthRestricted!,
      'noVouchers': noVouchers!,
      'userID': userID!,
      'voucherDesign': voucherDesign!,
      'voucherID': voucherID!,
      'voucherSubType': voucherSubType!,
      'voucherType': voucherType!,
      'offerDescription': offerDescription!,
      'offerLink': offerLink!,
      'offerLinkText': offerLinkText!,
      'offerTitle': offerTitle!,
      'wardRestricted': wardRestricted!,
      'venueRestricted': venueRestricted!,
      'claimVoucherButton': claimVoucherButton!,
      'logoURL': logoURL!,
      'coverURL': coverURL!,
    };
  }
}

/* VOUCHER DATA FOR QR CODE
{
"campaignID" : "Thanks",
"isPersonalised" : "https://cdn.logo.com/hotlink-ok/logo-social-sq.png",
"localAuthRestricted" : "free",
"noVouchers" : "marketing",
"noVouchers" : "marketing",
"campaignStart":"New Year",
"displayMessage": "123",
"validFromDate": "20210102",
"validToDate": "20210202",
"transactionID": "ABC123",
"lepRestricted": "ABCDEF"
}

 */
