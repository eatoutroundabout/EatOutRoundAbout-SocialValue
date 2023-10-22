import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/product_model.dart';
import 'package:eatoutroundabout/screens/admin/product/add_product.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ProductDashboard extends StatelessWidget {
  final BusinessProfile? businessProfile;

  ProductDashboard({this.businessProfile});

  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Image.asset('assets/images/applogo.png',
              height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'MY PRODUCTS'),
          Expanded(
            child: Container(
              color: appBackground,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: CustomButton(
                        color: redColor,
                        text: 'Add a new Product',
                        function: () => Get.to(
                            () => AddProduct(businessProfile: businessProfile)),
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
                        Product product = documentSnapshot[i].data() as Product;
                        return ProductItem(product: product, isMyProduct: true);
                      },
                      query: firestoreService
                          .getMyProducts(businessProfile!.businessProfileID!),
                      onEmpty: Padding(
                        padding: EdgeInsets.only(
                            bottom: Get.height / 2 - 200, left: 25, right: 25),
                        child: Text(
                          'Make or sell local food, drink or produce for hospitality? \n\nUpload your products to Eat Out Round About and we’ll reward hospitality venues for purchasing from you by boosting their position on the app.',
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.15,
                        ),
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
