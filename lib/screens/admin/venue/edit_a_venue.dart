import 'dart:io';

import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/screens/home/home_page.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/storage_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

class EditAVenue extends StatefulWidget {
  final Venue? venue;

  EditAVenue({this.venue});

  @override
  _EditAVenueState createState() => _EditAVenueState();
}

class _EditAVenueState extends State<EditAVenue> {
  RxInt index = 1.obs;
  final TextEditingController venueNameTEC = TextEditingController(), employeesCountTEC = TextEditingController(), descriptionTEC = TextEditingController();
  final TextEditingController buildingNameTEC = TextEditingController(), townTEC = TextEditingController(), postCodeTEC = TextEditingController(), telephoneTEC = TextEditingController(), websiteTEC = TextEditingController(); //, bookingLinkTEC = TextEditingController();
  final TextEditingController mondayOpen = TextEditingController(), mondayClose = TextEditingController(), tuesdayOpen = TextEditingController(), tuesdayClose = TextEditingController(), wednesdayOpen = TextEditingController(), wednesdayClose = TextEditingController(), thursdayOpen = TextEditingController(), thursdayClose = TextEditingController(), fridayOpen = TextEditingController(), fridayClose = TextEditingController(), saturdayOpen = TextEditingController(), saturdayClose = TextEditingController(), sundayOpen = TextEditingController(), sundayClose = TextEditingController();
  final TextEditingController fbTEC = TextEditingController(), instaTEC = TextEditingController(), twTEC = TextEditingController(), liTEC = TextEditingController();
  var promoFile = File('').obs;
  var logoFile = File('').obs;
  String? promoURL, logoURL;

  final utilService = Get.find<UtilService>();
  final storageService = Get.find<StorageService>();
  final userController = Get.find<UserController>();

  Rx<bool> dogFriendly = true.obs, acceptTableBooking = true.obs, goodToGo = false.obs, preTheatreDining = false.obs, takeaway = false.obs, wheelChairAccess = false.obs, showTips = false.obs;
  Rx<bool> acceptMonday = true.obs, acceptTuesday = true.obs, acceptWednesday = true.obs, acceptThursday = false.obs, acceptFriday = false.obs, acceptSaturday = false.obs, acceptSunday = false.obs;
  Rx<bool> isOpenOnMonday = true.obs, isOpenOnTuesday = true.obs, isOpenOnWednesday = true.obs, isOpenOnThursday = false.obs, isOpenOnFriday = false.obs, isOpenOnSaturday = false.obs, isOpenOnSunday = false.obs;
  Rx<bool> vegetarian = false.obs, vegan = false.obs, halal = false.obs, paleo = false.obs, ketogenic = false.obs, checkMarketing = true.obs;
  Rx<bool> glutenIntolerance = false.obs, coeliacIntolerance = false.obs, lactoseIntolerance = false.obs, treeNutIntolerance = false.obs, peanutIntolerance = false.obs, fishIntolerance = false.obs, shellFishIntolerance = false.obs, yeastIntolerance = false.obs, glutenAllergy = false.obs, coeliacAllergy = false.obs, lactoseAllergy = false.obs, treeNutAllergy = false.obs, peanutAllergy = false.obs, fishAllergy = false.obs, shellFishAllergy = false.obs, yeastAllergy = false.obs;

  RxList<String> selectedFoodTypes = ['Other'].obs;
  List foodTypes = ['Indian', 'Chinese', 'Abyssinia', 'Mexican', 'Bistro', 'Thai', 'Italian', 'Spanish', 'Portuguese', 'Tapas', 'Vegan', 'Vegetarian', 'Gluten Free', 'English', 'Scottish', 'Irish', 'Welsh', 'American', 'Lebanese', 'Afternoon Tea', 'African', 'Quirky Cafe', 'Other'];
  List<String> preferences = [], intolerances = [], allergies = [];

  FocusScopeNode node = FocusScopeNode();

  @override
  void initState() {
    venueNameTEC.text = widget.venue!.venueName!;
    employeesCountTEC.text = widget.venue!.noEmployees.toString();
    descriptionTEC.text = widget.venue!.venueDescription!;
    dogFriendly.value = widget.venue!.dogFriendly!;
    acceptTableBooking.value = widget.venue!.acceptTableBooking!;
    goodToGo.value = widget.venue!.goodToGo!;
    preTheatreDining.value = widget.venue!.preTheatreDining!;
    takeaway.value = widget.venue!.takeaway!;
    wheelChairAccess.value = widget.venue!.wheelChairAccess!;
    promoURL = widget.venue!.coverURL;
    logoURL = widget.venue!.logo;

    buildingNameTEC.text = widget.venue!.streetAddress!;
    townTEC.text = widget.venue!.townCity!;
    postCodeTEC.text = widget.venue!.postCode!;
    telephoneTEC.text = widget.venue!.venuePhoneNumber!;
    websiteTEC.text = widget.venue!.website!;
    //bookingLinkTEC.text = widget.venue.venueBookingLink;

    selectedFoodTypes.value = widget.venue!.foodTypes!.cast<String>();

    mondayOpen.text = widget.venue!.monday!.open!.toStringAsFixed(2);
    tuesdayOpen.text = widget.venue!.tuesday!.open!.toStringAsFixed(2);
    wednesdayOpen.text = widget.venue!.wednesday!.open!.toStringAsFixed(2);
    thursdayOpen.text = widget.venue!.thursday!.open!.toStringAsFixed(2);
    fridayOpen.text = widget.venue!.friday!.open!.toStringAsFixed(2);
    saturdayOpen.text = widget.venue!.saturday!.open!.toStringAsFixed(2);
    sundayOpen.text = widget.venue!.sunday!.open!.toStringAsFixed(2);
    mondayClose.text = widget.venue!.monday!.close!.toStringAsFixed(2);
    tuesdayClose.text = widget.venue!.tuesday!.close!.toStringAsFixed(2);
    wednesdayClose.text = widget.venue!.wednesday!.close!.toStringAsFixed(2);
    thursdayClose.text = widget.venue!.thursday!.close!.toStringAsFixed(2);
    fridayClose.text = widget.venue!.friday!.close!.toStringAsFixed(2);
    saturdayClose.text = widget.venue!.saturday!.close!.toStringAsFixed(2);
    sundayClose.text = widget.venue!.sunday!.close!.toStringAsFixed(2);
    acceptMonday.value = widget.venue!.monday!.accept!;
    isOpenOnMonday.value = widget.venue!.monday!.isOpen!;
    acceptTuesday.value = widget.venue!.tuesday!.accept!;
    isOpenOnTuesday.value = widget.venue!.tuesday!.isOpen!;
    acceptWednesday.value = widget.venue!.wednesday!.accept!;
    isOpenOnWednesday.value = widget.venue!.wednesday!.isOpen!;
    acceptThursday.value = widget.venue!.thursday!.accept!;
    isOpenOnThursday.value = widget.venue!.thursday!.isOpen!;
    acceptFriday.value = widget.venue!.friday!.accept!;
    isOpenOnFriday.value = widget.venue!.friday!.isOpen!;
    acceptSaturday.value = widget.venue!.saturday!.accept!;
    isOpenOnSaturday.value = widget.venue!.saturday!.isOpen!;
    acceptSunday.value = widget.venue!.sunday!.accept!;
    isOpenOnSunday.value = widget.venue!.sunday!.isOpen!;

    glutenIntolerance.value = widget.venue!.intolerances!.contains("Gluten Free");
    coeliacIntolerance.value = widget.venue!.intolerances!.contains("Coeliac");
    lactoseIntolerance.value = widget.venue!.intolerances!.contains("Lactose");
    treeNutIntolerance.value = widget.venue!.intolerances!.contains("Tree Nut");
    peanutIntolerance.value = widget.venue!.intolerances!.contains("Peanut");
    fishIntolerance.value = widget.venue!.intolerances!.contains("Fish");
    shellFishIntolerance.value = widget.venue!.intolerances!.contains("Shell Fish");
    yeastIntolerance.value = widget.venue!.intolerances!.contains("Yeast");
    glutenAllergy.value = widget.venue!.allergies!.contains("Gluten Free");
    coeliacAllergy.value = widget.venue!.allergies!.contains("Coeliac");
    lactoseAllergy.value = widget.venue!.allergies!.contains("Lactose");
    treeNutAllergy.value = widget.venue!.allergies!.contains("Tree Nut");
    peanutAllergy.value = widget.venue!.allergies!.contains("Peanut");
    fishAllergy.value = widget.venue!.allergies!.contains("Fish");
    shellFishAllergy.value = widget.venue!.allergies!.contains("Shell Fish");
    yeastAllergy.value = widget.venue!.allergies!.contains("Yeast");
    vegetarian.value = userController.currentUser.value.vegetarian!;
    vegan.value = userController.currentUser.value.vegan!;
    halal.value = userController.currentUser.value.halal!;
    paleo.value = userController.currentUser.value.paleo!;
    ketogenic.value = userController.currentUser.value.ketogenic!;
    setIntoleranceValue(1, widget.venue!.intolerances!.contains("Gluten Free"));
    setIntoleranceValue(2, widget.venue!.intolerances!.contains("Coeliac"));
    setIntoleranceValue(3, widget.venue!.intolerances!.contains("Lactose"));
    setIntoleranceValue(4, widget.venue!.intolerances!.contains("Tree Nut"));
    setIntoleranceValue(5, widget.venue!.intolerances!.contains("Peanut"));
    setIntoleranceValue(6, widget.venue!.intolerances!.contains("Fish"));
    setIntoleranceValue(7, widget.venue!.intolerances!.contains("Shell Fish"));
    setIntoleranceValue(8, widget.venue!.intolerances!.contains("Yeast"));
    setAllergyValue(1, widget.venue!.allergies!.contains("Gluten Free"));
    setAllergyValue(2, widget.venue!.allergies!.contains("Coeliac"));
    setAllergyValue(3, widget.venue!.allergies!.contains("Lactose"));
    setAllergyValue(4, widget.venue!.allergies!.contains("Tree Nut"));
    setAllergyValue(5, widget.venue!.allergies!.contains("Peanut"));
    setAllergyValue(6, widget.venue!.allergies!.contains("Fish"));
    setAllergyValue(7, widget.venue!.allergies!.contains("Shell Fish"));
    setAllergyValue(8, widget.venue!.allergies!.contains("Yeast"));

    fbTEC.text = widget.venue!.facebook!;
    instaTEC.text = widget.venue!.instagram!;
    twTEC.text = widget.venue!.twitter!;
    liTEC.text = widget.venue!.linkedin!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    node = FocusScope.of(context);

    return WillPopScope(
      onWillPop: () => index.value == 1 ? utilService.goBackDialog() : index--,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15),
          backgroundColor: primaryColor,
          actions: [
            Center(child: InkWell(onTap: () => utilService.goBackDialog(), child: Text('Cancel'))),
            SizedBox(width: 15),
          ],
        ),
        body: Obx(() {
          return Column(
            children: [
              VenueTimeline(progressIndex: index.value - 1),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: appBackground,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        switchLayout(),
                        Divider(height: 50, color: Colors.white54),
                        CustomButton(
                            color: orangeColor,
                            text: index.value == 6 ? 'Edit Venue' : 'Proceed',
                            function: () async {
                              switch (index.value) {
                                case 1:
                                  if (logoFile == null || promoFile == null || venueNameTEC.text.isEmpty || employeesCountTEC.text.isEmpty || descriptionTEC.text.isEmpty) return showRedAlert('Please fill up all the details');
                                  break;
                                case 2:
                                  if (buildingNameTEC.text.isEmpty || townTEC.text.isEmpty || postCodeTEC.text.isEmpty || telephoneTEC.text.isEmpty || websiteTEC.text.isEmpty) return showRedAlert('Please fill up all the details');
                              }
                              if (index.value != 6)
                                index++;
                              else {
                                utilService.showLoading();
                                String venueID = widget.venue!.venueID!;
                                if (logoFile.value.path != '') logoURL = await storageService.uploadImage(logoFile.value);
                                if (promoFile.value.path != '') promoURL = await storageService.uploadImage(promoFile.value);
                                Map venue = {
                                  //Basic
                                  'accountID': userController.currentUser.value.accountID,
                                  'accountAdmin': userController.currentUser.value.userID,
                                  'venueID': venueID,
                                  'venueName': venueNameTEC.text,
                                  'venueDescription': descriptionTEC.text,
                                  'noEmployees': int.parse(employeesCountTEC.text),
                                  'logo': logoURL,
                                  'coverURL': promoURL,
                                  'images': [promoURL],
                                  'dogFriendly': dogFriendly.value,
                                  'acceptTableBooking': acceptTableBooking.value,
                                  'goodToGo': goodToGo.value,
                                  'preTheatreDining': preTheatreDining.value,
                                  'takeaway': takeaway.value,
                                  'wheelChairAccess': wheelChairAccess.value,
                                  'showTips': showTips.value,
                                  //Location
                                  'streetAddress': buildingNameTEC.text,
                                  'townCity': townTEC.text,
                                  'postCode': postCodeTEC.text.replaceAll(" ", "").toUpperCase(),
                                  //'venueBookingLink': bookingLinkTEC.text ?? '',
                                  'website': websiteTEC.text,
                                  'venuePhoneNumber': telephoneTEC.text,
                                  //Food Types
                                  'foodTypes': selectedFoodTypes,
                                  //Timing
                                  'monday': {'open': parseToDouble(mondayOpen.text), 'close': parseToDouble(mondayClose.text), 'accept': acceptMonday.value, 'isOpen': isOpenOnMonday.value},
                                  'tuesday': {'open': parseToDouble(tuesdayOpen.text), 'close': parseToDouble(tuesdayClose.text), 'accept': acceptTuesday.value, 'isOpen': isOpenOnTuesday.value},
                                  'wednesday': {'open': parseToDouble(wednesdayOpen.text), 'close': parseToDouble(wednesdayClose.text), 'accept': acceptWednesday.value, 'isOpen': isOpenOnWednesday.value},
                                  'thursday': {'open': parseToDouble(thursdayOpen.text), 'close': parseToDouble(thursdayClose.text), 'accept': acceptThursday.value, 'isOpen': isOpenOnThursday.value},
                                  'friday': {'open': parseToDouble(fridayOpen.text), 'close': parseToDouble(fridayClose.text), 'accept': acceptFriday.value, 'isOpen': isOpenOnFriday.value},
                                  'saturday': {'open': parseToDouble(saturdayOpen.text), 'close': parseToDouble(saturdayClose.text), 'accept': acceptSaturday.value, 'isOpen': isOpenOnSaturday.value},
                                  'sunday': {'open': parseToDouble(sundayOpen.text), 'close': parseToDouble(sundayClose.text), 'accept': acceptSunday.value, 'isOpen': isOpenOnSunday.value},
                                  //Preferences
                                  'vegetarian': vegetarian.value,
                                  'vegan': vegan.value,
                                  'halal': halal.value,
                                  'paleo': paleo.value,
                                  'ketogenic': ketogenic.value,
                                  'intolerances': intolerances,
                                  'allergies': allergies,
                                  //Social Media Links
                                  'facebook': fbTEC.text ?? '',
                                  'instagram': instaTEC.text ?? '',
                                  'twitter': twTEC.text ?? '',
                                  'linkedin': liTEC.text ?? '',
                                };
                                await cloudFunction(functionName: 'updateVenue', parameters: venue, action: () => Get.offAll(() => HomePage()));
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  switchLayout() {
    switch (index.value) {
      case 1:
        return step1();
      case 2:
        return step2();
      case 3:
        return step3();
      case 4:
        return step4();
      case 5:
        return step5();
      case 6:
        return step6();
    }
  }

  step1() {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            logoFile.value = await storageService.pickImage();
          },
          child: Stack(
            children: [
              CachedImage(
                roundedCorners: true,
                url: logoURL,
                imageFile: logoFile.value.path == '' ? null : logoFile.value,
                height: 120,
                circular: false,
              ),
              Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(5),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Icon(Icons.camera_alt, color: primaryColor, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
        CustomTextField(validate: true, hint: 'Venue Name', label: 'Venue Name *', textInputType: TextInputType.text, controller: venueNameTEC),
        CustomTextField(validate: true, hint: 'No. of Employees at this venue', label: 'No. of Employees at this venue *', textInputType: TextInputType.numberWithOptions(signed: false, decimal: false), controller: employeesCountTEC),
        CustomTextField(validate: true, hint: '\nVenue Description', label: 'Venue Description *', textInputType: TextInputType.text, controller: descriptionTEC, maxLines: 3),
        InkWell(
          onTap: () async {
            promoFile.value = await storageService.pickImage(aspectRatio: CropAspectRatioPreset.ratio5x3);
          },
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                height: MediaQuery.of(context).size.height * 0.25,
                child: CachedImage(
                  roundedCorners: true,
                  url: promoURL,
                  imageFile: promoFile.value.path == '' ? null : promoFile.value,
                  height: double.infinity,
                  circular: false,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                padding: const EdgeInsets.all(5),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Icon(Icons.camera_alt, color: primaryColor, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
        CheckboxListTile(
          value: acceptTableBooking.value,
          onChanged: (val) => acceptTableBooking.value = val!,
          title: Text('We accept table bookings'),
        ),
        CheckboxListTile(
          value: dogFriendly.value,
          onChanged: (val) => dogFriendly.value = val!,
          title: Text('We are dog friendly'),
        ),
        CheckboxListTile(
          value: preTheatreDining.value,
          onChanged: (val) => preTheatreDining.value = val!,
          title: Text('Pre-theatre dining available'),
        ),
        CheckboxListTile(
          value: takeaway.value,
          onChanged: (val) => takeaway.value = val!,
          title: Text('Takeaways available'),
        ),
        CheckboxListTile(
          value: wheelChairAccess.value,
          onChanged: (val) => wheelChairAccess.value = val!,
          title: Text('Wheelchair access available'),
        ),
        CheckboxListTile(
          value: showTips.value,
          onChanged: (val) => showTips.value = val!,
          title: Text('Receive hospitality tips and ideas from Not Usual Ltd.'),
        ),
      ],
    );
  }

  step2() {
    return Column(children: [
      Text('Contact Details', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
      CustomTextField(validate: true, hint: 'Building Name/No & Street', label: 'Building Name/No & Street *', textInputType: TextInputType.text, controller: buildingNameTEC),
      CustomTextField(validate: true, hint: 'Town', label: 'Town/City *', textInputType: TextInputType.text, controller: townTEC),
      CustomTextField(validate: true, hint: 'Postcode', label: 'Postcode *', textInputType: TextInputType.text, controller: postCodeTEC),
      CustomTextField(validate: true, hint: 'Telephone', label: 'Telephone *', textInputType: TextInputType.phone, controller: telephoneTEC),
      CustomTextField(validate: true, hint: 'Website Address', label: 'Website Address *', textInputType: TextInputType.url, controller: websiteTEC),
      //CustomTextField(validate: false, hint: 'Venue Booking Link', label: 'Venue Booking Link', textInputType: TextInputType.url, controller: bookingLinkTEC),
    ]);
  }

  step3() {
    return Column(children: [
      Text('Select the type of Food you offer', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3),
        itemCount: foodTypes.length,
        itemBuilder: (context, i) {
          return Obx(() {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              value: selectedFoodTypes.contains(foodTypes[i]),
              onChanged: (val) {
                if (selectedFoodTypes.contains(foodTypes[i]))
                  selectedFoodTypes.remove(foodTypes[i]);
                else
                  selectedFoodTypes.add(foodTypes[i]);
              },
              title: Text(foodTypes[i], textScaleFactor: 1),
            );
          });
        },
      ),
    ]);
  }

  step4() {
    return Column(children: [
      Text('Venue Timing', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
      Text('Enter the days and times you open under normal circumstances and check the box next to each day you wish to accept Eat Out Round About vouchers\n\nUncheck the day if the venue is closed on that day', style: TextStyle(color: Colors.grey)),
      SizedBox(height: 20),
      Row(children: [
        Expanded(flex: 22, child: Text('')),
        Expanded(flex: 15, child: Text('Opens At', textScaleFactor: 0.9, textAlign: TextAlign.center)),
        Expanded(flex: 15, child: Text('Closes At', textScaleFactor: 0.9, textAlign: TextAlign.center)),
        Expanded(flex: 10, child: Text('Voucher', textScaleFactor: 0.9, textAlign: TextAlign.center)),
      ]),
      SizedBox(height: 15),
      Row(children: [
        Expanded(
          flex: 25,
          child: CheckboxListTile(
            visualDensity: VisualDensity.compact,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text('Monday', style: TextStyle(color: greenColor)),
            value: isOpenOnMonday.value,
            onChanged: (val) {
              isOpenOnMonday.value = val!;
              acceptMonday.value = val;
              if (!val) {
                mondayOpen.text = '-1';
                mondayClose.text = '-1';
              } else {
                mondayOpen.text = '10.00';
                mondayClose.text = '23.00';
              }
            },
          ),
        ),
        if (isOpenOnMonday.value) Expanded(flex: 15, child: customText(mondayOpen)),
        if (isOpenOnMonday.value) Expanded(flex: 15, child: customText(mondayClose)),
        if (isOpenOnMonday.value)
          Expanded(
            flex: 10,
            child: Checkbox(value: acceptMonday.value, onChanged: (bool? newValue) => acceptMonday.value = !acceptMonday.value),
          ),
        if (!isOpenOnMonday.value) Expanded(flex: 40, child: closedText()),
      ]),
      Row(children: [
        Expanded(
          flex: 25,
          child: CheckboxListTile(
            visualDensity: VisualDensity.compact,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text('Tuesday', style: TextStyle(color: greenColor)),
            value: isOpenOnTuesday.value,
            onChanged: (val) {
              isOpenOnTuesday.value = val!;
              acceptTuesday.value = val;
              if (!val) {
                tuesdayOpen.text = '-1';
                tuesdayClose.text = '-1';
              } else {
                tuesdayOpen.text = '10.00';
                tuesdayClose.text = '23.00';
              }
            },
          ),
        ),
        if (isOpenOnTuesday.value) Expanded(flex: 15, child: customText(tuesdayOpen)),
        if (isOpenOnTuesday.value) Expanded(flex: 15, child: customText(tuesdayClose)),
        if (isOpenOnTuesday.value)
          Expanded(
            flex: 10,
            child: Checkbox(value: acceptTuesday.value, onChanged: (bool? newValue) => acceptTuesday.value = !acceptTuesday.value),
          ),
        if (!isOpenOnTuesday.value) Expanded(flex: 40, child: closedText()),
      ]),
      Row(children: [
        Expanded(
          flex: 25,
          child: CheckboxListTile(
            visualDensity: VisualDensity.compact,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text('Wednesday', style: TextStyle(color: greenColor)),
            value: isOpenOnWednesday.value,
            onChanged: (val) {
              isOpenOnWednesday.value = val!;
              acceptWednesday.value = val;
              if (!val) {
                wednesdayOpen.text = '-1';
                wednesdayClose.text = '-1';
              } else {
                wednesdayOpen.text = '10.00';
                wednesdayClose.text = '23.00';
              }
            },
          ),
        ),
        if (isOpenOnWednesday.value) Expanded(flex: 15, child: customText(wednesdayOpen)),
        if (isOpenOnWednesday.value) Expanded(flex: 15, child: customText(wednesdayClose)),
        if (isOpenOnWednesday.value)
          Expanded(
            flex: 10,
            child: Checkbox(value: acceptWednesday.value, onChanged: (bool? newValue) => acceptWednesday.value = !acceptWednesday.value),
          ),
        if (!isOpenOnWednesday.value) Expanded(flex: 40, child: closedText()),
      ]),
      Row(children: [
        Expanded(
          flex: 25,
          child: CheckboxListTile(
            visualDensity: VisualDensity.compact,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text('Thursday', style: TextStyle(color: greenColor)),
            value: isOpenOnThursday.value,
            onChanged: (val) {
              isOpenOnThursday.value = val!;
              acceptThursday.value = val;
              if (!val) {
                thursdayOpen.text = '-1';
                thursdayClose.text = '-1';
              } else {
                thursdayOpen.text = '10.00';
                thursdayClose.text = '23.00';
              }
            },
          ),
        ),
        if (isOpenOnThursday.value) Expanded(flex: 15, child: customText(thursdayOpen)),
        if (isOpenOnThursday.value) Expanded(flex: 15, child: customText(thursdayClose)),
        if (isOpenOnThursday.value)
          Expanded(
            flex: 10,
            child: Checkbox(value: acceptThursday.value, onChanged: (bool? newValue) => acceptThursday.value = !acceptThursday.value),
          ),
        if (!isOpenOnThursday.value) Expanded(flex: 40, child: closedText()),
      ]),
      Row(children: [
        Expanded(
          flex: 25,
          child: CheckboxListTile(
            visualDensity: VisualDensity.compact,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text('Friday', style: TextStyle(color: greenColor)),
            value: isOpenOnFriday.value,
            onChanged: (val) {
              isOpenOnFriday.value = val!;
              acceptFriday.value = val;
              if (!val) {
                fridayOpen.text = '-1';
                fridayClose.text = '-1';
              } else {
                fridayOpen.text = '10.00';
                fridayClose.text = '23.00';
              }
            },
          ),
        ),
        if (isOpenOnFriday.value) Expanded(flex: 15, child: customText(fridayOpen)),
        if (isOpenOnFriday.value) Expanded(flex: 15, child: customText(fridayClose)),
        if (isOpenOnFriday.value)
          Expanded(
            flex: 10,
            child: Checkbox(value: acceptFriday.value, onChanged: (bool? newValue) => acceptFriday.value = !acceptFriday.value),
          ),
        if (!isOpenOnFriday.value) Expanded(flex: 40, child: closedText()),
      ]),
      Row(children: [
        Expanded(
          flex: 25,
          child: CheckboxListTile(
            visualDensity: VisualDensity.compact,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text('Saturday', style: TextStyle(color: greenColor)),
            value: isOpenOnSaturday.value,
            onChanged: (val) {
              isOpenOnSaturday.value = val!;
              acceptSaturday.value = val;
              if (!val) {
                saturdayOpen.text = '-1';
                saturdayClose.text = '-1';
              } else {
                saturdayOpen.text = '10.00';
                saturdayClose.text = '23.00';
              }
            },
          ),
        ),
        if (isOpenOnSaturday.value) Expanded(flex: 15, child: customText(saturdayOpen)),
        if (isOpenOnSaturday.value) Expanded(flex: 15, child: customText(saturdayClose)),
        if (isOpenOnSaturday.value)
          Expanded(
            flex: 10,
            child: Checkbox(value: acceptSaturday.value, onChanged: (bool? newValue) => acceptSaturday.value = !acceptSaturday.value),
          ),
        if (!isOpenOnSaturday.value) Expanded(flex: 40, child: closedText()),
      ]),
      Row(children: [
        Expanded(
          flex: 25,
          child: CheckboxListTile(
            visualDensity: VisualDensity.compact,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text('Sunday', style: TextStyle(color: greenColor)),
            value: isOpenOnSunday.value,
            onChanged: (val) {
              isOpenOnSunday.value = val!;
              acceptSunday.value = val;
              if (!val) {
                sundayOpen.text = '-1';
                sundayClose.text = '-1';
              } else {
                sundayOpen.text = '10.00';
                sundayClose.text = '23.00';
              }
            },
          ),
        ),
        if (isOpenOnSunday.value) Expanded(flex: 15, child: customText(sundayOpen)),
        if (isOpenOnSunday.value) Expanded(flex: 15, child: customText(sundayClose)),
        if (isOpenOnSunday.value)
          Expanded(
            flex: 10,
            child: Checkbox(value: acceptSunday.value, onChanged: (bool? newValue) => acceptSunday.value = !acceptSunday.value),
          ),
        if (!isOpenOnSunday.value) Expanded(flex: 40, child: closedText()),
      ]),
    ]);
  }

  step5() {
    return Column(children: [
      Text('Dietary Preferences', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
      Text('Select dietary preferences that your venue offers', style: TextStyle(color: Colors.grey)),
      SizedBox(height: 20),
      setting(0, 'Vegetarian'),
      setting(1, 'Vegan'),
      setting(2, 'Halal'),
      setting(3, 'Paleo'),
      setting(4, 'Ketogenic'),
      Divider(height: 25),
      Row(
        children: [
          Expanded(child: Text('Intolerance')),
          Expanded(child: Text('Allergy')),
          Expanded(child: Text('')),
        ],
      ),
      intoleranceAllergies('Gluten Free', 1),
      intoleranceAllergies('Coeliac', 2),
      intoleranceAllergies('Lactose', 3),
      intoleranceAllergies('Tree Nut', 4),
      intoleranceAllergies('Peanut', 5),
      intoleranceAllergies('Fish', 6),
      intoleranceAllergies('Shell Fish', 7),
      intoleranceAllergies('Yeast', 8),
    ]);
  }

  step6() {
    return Column(children: [
      Text('Social Media Links', textScaleFactor: 1.5, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
      CustomTextField(controller: fbTEC, hint: 'Enter Facebook Link', label: 'Facebook Link', textInputType: TextInputType.url),
      CustomTextField(controller: instaTEC, hint: 'Enter Instagram Link', label: 'Instagram Link', textInputType: TextInputType.url),
      CustomTextField(controller: twTEC, hint: 'Enter Twitter Link', label: 'Twitter Link', textInputType: TextInputType.url),
      CustomTextField(controller: liTEC, hint: 'Enter LinkedIn Link', label: 'LinkedIn Link', textInputType: TextInputType.url),
    ]);
  }

  parseToDouble(String text) {
    if (text != null && text != '')
      return double.parse(text);
    else
      return -1; //-1 means closed
  }

  customText(controller) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(right: 10),
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 15),
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
      ),
    );
  }

  closedText() {
    return SizedBox(
      height: 40,
      child: TextField(
        readOnly: true,
        enabled: false,
        textAlign: TextAlign.center,
        style: TextStyle(color: redColor, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
        textInputAction: TextInputAction.next,
        onEditingComplete: () => node.nextFocus(),
        controller: TextEditingController(text: 'Closed'),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          fillColor: Colors.grey.shade300,
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
      ),
    );
  }

  intoleranceAllergies(String title, int index) {
    return Row(
      children: [
        Expanded(
            child: Row(
          children: [
            Checkbox(onChanged: (value) => setIntoleranceValue(index, value!), value: getIntoleranceValue(index)),
          ],
        )),
        Expanded(
            child: Row(
          children: [
            Checkbox(onChanged: (value) => setAllergyValue(index, value!), value: getAllergyValue(index)),
          ],
        )),
        Expanded(child: Text(title)),
      ],
    );
  }

  getIntoleranceValue(int index) {
    switch (index) {
      case 1:
        return glutenIntolerance.value;
      case 2:
        return coeliacIntolerance.value;
      case 3:
        return lactoseIntolerance.value;
      case 4:
        return treeNutIntolerance.value;
      case 5:
        return peanutIntolerance.value;
      case 6:
        return fishIntolerance.value;
      case 7:
        return shellFishIntolerance.value;
      case 8:
        return yeastIntolerance.value;
    }
  }

  setIntoleranceValue(int index, bool value) {
    switch (index) {
      case 1:
        if (value)
          intolerances.add('Gluten Free');
        else
          intolerances.remove('Gluten Free');
        return glutenIntolerance.value = value;
      case 2:
        if (value)
          intolerances.add('Coeliac');
        else
          intolerances.remove('Coeliac');
        return coeliacIntolerance.value = value;
      case 3:
        if (value)
          intolerances.add('Lactose');
        else
          intolerances.remove('Lactose');
        return lactoseIntolerance.value = value;
      case 4:
        if (value)
          intolerances.add('Tree Nut');
        else
          intolerances.remove('Tree Nut');
        return treeNutIntolerance.value = value;
      case 5:
        if (value)
          intolerances.add('Peanut');
        else
          intolerances.remove('Peanut');
        return peanutIntolerance.value = value;
      case 6:
        if (value)
          intolerances.add('Fish');
        else
          intolerances.remove('Fish');
        return fishIntolerance.value = value;
      case 7:
        if (value)
          intolerances.add('Shell Fish');
        else
          intolerances.remove('Shell Fish');
        return shellFishIntolerance.value = value;
      case 8:
        if (value)
          intolerances.add('Yeast');
        else
          intolerances.remove('Yeast');
        return yeastIntolerance.value = value;
    }
  }

  getAllergyValue(int index) {
    switch (index) {
      case 1:
        return glutenAllergy.value;
      case 2:
        return coeliacAllergy.value;
      case 3:
        return lactoseAllergy.value;
      case 4:
        return treeNutAllergy.value;
      case 5:
        return peanutAllergy.value;
      case 6:
        return fishAllergy.value;
      case 7:
        return shellFishAllergy.value;
      case 8:
        return yeastAllergy.value;
    }
  }

  setAllergyValue(int index, bool value) {
    switch (index) {
      case 1:
        if (value)
          allergies.add('Gluten Free');
        else
          allergies.remove('Gluten Free');
        return glutenAllergy.value = value;
      case 2:
        if (value)
          allergies.add('Coeliac');
        else
          allergies.remove('Coeliac');
        return coeliacAllergy.value = value;
      case 3:
        if (value)
          allergies.add('Lactose');
        else
          allergies.remove('Lactose');
        return lactoseAllergy.value = value;
      case 4:
        if (value)
          allergies.add('Tree Nut');
        else
          allergies.remove('Tree Nut');
        return treeNutAllergy.value = value;
      case 5:
        if (value)
          allergies.add('Peanut');
        else
          allergies.remove('Peanut');
        return peanutAllergy.value = value;
      case 6:
        if (value)
          allergies.add('Fish');
        else
          allergies.remove('Fish');
        return fishAllergy.value = value;
      case 7:
        if (value)
          allergies.add('Shell Fish');
        else
          allergies.remove('Shell Fish');
        return shellFishAllergy.value = value;
      case 8:
        if (value)
          allergies.add('Yeast');
        else
          allergies.remove('Yeast');
        return yeastAllergy.value = value;
    }
  }

  setting(int i, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          FlutterSwitch(
            value: getValue(i),
            borderRadius: 30.0,
            padding: 8.0,
            activeColor: primaryColor,
            showOnOff: true,
            onToggle: (value) => setValue(i, value),
          ),
          SizedBox(width: 15),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  getValue(int i) {
    switch (i) {
      case 0:
        return vegetarian.value;
      case 1:
        return vegan.value;
      case 2:
        return halal.value;
      case 3:
        return paleo.value;
      case 4:
        return ketogenic.value;
    }
  }

  setValue(int i, bool value) {
    switch (i) {
      case 0:
        return vegetarian.value = value;
      case 1:
        return vegan.value = value;
      case 2:
        return halal.value = value;
      case 3:
        return paleo.value = value;
      case 4:
        return ketogenic.value = value;
    }
  }
}
