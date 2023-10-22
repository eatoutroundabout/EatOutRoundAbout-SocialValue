import 'package:eatoutroundabout/models/supplier_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class FindSuppliers extends StatefulWidget {
  @override
  _FindSuppliersState createState() => _FindSuppliersState();
}

class _FindSuppliersState extends State<FindSuppliers> {
  final accountService = Get.find<FirestoreService>();
  final utilService = Get.find<UtilService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: <Widget>[
          Heading(title: 'LOCAL SUPPLIERS'),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: orangeColor,
              child: findVouchers(),
            ),
          ),
        ],
      ),
    );
  }

  findVouchers() {
    return PaginateFirestore(
      itemBuilderType: PaginateBuilderType.listView,
      itemBuilder: (context, documentSnapshot, i) {
        Supplier supplier = documentSnapshot[i].data() as Supplier;
        if (supplier.productName!.isNotEmpty)
          return campaignItem(supplier);
        else
          return Container();
      },
      // isLive: true,
      query: accountService.getFindSuppliersQuery(),
      onEmpty: EmptyBox(text: 'Nothing to show'),
      itemsPerPage: 10,
      bottomLoader: LoadingData(),
      initialLoader: LoadingData(),
    );
  }

  campaignItem(Supplier supplier) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: CachedImage(url: supplier.productImage, height: MediaQuery.of(context).size.width - 80, roundedCorners: true, circular: false)),
          SizedBox(height: 20),
          Text(supplier.productName!, textScaleFactor: 1.2, style: TextStyle(color: primaryColor)),
          SizedBox(height: 10),
          Text(supplier.productDescription!, textScaleFactor: 1, style: TextStyle(color: primaryColor, fontStyle: FontStyle.italic)),
          InkWell(
            onTap: () => utilService.openLink(supplier.url!),
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: const EdgeInsets.only(bottom: 10, top: 15),
                decoration: BoxDecoration(
                  color: redColor,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Text(supplier.buttonText!, style: TextStyle(color: Colors.white))),
          ),
        ],
      ),
    );
  }
}
