class DiscountCode {
  final bool? active;
  final num? discount;
  final String? discountCode;
  final String? referrerName;

  DiscountCode({
    this.active,
    this.discount,
    this.discountCode,
    this.referrerName,
  });

  factory DiscountCode.fromDocument(Map<String, dynamic> doc) {
    try {
      return DiscountCode(
        active: doc['active'] as bool ?? false,
        discount: doc['discount'] as num?? 0,
        discountCode: doc['discountCode'] as String ?? '',
        referrerName: doc['referrerName'] as String?? '',
      );
    } catch (e) {
      print('****** DISCOUNT CODE MODEL ******');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'active': active!,
      'discount': discount!,
      'discountCode': discountCode!,
      'referrerName': referrerName!,
    };
  }
}
