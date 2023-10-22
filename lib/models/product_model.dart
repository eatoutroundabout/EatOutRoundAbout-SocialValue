import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String? userID;
  final String? accountID;
  final String? businessProfileID;
  final Timestamp? creationDate;
  final String? category;
  final String? description;
  final List? images;
  final num? price;
  final String? productID;
  final String? productName;
  final String? promoImage;
  final String? website;
  List? venues;
  final String? businessProfileLocalAuth;
  bool? privacyPolicy;
  bool? tnc;
  bool? approved;

  Product({
    this.userID,
    this.accountID,
    this.businessProfileID,
    this.creationDate,
    this.category,
    this.description,
    this.images,
    this.price,
    this.productID,
    this.productName,
    this.promoImage,
    this.website,
    this.venues,
    this.businessProfileLocalAuth,
    this.privacyPolicy,
    this.tnc,
    this.approved,
  });

  factory Product.fromDocument(Map<String, dynamic> doc) {
    try {
      return Product(
        userID: doc['userID'] as String ?? '',
        accountID: doc['accountID'] as String?? '',
        businessProfileID: doc['businessProfileID'] as String?? '',
        creationDate: doc['creationDate'] as Timestamp?? Timestamp.now(),
        category: doc['category'] as String?? '',
        description: doc['description'] as String?? '',
        images: doc['images'] as List?? [],
        price: doc['cost'] as num?? 0,
        productID: doc['productID'] as String?? '',
        productName: doc['productName'] as String?? '',
        promoImage: doc['promoImage'] as String?? '',
        website: doc['website'] as String?? '',
        venues: doc['venues'] as List?? [],
        businessProfileLocalAuth: doc['businessProfileLocalAuth'] as String?? '',
        privacyPolicy: doc['privacyPolicy'] as bool?? true,
        tnc: doc['tnc'] as bool?? true,
        approved: doc['approved']as bool ?? false,
      );
    } catch (e) {
      print('****** PRODUCT MODEL ******');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'userID': userID!,
      'accountID': accountID!,
      'businessProfileID': businessProfileID!,
      'creationDate': creationDate!,
      'category': category!,
      'description': description!,
      'images': images!,
      'cost': price!,
      'productID': productID!,
      'productName': productName!,
      'promoImage': promoImage!,
      'website': website!,
      'venues': venues!,
      'businessProfileLocalAuth': businessProfileLocalAuth!,
      'privacyPolicy': privacyPolicy!,
      'tnc': tnc!,
      'approved': approved!,
    };
  }
}
