import 'package:cloud_firestore/cloud_firestore.dart';

class UserVoucher {
  final String? userID;
  final String? voucherID;
  final bool? redeemed;
  final bool? redeemable;
  final Timestamp? claimedDate;
  final Timestamp? expiryDate;
  final Timestamp? redeemedDate;
  final String? voucherRedemptionCode;
  final String? voucherType;
  final String? voucherOrderID;
  final String? redeemedVenueUserID;
  final num? amount;
  final String? batchNo;
  final num? daysValid;
  final GeoPoint? claimedLocation;
  final GeoPoint? redeemedLocation;
  final String? lepRestricted;
  final String? localAuthRestricted;
  final String? wardRestricted;
  final String? venueRestricted;
  final String? bidRestricted;

  UserVoucher({
    this.userID,
    this.voucherID,
    this.redeemed,
    this.redeemable,
    this.claimedDate,
    this.expiryDate,
    this.redeemedDate,
    this.voucherRedemptionCode,
    this.voucherType,
    this.voucherOrderID,
    this.redeemedVenueUserID,
    this.amount,
    this.batchNo,
    this.daysValid,
    this.claimedLocation,
    this.redeemedLocation,
    this.lepRestricted,
    this.localAuthRestricted,
    this.wardRestricted,
    this.venueRestricted,
    this.bidRestricted,
  });

  factory UserVoucher.fromDocument(Map<String, dynamic> doc) {
    return UserVoucher(
      userID: doc['userID'] ?? '',
      voucherID: doc['voucherID'] ?? '',
      redeemed: doc['redeemed'] ?? false,
      redeemable: doc['redeemable'] ?? false,
      claimedDate: doc['claimedDate'] ?? null,
      expiryDate: doc['expiryDate'] ?? null,
      redeemedDate: doc['redeemedDate'] ?? null,
      voucherRedemptionCode: doc['voucherRedemptionCode'] ?? 'INVALID',
      voucherType: doc['voucherType'] ?? '',
      voucherOrderID: doc['voucherOrderID'] ?? '',
      redeemedVenueUserID: doc['redeemedVenueUserID'] ?? '',
      amount: doc['amount'] ?? 0,
      batchNo: doc['batchNo'] ?? '',
      daysValid: doc['daysValid'] ?? 0,
      claimedLocation: doc['claimedLocation'] ?? null,
      redeemedLocation: doc['redeemedLocation'] ?? null,
      lepRestricted: doc['lepRestricted'] ?? '',
      localAuthRestricted: doc['localAuthRestricted'] ?? '',
      wardRestricted: doc['wardRestricted'] ?? '',
      venueRestricted: doc['venueRestricted'] ?? '',
      bidRestricted: doc['bidRestricted'] ?? '',
    );
    try {
      return UserVoucher(
        userID: doc['userID'] as String?? '',
        voucherID: doc['voucherID'] as String?? '',
        redeemed: doc['redeemed'] as bool?? false,
        redeemable: doc['redeemable'] as bool?? false,
        claimedDate: doc['claimedDate'] as Timestamp?? null,
        expiryDate: doc['expiryDate'] as Timestamp?? null,
        redeemedDate: doc['redeemedDate'] as Timestamp?? null,
        voucherRedemptionCode: doc['voucherRedemptionCode'] as String?? 'INVALID',
        voucherType: doc['voucherType'] as String?? '',
        voucherOrderID: doc['voucherOrderID'] as String?? '',
        redeemedVenueUserID: doc['redeemedVenueUserID'] as String?? '',
        amount: doc['amount'] as num?? 0,
        batchNo: doc['batchNo'] as String?? '',
        daysValid: doc['daysValid'] as num?? 0,
        claimedLocation: doc['claimedLocation'] as GeoPoint?? null,
        redeemedLocation: doc['redeemedLocation'] as GeoPoint?? null,
        lepRestricted: doc['lepRestricted'] as String?? '',
        localAuthRestricted: doc['localAuthRestricted'] as String?? '',
        wardRestricted: doc['wardRestricted'] as String?? '',
        venueRestricted: doc['venueRestricted'] as String?? '',
        bidRestricted: doc['bidRestricted'] as String?? '',
      );
    } catch (e) {
      print('****** USER VOUCHERS MODEL ******');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'userID': userID!,
      'voucherID': voucherID!,
      'redeemed': redeemed!,
      'redeemable': redeemable!,
      'claimedDate': claimedDate!,
      'expiryDate': expiryDate!,
      'redeemedDate': redeemedDate!,
      'voucherRedemptionCode': voucherRedemptionCode!,
      'voucherType': voucherType!,
      'voucherOrderID': voucherOrderID!,
      'redeemedVenueUserID': redeemedVenueUserID!,
      'amount': amount!,
      'batchNo': batchNo!,
      'daysValid': daysValid!,
      'claimedLocation': claimedLocation!,
      'redeemedLocation': redeemedLocation!,
      'lepRestricted': lepRestricted!,
      'localAuthRestricted': localAuthRestricted!,
      'wardRestricted': wardRestricted!,
      'venueRestricted': venueRestricted!,
      'bidRestricted': bidRestricted!,
    };
  }
}
