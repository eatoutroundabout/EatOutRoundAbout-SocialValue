import 'package:cloud_firestore/cloud_firestore.dart';

class Supplier {
  final String? accountID;
  final String? accountPostcode;
  final String? buttonText;
  final String? productDescription;
  final String? productID;
  final String? productImage;
  final String? productName;
  final String? url;
  final Timestamp? createdDate;

  Supplier({
    this.accountID,
    this.accountPostcode,
    this.buttonText,
    this.productDescription,
    this.productID,
    this.productImage,
    this.productName,
    this.url,
    this.createdDate,
  });

  factory Supplier.fromDocument(Map<String, dynamic> doc) {
    try {
      return Supplier(
        accountID: doc['accountID'] as String?? '',
        accountPostcode: doc['accountPostcode'] as String?? '',
        buttonText: doc['buttonText'] as String?? '',
        productDescription: doc['productDescription'] as String?? '',
        productID: doc['productID'] as String?? '',
        productImage: doc['productImage'] as String?? '',
        productName: doc['productName'] as String?? '',
        url: doc['url'] as String?? '',
        createdDate: doc['createdDate'] as Timestamp?? Timestamp.now(),
      );
    } catch (e) {
      print('****** SUPPLIER MODEL ******');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'accountID': accountID!,
      'accountPostcode': accountPostcode!,
      'buttonText': buttonText!,
      'productDescription': productDescription!,
      'productID': productID!,
      'productImage': productImage!,
      'productName': productName!,
      'url': url!,
      'createdDate': createdDate!,
    };
  }
}
