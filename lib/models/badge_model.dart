class Badge {
  final num? amountContributed;
  final num? amountSaved;
  final num? bidVisits;
  final num? charityVisits;
  final num? cultureVisits;
  final num? familyVisits;
  final num? highStreetVisits;
  final num? localTouristVisits;
  final num? loyalVenueVisits;
  final num? ratedApp;
  final num? sharedApp;
  final num? ratedVenuesCount;
  final num? remoteTouristVisits;
  final num? sportVisits;
  final String? userID;
  final num? vouchersClaimed;
  final num? vouchersRedeemed;
  final num? workVenueVisit;
  final num? impactLm1;
  final num? impactLm2;
  final num? impactLm3;
  final num? jobsHelped;
  final num? independent;
  final num? localImpact;

  Badge({
    this.amountContributed,
    this.amountSaved,
    this.bidVisits,
    this.charityVisits,
    this.cultureVisits,
    this.familyVisits,
    this.highStreetVisits,
    this.localTouristVisits,
    this.loyalVenueVisits,
    this.ratedApp,
    this.sharedApp,
    this.ratedVenuesCount,
    this.remoteTouristVisits,
    this.sportVisits,
    this.userID,
    this.vouchersClaimed,
    this.vouchersRedeemed,
    this.workVenueVisit,
    this.impactLm1,
    this.impactLm2,
    this.impactLm3,
    this.jobsHelped,
    this.independent,
    this.localImpact,
  });

  factory Badge.fromDocument(Map<String, dynamic> doc) {
    try {
      return Badge(
        amountContributed: doc['amountContributed']  ?? 0,
        amountSaved: doc['amountSaved'] ?? 0,
        bidVisits: doc['bidVisits'] ?? 0,
        charityVisits: doc['charityVisits'] ?? 0,
        cultureVisits: doc['cultureVisits'] ?? 0,
        familyVisits: doc['familyVisits'] ?? 0,
        highStreetVisits: doc['highStreetVisits'] ?? 0,
        localTouristVisits: doc['localTouristVisits'] ?? 0,
        loyalVenueVisits: doc['loyalVenueVisits'] ?? 0,
        ratedApp: doc['ratedApp'] ?? 0,
        sharedApp: doc['sharedApp'] ?? 0,
        ratedVenuesCount: doc['ratedVenuesCount'] ?? 0,
        remoteTouristVisits: doc['remoteTouristVisits'] ?? 0,
        sportVisits: doc['sportVisits'] ?? 0,
        userID: doc['userID'] ?? '',
        vouchersClaimed: doc['vouchersClaimed'] ?? 0,
        vouchersRedeemed: doc['vouchersRedeemed'] ?? 0,
        workVenueVisit: doc['workVenueVisit'] ?? 0,
        impactLm1: doc['impactLm1'] ?? 0,
        impactLm2: doc['impactLm2'] ?? 0,
        impactLm3: doc['impactLm3'] ?? 0,
        jobsHelped: doc['jobsHelped'] ?? 0,
        independent: doc['independent'] ?? 0,
        localImpact: doc['localImpact'] ?? 0,
      );
    } catch (e) {
      print('****** BADGE MODEL ******');
      print(e);
      return e.toString() as Badge;
    }
  }

  Map<String, Object> toJson() {
    return {
      'amountContributed': amountContributed!,
      'amountSaved': amountSaved!,
      'bidVisits': bidVisits!,
      'charityVisits': charityVisits!,
      'cultureVisits': cultureVisits!,
      'familyVisits': familyVisits!,
      'highStreetVisits': highStreetVisits!,
      'localTouristVisits': localTouristVisits!,
      'loyalVenueVisits': loyalVenueVisits!,
      'ratedApp': ratedApp!,
      'sharedApp': sharedApp!,
      'ratedVenuesCount': ratedVenuesCount!,
      'remoteTouristVisits': remoteTouristVisits!,
      'sportVisits': sportVisits!,
      'userID': userID!,
      'vouchersClaimed': vouchersClaimed!,
      'vouchersRedeemed': vouchersRedeemed!,
      'workVenueVisit': workVenueVisit!,
      'impactLm1': impactLm1!,
      'impactLm2': impactLm2!,
      'impactLm3': impactLm3!,
      'jobsHelped': jobsHelped!,
      'independent': independent!,
      'localImpact': localImpact!,
    };
  }
}
