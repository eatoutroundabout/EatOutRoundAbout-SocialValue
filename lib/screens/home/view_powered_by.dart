import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/screens/business/view_business_profile.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';

class ViewPoweredBy extends StatelessWidget {
  final List<BusinessProfile>? businessProfilesList;

  ViewPoweredBy({this.businessProfilesList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(
          title: Image.asset('assets/images/applogo.png',
              height: AppBar().preferredSize.height - 15),
          backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'POWERED BY'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(padding),
              itemBuilder: (context, i) {
                BusinessProfile businessProfile = businessProfilesList![i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ViewBusinessProfile(
                                    businessProfile: businessProfile)));
                  },
                  leading: CachedImage(url: businessProfile.logo, height: 50),
                  title: Text(businessProfile.businessName!,
                      maxLines: 1,
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined),
                );
              },
              itemCount: businessProfilesList!.length,
            ),
          ),
        ],
      ),
    );
  }
}
