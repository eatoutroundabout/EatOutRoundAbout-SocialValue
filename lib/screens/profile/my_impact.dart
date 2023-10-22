import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/badge_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/utils/preferences.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:get/get.dart';

class MyImpact extends StatefulWidget {
  @override
  State<MyImpact> createState() => _MyImpactState();
}

class _MyImpactState extends State<MyImpact> {
  final List badgeTitles = [
    '£500 Contributed',
    '£500 Saved',
    '15 Bid Visits',
    '10 Charity Visits',
    '10 Culture Visits',
    '50 Family Visits',
    'First Voucher Claim',
    '25 High Street Visits',
    '25 Local Tourist Visits',
    '25 Loyal Venue Visits',
    'Rated 10 Venues',
    '50 Remote Tourist Visits',
    'Shared App',
    '10 Sport Visits',
    '25 Vouchers Claimed',
    '25 Vouchers Redeemed',
    '50 Work Venue Visits',
    '25 independent circle',
    '100 local jobs helped',
    '10  high local impact venue visits',
  ];

  final List badgeDescription = [
    'Every £ you spend in the local economy circulates and multiplies.',
    'You save money each time you redeem a voucher and help the local economy',
    'Businesses club together to make a BID area a great place to live, work and do business. Your support dining in these areas supports the cause.',
    'Charities and social enterprises make a difference for social causes. Every £ here means you made a bigger social impact. ',
    'Where there is culture there are thriving places. By supporting cultural locations you are helping build better perceptions of the place. ',
    'Family time is important for local communities. Supporting family friendly circle helps children to have great spaces to develop confide, learn and grow. ',
    'Congratulations. You took the first step to helping your local economy. ',
    'The purpose of the high street has changed over recent years and is grateful  for your support as it redefines itself.',
    'Most people do not actively think to spend  leisure time in the place they live to boost the local economy.  Being local from time to time makes a huge difference to the local economy and is good for the environment! ',
    'Local circle value your custom and repeat custom is their lifeblood.',
    'Thanks for helping others to make great choices in where they dine out and boost the economy. ',
    'Visiting places from outside the area where you helps to take new money into that area. ',
    'We appreciate you helping to spread the word.',
    'Sport plays a vital role in contribution to local economies and community. ',
    'Each voucher claim brings at least £5 into circulation in the local economy!',
    'Each time you redeem a voucher the contribution into the local economy multiplies!',
    'Spending money in the place where you work means that money earned in the local area can recirculate and grow. When everyone plays their part they can create a thriving work location.',
    'Independent circle help to build wealth in local economies and keep money spent locally in circulation locally.',
    'The pandemic has created challenges for circle and thanks to your contribution you have helped to save local jobs',
    'Supporting venues with high local impact means you are helping to keep money in circulation inside the local economy.  High impact venues are those which source locally or invest back into the local economy.',
  ];

  final List badgeImages = [
    'assets/images/contribution.png',
    'assets/images/saved.png',
    'assets/images/bid.png',
    'assets/images/charity.png',
    'assets/images/culture.png',
    'assets/images/family.png',
    'assets/images/first_time.png',
    'assets/images/high_street.png',
    'assets/images/local_tourist.png',
    'assets/images/loyalty.png',
    'assets/images/rated_venue.png',
    'assets/images/tourist.png',
    'assets/images/share.png',
    'assets/images/sport.png',
    'assets/images/claimed.png',
    'assets/images/redeemed.png',
    'assets/images/work.png',
    'assets/images/independent.png',
    'assets/images/jobs.png',
    'assets/images/impact.png',
  ];

  final List requiredCounts = [
    500,
    500,
    15,
    10,
    10,
    50,
    1,
    25,
    25,
    25,
    10,
    50,
    1,
    10,
    25,
    25,
    50,
    25,
    100,
    10,
  ];

  final firestoreService = Get.find<FirestoreService>();
  bool showTipsDialog = false;

  @override
  void initState() {
    super.initState();
  }

  getData() async {
    showTipsDialog = await Preferences.getTipsPopupUser();
    if (showTipsDialog) showCustomDialog();
  }

  showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding / 2)),
          title: Text('Send Tips'),
          content: Text('Would you like to receive tips and ideas to help your local economy from Eat Out Round About?'),
          actions: [
            TextButton(
                onPressed: () async {
                  final firestoreService = Get.find<FirestoreService>();
                  Get.back();
                  await Preferences.setTipsPopupUser(false);
                  await firestoreService.updateUser({
                    'showTips': true,
                  });
                },
                child: Text('YES')),
            TextButton(
                onPressed: () async {
                  final firestoreService = Get.find<FirestoreService>();
                  Get.back();
                  await Preferences.setTipsPopupUser(false);
                  await firestoreService.updateUser({
                    'showTips': false,
                  });
                },
                child: Text('NO')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Container(
        color: primaryColor,
        child: Column(
          children: [
            Heading(title: 'MY IMPACT'),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: firestoreService.getBadgesCounts(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot<Badge>> snapshot) {
                      if (snapshot.hasData) {
                        Badge? badge;
                        if (snapshot.data!.exists)
                          badge = snapshot.data!.data();
                        else
                          badge = Badge(amountContributed: 0, amountSaved: 0, bidVisits: 0, charityVisits: 0, cultureVisits: 0, familyVisits: 0, highStreetVisits: 0, localTouristVisits: 0, loyalVenueVisits: 0, ratedApp: 0, ratedVenuesCount: 0, remoteTouristVisits: 0, sportVisits: 0, vouchersClaimed: 0, vouchersRedeemed: 0, sharedApp: 0, workVenueVisit: 0, impactLm1: 0, impactLm2: 0, impactLm3: 0);
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 25),
                              height: MediaQuery.of(context).size.height * 0.65,
                              padding: const EdgeInsets.all(padding),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: CircleAvatar(
                                      radius: MediaQuery.of(context).size.width * 0.22,
                                      backgroundColor: orangeColor,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('You have \nbrought', textScaleFactor: 1, textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Text('£${badge!.impactLm1}', textAlign: TextAlign.center, textScaleFactor: 2, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                          ),
                                          Text('into local \ncirculation', textScaleFactor: 1, textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: redCircle(badge, context),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: greenCircle(badge, context),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 125, top: 0),
                                          child: Image.asset('assets/images/arrow_left.png', height: AppBar().preferredSize.height - 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 125, top: 100),
                                          child: Image.asset('assets/images/arrow_right.png', height: AppBar().preferredSize.height - 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Text('My Badges', textAlign: TextAlign.center, textScaleFactor: 2, style: TextStyle(color: Colors.white)),
                            // ListView.builder(
                            //   physics: NeverScrollableScrollPhysics(),
                            //   shrinkWrap: true,
                            //   padding: const EdgeInsets.symmetric(vertical: 20),
                            //   itemBuilder: (context, i) {
                            //     return buildBadgeRow(i, badge);
                            //   },
                            //   itemCount: badgeTitles.length,
                            // ),
                          ],
                        );
                      } else
                        return LoadingData();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  redCircle(Badge badge, context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.45,
      width: MediaQuery.of(context).size.width * 0.45,
      margin: const EdgeInsets.only(top: 50),
      alignment: Alignment.centerRight,
      child: Stack(
        children: [
          Center(child: ArcText(radius: 85, text: '       Each £ spent locally is', textStyle: TextStyle(color: Colors.white), startAngle: -196, startAngleAlignment: StartAngleAlignment.start, placement: Placement.outside, direction: Direction.clockwise)),
          Center(
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.18,
              backgroundColor: redColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('multiplied by', textScaleFactor: 1, textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(badge.impactLm1 != 0 ? '${(badge.impactLm2! / badge.impactLm1!).toStringAsFixed(1)}x' : '0x', textAlign: TextAlign.center, textScaleFactor: 2, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Text('£${badge.impactLm2!.toStringAsFixed(1)}', textScaleFactor: 1, textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  greenCircle(Badge badge, context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.45,
      width: MediaQuery.of(context).size.width * 0.45,
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: [
          Center(child: ArcText(radius: 85, text: '   Hospitality multiplied each', textStyle: TextStyle(color: Colors.white), startAngle: -196, startAngleAlignment: StartAngleAlignment.start, placement: Placement.outside, direction: Direction.clockwise)),
          Center(
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.18,
              backgroundColor: greenColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('£ locally by', textScaleFactor: 1, textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(badge.impactLm1 != 0 ? '${(badge.impactLm3! / badge.impactLm2!).toStringAsFixed(1)}x' : '0x', textAlign: TextAlign.center, textScaleFactor: 2, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Text('£${badge.impactLm3!.toStringAsFixed(1)}', textScaleFactor: 1, textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildBadgeRow(int i, Badge badge) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            foregroundDecoration: BoxDecoration(
              color: getTotal(i, badge) < requiredCounts[i] ? Colors.grey : Colors.transparent,
              backgroundBlendMode: BlendMode.saturation,
            ),
            child: Image.asset(
              badgeImages[i],
              width: 75,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(badgeTitles[i], textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(badgeDescription[i], style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                    backgroundColor: Colors.grey.shade300,
                    value: getTotal(i, badge) / requiredCounts[i],
                  ),
                ),
                Text(getTotal(i, badge) >= requiredCounts[i] ? 'Badge Unlocked' : '${(requiredCounts[i] - getTotal(i, badge))}  more to go', style: TextStyle(fontStyle: FontStyle.italic, color: greenColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getTotal(int i, Badge badge) {
    switch (i) {
      case 0:
        return badge.amountContributed;
      case 1:
        return badge.amountSaved;
      case 2:
        return badge.bidVisits;
      case 3:
        return badge.charityVisits;
      case 4:
        return badge.cultureVisits;
      case 5:
        return badge.familyVisits;
      case 6:
        return badge.vouchersClaimed;
      case 7:
        return badge.highStreetVisits;
      case 8:
        return badge.localTouristVisits;
      case 9:
        return badge.loyalVenueVisits;
      case 10:
        return badge.ratedVenuesCount;
      case 11:
        return badge.remoteTouristVisits;
      case 12:
        return badge.sharedApp;
      case 13:
        return badge.sportVisits;
      case 14:
        return badge.vouchersClaimed;
      case 15:
        return badge.vouchersRedeemed;
      case 16:
        return badge.workVenueVisit;
      case 17:
        return badge.independent;
      case 18:
        return badge.jobsHelped;
      case 19:
        return badge.localImpact;
    }
  }
}
