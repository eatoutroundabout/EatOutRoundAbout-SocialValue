import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/screens/home/home_page.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class DietaryPreferences extends StatefulWidget {
  final bool? isSetup;

  DietaryPreferences({this.isSetup});

  @override
  State<DietaryPreferences> createState() => _DietaryPreferencesState();
}

class _DietaryPreferencesState extends State<DietaryPreferences> {
  final utilService = Get.find<UtilService>();
  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  final vegetarian = false.obs, vegan = false.obs, halal = false.obs, paleo = false.obs, ketogenic = false.obs, checkMarketing = true.obs;
  final glutenIntolerance = false.obs, coeliacIntolerance = false.obs, lactoseIntolerance = false.obs, treeNutIntolerance = false.obs, peanutIntolerance = false.obs, fishIntolerance = false.obs, shellFishIntolerance = false.obs, yeastIntolerance = false.obs, glutenAllergy = false.obs, coeliacAllergy = false.obs, lactoseAllergy = false.obs, treeNutAllergy = false.obs, peanutAllergy = false.obs, fishAllergy = false.obs, shellFishAllergy = false.obs, yeastAllergy = false.obs;
  List<String> intolerances = [];
  List<String> allergies = [];

  @override
  void initState() {
    glutenIntolerance.value = userController.currentUser.value.intolerances!.contains("Gluten Free");
    coeliacIntolerance.value = userController.currentUser.value.intolerances!.contains("Coeliac");
    lactoseIntolerance.value = userController.currentUser.value.intolerances!.contains("Lactose");
    treeNutIntolerance.value = userController.currentUser.value.intolerances!.contains("Tree Nut");
    peanutIntolerance.value = userController.currentUser.value.intolerances!.contains("Peanut");
    fishIntolerance.value = userController.currentUser.value.intolerances!.contains("Fish");
    shellFishIntolerance.value = userController.currentUser.value.intolerances!.contains("Shell Fish");
    yeastIntolerance.value = userController.currentUser.value.intolerances!.contains("Yeast");
    glutenAllergy.value = userController.currentUser.value.allergies!.contains("Gluten Free");
    coeliacAllergy.value = userController.currentUser.value.allergies!.contains("Coeliac");
    lactoseAllergy.value = userController.currentUser.value.allergies!.contains("Lactose");
    treeNutAllergy.value = userController.currentUser.value.allergies!.contains("Tree Nut");
    peanutAllergy.value = userController.currentUser.value.allergies!.contains("Peanut");
    fishAllergy.value = userController.currentUser.value.allergies!.contains("Fish");
    shellFishAllergy.value = userController.currentUser.value.allergies!.contains("Shell Fish");
    yeastAllergy.value = userController.currentUser.value.allergies!.contains("Yeast");
    vegetarian.value = userController.currentUser.value.vegetarian!;
    vegan.value = userController.currentUser.value.vegan!;
    halal.value = userController.currentUser.value.halal!;
    paleo.value = userController.currentUser.value.paleo!;
    ketogenic.value = userController.currentUser.value.ketogenic!;

    setIntoleranceValue(1, userController.currentUser.value.intolerances!.contains("Gluten Free"));
    setIntoleranceValue(2, userController.currentUser.value.intolerances!.contains("Coeliac"));
    setIntoleranceValue(3, userController.currentUser.value.intolerances!.contains("Lactose"));
    setIntoleranceValue(4, userController.currentUser.value.intolerances!.contains("Tree Nut"));
    setIntoleranceValue(5, userController.currentUser.value.intolerances!.contains("Peanut"));
    setIntoleranceValue(6, userController.currentUser.value.intolerances!.contains("Fish"));
    setIntoleranceValue(7, userController.currentUser.value.intolerances!.contains("Shell Fish"));
    setIntoleranceValue(8, userController.currentUser.value.intolerances!.contains("Yeast"));

    setAllergyValue(1, userController.currentUser.value.allergies!.contains("Gluten Free"));
    setAllergyValue(2, userController.currentUser.value.allergies!.contains("Coeliac"));
    setAllergyValue(3, userController.currentUser.value.allergies!.contains("Lactose"));
    setAllergyValue(4, userController.currentUser.value.allergies!.contains("Tree Nut"));
    setAllergyValue(5, userController.currentUser.value.allergies!.contains("Peanut"));
    setAllergyValue(6, userController.currentUser.value.allergies!.contains("Fish"));
    setAllergyValue(7, userController.currentUser.value.allergies!.contains("Shell Fish"));
    setAllergyValue(8, userController.currentUser.value.allergies!.contains("Yeast"));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'DIETARY PREFERENCES'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text('Food Preferences,\nIntolerances and Allergies', textAlign: TextAlign.center, textScaleFactor: 1.25, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
                  SizedBox(height: 15),
                  Text('We aim to provide you with a broad range of dining out options that meet your dietary requirements. Please update your preferences and we will keep you updated when venues are added that match your preferences and make suggestions where to dine out with friends.', textAlign: TextAlign.justify),
                  Divider(height: 50),
                  Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.2),
                  SizedBox(height: 25),
                  setting(0, 'Vegetarian'),
                  setting(1, 'Vegan'),
                  setting(2, 'Halal'),
                  setting(3, 'Paleo'),
                  setting(4, 'Ketogenic'),
                  Divider(height: 30),
                  Text('Intolerances and Allergies', style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.2),
                  SizedBox(height: 25),
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
                  Obx(() {
                    return CheckboxListTile(
                      contentPadding: const EdgeInsets.only(top: 10),
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        'I agree to Eat Out Round About processing my dietary information to improve my experience',
                        textScaleFactor: 0.95,
                        maxLines: 3,
                        style: TextStyle(color: Colors.teal),
                      ),
                      value: checkMarketing.value,
                      onChanged: (bool? value) {
                        checkMarketing.value = value!;
                      },
                    );
                  }),
                  // Obx(() {
                  //   return CheckboxListTile(
                  //     contentPadding: const EdgeInsets.only(top: 10),
                  //     controlAffinity: ListTileControlAffinity.leading,
                  //     title: Text(
                  //       'Confirm you are happy for us to retain this information for the future. You can edit or remove details at any time.',
                  //       textScaleFactor: 0.95,
                  //       maxLines: 3,
                  //       style: TextStyle(color: Colors.teal),
                  //     ),
                  //     value: retainInformation.value,
                  //     onChanged: (bool value) {
                  //       retainInformation.value = value;
                  //     },
                  //   );
                  // }),
                  ListTile(
                    contentPadding: const EdgeInsets.only(top: 10, bottom: 20),
                    title: InkWell(
                      onTap: () => utilService.openLink('https://eatoutroundabout.co.uk/legals/privacy-policy/'),
                      child: Text(
                        'To understand more about how we will use your information please see our privacy policy.',
                        textScaleFactor: 0.95,
                        maxLines: 2,
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  CustomButton(
                    text: 'Update',
                    function: () async {
                      if (!checkMarketing.value) {
                        showRedAlert('Please agree to the terms to continue');
                        return;
                      }
                      Map preferences = {
                        'userID': userController.currentUser.value.userID,
                        'ipAddress': await utilService.getIpAddress(),
                        'vegetarian': vegetarian.value,
                        'vegan': vegan.value,
                        'halal': halal.value,
                        'paleo': paleo.value,
                        'ketogenic': ketogenic.value,
                        'intolerances': intolerances,
                        'allergies': allergies,
                        //  'retainInformation': retainInformation.value,
                      };
                      await cloudFunction(
                        functionName: 'addDietaryPreferences',
                        parameters: preferences,
                        action: () async {
                          if (widget.isSetup!)
                            Get.offAll(() => HomePage());
                          else
                            Get.back();
                        },
                      );
                      await firestoreService.getCurrentUser();
                    },
                  ),
                  SizedBox(height: 15),
                  if (widget.isSetup!) CustomButton(text: 'Skip', color: Colors.grey, function: () => Get.offAll(() => DietaryPreferences(isSetup: true))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  intoleranceAllergies(String title, int index) {
    return Obx(() {
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
    });
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
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 25),
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
    });
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
