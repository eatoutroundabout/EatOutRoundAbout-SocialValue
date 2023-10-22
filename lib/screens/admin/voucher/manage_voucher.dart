import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/voucher_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/voucher_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/utils/constants.dart';

class ManageVoucher extends StatefulWidget {

  @override
  State<ManageVoucher> createState() => _ManageVoucherState();
}

class _ManageVoucherState extends State<ManageVoucher> {
  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();

  String businessProfileName = 'Business Profile Name';
  List<DropdownMenuItem<String>> dropdownMenuItems = [
    DropdownMenuItem<String>(
        child: Text('Business Profile Name',
            textScaleFactor: 1,
            style: TextStyle(color: Colors.black)
        ),
        value: 'Business Profile Name'
    )
  ];

  @override
  void initState() {
    print("ACCOUNT ID : ");
    print(userController.currentUser.value.accountID);
    fetchBusinessProfiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'MANAGE VOUCHERS', textScaleFactor: 1.75),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(width: 2, color: Colors.teal.shade400),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20)
                    ),
                    isExpanded: true,
                    style: TextStyle(color: primaryColor, fontSize: 18),
                    value: businessProfileName,
                    items: dropdownMenuItems,
                    onChanged: (value) => {},
                  ),
                  SizedBox(height: 15),
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
        ],
      ),
    );
  }

  void fetchBusinessProfiles() {
    userController.currentUser.value.businessProfileAdmin!.forEach((businessProfileAdminID) async {
      DocumentSnapshot<BusinessProfile> profileSnapshot = await firestoreService.getBusinessByBusinessID(businessProfileAdminID);
      if(profileSnapshot.exists) {
        BusinessProfile? businessProfile = profileSnapshot.data();
        print("#######");
        print(businessProfile!.businessName);
        dropdownMenuItems.add(
            DropdownMenuItem<String>(
                child: Text(
                    businessProfile.businessName!,
                    textScaleFactor: 1,
                    style: TextStyle(color: Colors.black)
                ),
                value: businessProfile.businessName
            )
        );
      }
    });
  }
}
