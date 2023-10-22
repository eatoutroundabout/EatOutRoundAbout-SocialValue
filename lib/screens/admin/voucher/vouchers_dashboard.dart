import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/voucher_model.dart';
import 'package:eatoutroundabout/screens/admin/voucher/add_voucher.dart';
import 'package:eatoutroundabout/screens/auth/section_splash.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/voucher_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class VouchersDashboard extends StatelessWidget {
  final BusinessProfile? businessProfile;

  VouchersDashboard({this.businessProfile});

  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'MY VOUCHERS'),
          Expanded(
            child: Container(
              color: appBackground,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: CustomButton(
                        color: greenColor,
                        text: 'Create a Voucher',
                        function: () => Get.to(
                          () => SectionSplash(
                            title: 'Purchase Vouchers',
                            description: 'Vouchers can be purchased and issued to your '
                                'staff, customers or donated to charity. When vouchers are redeemed it multiplies in the local economy!',
                            image: 'assets/images/retail.png',
                            function: () => Get.off(() => AddVoucher(businessProfile: businessProfile!)),
                          ),
                        ),
                      ),
                    ),
                    PaginateFirestore(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      isLive: true,
                      key: GlobalKey(),
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      itemBuilderType: PaginateBuilderType.listView,
                      itemBuilder: (context, documentSnapshot, i) {
                        Voucher voucher = documentSnapshot[i].data() as Voucher;
                        return VoucherTile(voucher: voucher);
                      },
                      query: firestoreService.getAccountVouchers(),
                      onEmpty: Padding(
                        padding: EdgeInsets.only(bottom: Get.height / 2 - 200, left: 25, right: 25),
                        child: Text('Vouchers can be purchased and issued to your staff, customers or donated to charity. When vouchers are redeemed it multiplies in the local economy!', textAlign: TextAlign.center, textScaleFactor: 1.15),
                      ),
                      itemsPerPage: 10,
                      bottomLoader: LoadingData(),
                      initialLoader: LoadingData(),
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
