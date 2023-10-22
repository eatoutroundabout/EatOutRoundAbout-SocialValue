import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/product_model.dart';
import 'package:eatoutroundabout/screens/business/view_business_profile.dart';
import 'package:eatoutroundabout/screens/messages/view_image.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewProduct extends StatelessWidget {
  final Product? product;

  ViewProduct({this.product});

  final firestoreService = Get.find<FirestoreService>();
  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: <Widget>[
          Heading(title: 'VIEW PRODUCT'),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: appBackground,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () => Get.to(() => ViewImages(images: [product!.promoImage], index: 0)),
                      child: SizedBox(height: Get.height * 0.25, child: CachedImage(url: product!.promoImage, height: Get.width)),
                    ),
                    SizedBox(height: 15),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product!.productName!, style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15),
                            Text('Category: ' + product!.category!),
                            Text('Created On: ' + DateFormat('dd MMM yyyy').format(product!.creationDate!.toDate()), textScaleFactor: 0.9, style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 15),
                            //if (product.businessName != '') Text('Sold by: ' + product.businessName),
                            if (product!.businessProfileID != '')
                              InkWell(
                                  onTap: () async {
                                    DocumentSnapshot doc = await firestoreService.getBusinessByBusinessID(product!.businessProfileID!);
                                    BusinessProfile businessProfile = doc.data() as BusinessProfile;
                                    Get.to(() => ViewBusinessProfile(businessProfile: businessProfile));
                                  },
                                  child: Text('View Business', textScaleFactor: 0.9, style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline))),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15),
                            Text(product!.description!),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                          height: MediaQuery.of(context).size.height * .35,
                          padding: const EdgeInsets.all(padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Product Gallery', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                              SizedBox(height: 15),
                              Expanded(
                                child: Swiper(
                                  //scrollDirection: Axis.vertical,
                                  loop: false,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                      onTap: () => Get.to(() => ViewImages(images: product!.images , index: i)),
                                      child: CachedImage(
                                        roundedCorners: true,
                                        height: Get.width,
                                        url: product!.images![i],
                                      ),
                                    );
                                  },
                                  itemCount: product!.images!.length,
                                  pagination: new SwiperPagination(builder: SwiperCustomPagination(builder: (BuildContext context, SwiperPluginConfig config) {
                                    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: DotSwiperPaginationBuilder(color: lightGreenColor, activeColor: primaryColor, size: 10.0, activeSize: 15.0).build(context, config));
                                  })),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        onTap: () => utilService.openLink(product!.website!),
                        leading: Icon(Icons.link, color: Colors.teal.shade400),
                        trailing: Icon(Icons.keyboard_arrow_right_rounded),
                        title: Text('Visit Website', textScaleFactor: 1, style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
