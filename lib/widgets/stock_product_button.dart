import 'package:eatoutroundabout/models/product_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockProductButton extends StatefulWidget {
  final Product? product;
  final Venue? venue;

  StockProductButton({this.product, this.venue});

  @override
  _StockProductButtonState createState() => _StockProductButtonState();
}

class _StockProductButtonState extends State<StockProductButton> {
  final firestoreService = Get.find<FirestoreService>();
  final utilService = Get.find<UtilService>();
  bool? productAdded;

  @override
  void initState() {
    productAdded = widget.product!.venues!.contains(widget.venue!.venueID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: CustomButton(
        color: productAdded! ? Colors.grey.shade400 : primaryColor,
        text: getText(),
        function: () {
          Get.defaultDialog(
            radius: padding / 2,
            title: 'Confirm',
            content: Text("Would you like to ${productAdded! ? 'remove' : 'add'} this product ${productAdded! ? 'from' : 'to'} the venue ${widget.venue!.venueName}?", textScaleFactor: 1, textAlign: TextAlign.center),
            actions: [
              CustomButton(
                color: primaryColor,
                text: 'Yes',
                function: () async {
                  Get.back(); // Close Alert Dialog
                  if (productAdded!)
                    widget.product!.venues!.remove(widget.venue!.venueID);
                  else
                    widget.product!.venues!.add(widget.venue!.venueID);
                  utilService.showLoading();
                  await firestoreService.updateProductForVenues(widget.product!);
                  if (productAdded!) await cloudFunction(functionName: 'updateVenue', parameters: {'venueImpactStatus': 'gold'}, action: () {});
                  Get.back();
                  setState(() => productAdded = !productAdded!);
                },
              ),
              CustomButton(function: () => Get.back(), text: 'Cancel', color: Colors.grey),
            ],
          );
        },
      ),
    );
  }

  getText() {
    if (productAdded!)
      return 'Remove from Stock';
    else
      return 'Add to Stock';
  }
}
