class PostCode {
  final String? bid;
  final String? cty;
  final num? lat;
  final String? laua;
  final String? lep1;
  final num? long;
  final String? ward;

  PostCode({
    this.bid,
    this.cty,
    this.lat,
    this.laua,
    this.lep1,
    this.long,
    this.ward,
  });

  factory PostCode.fromDocument(Map<String, dynamic> doc) {
    try {
      return PostCode(
        bid: doc['bid'] as String?? '',
        cty: doc['cty'] as String?? '',
        lat: doc['lat'] as num?? 0,
        laua: doc['laua'] as String?? '',
        lep1: doc['lep1'] as String?? '',
        long: doc['long'] as num?? 0,
        ward: doc['ward'] as String?? '',
      );
    } catch (e) {
      print('****** POST CODE MODEL ******');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'bid': bid!,
      'cty': cty!,
      'lat': lat!,
      'laua': laua!,
      'lep1': lep1!,
      'long': long!,
      'ward': ward!,
    };
  }
}
