import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  final bool? accountApproved;
  final String? accountID;
  final String? accountName;
  final String? bankName;
  final String? accountNo;
  final String? accountSortCode;
  final String? accountType;
  final String? companyRegNo;
  final String? email;
  final bool? isVenueAccount;
  final bool? isPartner;
  final num? noEmployees;
  final String? postcode;
  final String? streetAddress;
  final String? telephone;
  final String? townCity;
  final String? businessType;
  final String? sex;
  final String? sexAtBirth;
  final String? age;
  final String? ethnicity;
  final String? disabled;
  final String? employed;
  final String? membership;
  final bool? isBusinessUnder3Years;
  final bool? isCharity;
  final String? businessStartDate;
  final Timestamp? membershipExpiryDate;
  Timestamp? eventExpiryDate;
  Timestamp? productExpiryDate;
  Timestamp? offerExpiryDate;
  final Timestamp? creationDate;

  Account({
    this.accountApproved,
    this.accountID,
    this.accountName,
    this.bankName,
    this.accountNo,
    this.accountSortCode,
    this.accountType,
    this.companyRegNo,
    this.email,
    this.isVenueAccount,
    this.isPartner,
    this.noEmployees,
    this.postcode,
    this.streetAddress,
    this.telephone,
    this.townCity,
    this.businessType,
    this.sex,
    this.sexAtBirth,
    this.age,
    this.ethnicity,
    this.disabled,
    this.employed,
    this.membership,
    this.isBusinessUnder3Years,
    this.isCharity,
    this.businessStartDate,
    this.membershipExpiryDate,
    this.eventExpiryDate,
    this.productExpiryDate,
    this.offerExpiryDate,
    this.creationDate,
  });

  factory Account.fromDocument(Map<String, dynamic> doc) {
    return Account(
      accountApproved: doc['accountApproved']  ?? false,
      accountID: doc['accountID']  ?? '',
      accountName: doc['accountName']  ?? '',
      bankName: doc['bankName'] ??'',
      accountNo: doc['accountNo'] ??'',
      accountSortCode: doc['accountSortCode']??'' ,
      accountType: doc['accountType']??null,
      companyRegNo: doc['companyRegNo']??'',
      email: doc['email']??'',
      isVenueAccount: doc['isVenueAccount']  ?? true,
      isPartner: doc['isPartner'] ?? false,
      noEmployees: doc['noEmployees']as num,
      postcode: doc['postcode']??'',
      streetAddress: doc['streetAddress']??'',
      telephone: doc['telephone']??'',
      townCity: doc['townCity']??'',
      businessType: doc['businessType']??'',
      sex: doc['sex'] ?? 'Select',
      sexAtBirth: doc['sexAtBirth'] ?? 'Select',
      age: doc['age'] ?? 'Select',
      ethnicity: doc['ethnicity'] ?? 'Select',
      disabled: doc['disabled'] ?? 'Select',
      employed: doc['employed'] ?? 'Select',
      membership: doc['membership']??'',
      isBusinessUnder3Years: doc['isBusinessUnder3Years']??false,
      isCharity: doc['isCharity']??false,
      businessStartDate: doc['businessStartDate']??'',
      creationDate: doc['creationDate'] ?? Timestamp.fromDate(DateTime(2021, 1, 1)),
      membershipExpiryDate: doc['membershipExpiryDate']  ?? doc['creationDate'] ?? Timestamp.fromDate(DateTime(2021, 1, 1)),
      eventExpiryDate: doc['eventExpiryDate'] ?? doc['creationDate'] ?? Timestamp.fromDate(DateTime(2021, 1, 1)),
      productExpiryDate: doc['productExpiryDate'] ?? doc['creationDate'] ?? Timestamp.fromDate(DateTime(2021, 1, 1)),
      offerExpiryDate: doc['offerExpiryDate'] ?? doc['creationDate'] ?? Timestamp.fromDate(DateTime(2021, 1, 1)),
    );
    /*try {
      return Account(
        accountApproved: doc['accountApproved'] as bool ?? false,
        accountID: doc['accountID'] as String ?? '',
        accountName: doc['accountName'] as String ?? '',
        bankName: doc['bankName'] as String,
        accountNo: doc['accountNo'] as String,
        accountSortCode: doc['accountSortCode'] as String,
        accountType: doc['accountType']as String,
        companyRegNo: doc['companyRegNo']as String,
        email: doc['email']as String,
        isVenueAccount: doc['isVenueAccount'] as bool ?? true,
        isPartner: doc['isPartner'] as bool?? false,
        noEmployees: doc['noEmployees']as num,
        postcode: doc['postcode']as String,
        streetAddress: doc['streetAddress']as String,
        telephone: doc['telephone']as String,
        townCity: doc['townCity']as String,
        businessType: doc['businessType']as String,
        sex: doc['sex']as String ?? 'Select',
        sexAtBirth: doc['sexAtBirth']as String ?? 'Select',
        age: doc['age']as String ?? 'Select',
        ethnicity: doc['ethnicity']as String ?? 'Select',
        disabled: doc['disabled']as String ?? 'Select',
        employed: doc['employed']as String ?? 'Select',
        membership: doc['membership']as String,
        isBusinessUnder3Years: doc['isBusinessUnder3Years']as bool,
        isCharity: doc['isCharity']as bool,
        businessStartDate: doc['businessStartDate']as String,
        creationDate: doc['creationDate']as Timestamp ?? Timestamp.fromDate(DateTime(2021, 1, 1)),
        membershipExpiryDate: doc['membershipExpiryDate'] as Timestamp ?? doc['creationDate']as Timestamp ?? Timestamp.fromDate(DateTime(2021, 1, 1)),
        eventExpiryDate: doc['eventExpiryDate'] as Timestamp?? doc['creationDate']as Timestamp ?? Timestamp.fromDate(DateTime(2021, 1, 1)),
        productExpiryDate: doc['productExpiryDate'] as Timestamp?? doc['creationDate']as Timestamp ?? Timestamp.fromDate(DateTime(2021, 1, 1)),
        offerExpiryDate: doc['offerExpiryDate'] as Timestamp?? doc['creationDate']as Timestamp ?? Timestamp.fromDate(DateTime(2021, 1, 1)),
      );
    } catch (e) {
      print('########## ACCOUNT MODEL ###########');
      print(e);
      return e.toString() ;
    }*/
  }

  Map<String, Object> toJson() {
    return {
      'accountApproved': accountApproved!,
      'accountID': accountID!,
      'accountName': accountName!,
      'bankName': bankName!,
      'accountNo': accountNo!,
      'accountSortCode': accountSortCode!,
      'accountType': accountType!,
      'companyRegNo': companyRegNo!,
      'email': email!,
      'isVenueAccount': isVenueAccount!,
      'isPartner': isPartner!,
      'noEmployees': noEmployees!,
      'postcode': postcode!,
      'streetAddress': streetAddress!,
      'telephone': telephone!,
      'townCity': townCity!,
      'businessType': businessType!,
      'sex': sex!,
      'sexAtBirth': sexAtBirth!,
      'age': age!,
      'ethnicity': ethnicity!,
      'disabled': disabled!,
      'employed': employed!,
      'membership': membership!,
      'isBusinessUnder3Years': isBusinessUnder3Years!,
      'isCharity': isCharity!,
      'businessStartDate': businessStartDate!,
      'membershipExpiryDate': membershipExpiryDate!,
      'eventExpiryDate': eventExpiryDate!,
      'productExpiryDate': productExpiryDate!,
      'offerExpiryDate': offerExpiryDate!,
      'creationDate': creationDate!,
    };
  }
}
