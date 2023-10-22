import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/screens/auth/splash_screen.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddAccount extends StatefulWidget {
  final bool? isVenueAccount;

  AddAccount({this.isVenueAccount});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final TextEditingController companyNameTEC = TextEditingController();

  final TextEditingController buildingNameTEC = TextEditingController();

  final TextEditingController townTEC = TextEditingController();

  final TextEditingController postCodeTEC = TextEditingController();

  final TextEditingController employeesCountTEC = TextEditingController();

  final TextEditingController businessTypeTEC = TextEditingController();

  final TextEditingController regNoTEC = TextEditingController();

  final TextEditingController telephoneTEC = TextEditingController();

  TextEditingController dobTEC = TextEditingController();

  final isCharity = false.obs;

  final isBusinessUnder3Years = false.obs;

  final tnc = true.obs;

  final billing = true.obs;

  final checked2 = true.obs;

  String businessType = 'Independent Business';

  DateTime? businessStartDate;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final userController = Get.find<UserController>();

  final utilService = Get.find<UtilService>();

  final firestoreService = Get.find<FirestoreService>();

  final RxBool showSplash = true.obs;

  Rx<String> industry = 'None'.obs;

  List industries = [];

  RxBool isLoading = true.obs;

  getValues() async {
    DocumentSnapshot doc = await firestoreService.getConstants();
    Map<String, dynamic> snapshot = doc!.data() as Map<String,dynamic>;
    industries = snapshot.containsKey('industries') ? doc.get('industries') : ['None'];
    isLoading.value = false;
  }

  @override
  void initState() {
    getValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (showSplash.value)
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage(widget.isVenueAccount! ? 'assets/images/join_venue.jpg' : 'assets/images/join_business.jpg'), fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.isVenueAccount! ? 'We partner with the best of local hospitality to bring revenue and footfall. Register your venue' : 'Promote your business on Eat Out Round About for free, helping you connect your business in the local economy, enjoy good food as you go and open more promotional features!',
                      textScaleFactor: 1.25,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 15),
                    CustomButton(
                      text: 'Proceed',
                      color: primaryColor,
                      function: () => showSplash.value = false,
                    ),
                  ],
                ),
              ),
            ),
          );
        else
          return Scaffold(
            appBar: AppBar(
              title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15),
              backgroundColor: primaryColor,
              centerTitle: true,
            ),
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  Heading(title: 'REGISTER ACCOUNT'),
                  Expanded(
                    child: Obx(() {
                      return isLoading.value
                          ? LoadingData()
                          : Container(
                              width: double.infinity,
                              color: appBackground,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(padding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Enter your business details below to create your account.', style: TextStyle(fontWeight: FontWeight.bold, color: greenColor)),
                                    CustomTextField(label: 'Company Name *', hint: 'Enter Company Name', controller: companyNameTEC, textInputType: TextInputType.text),
                                    CustomTextField(
                                        dropdown: DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(50.0),
                                                borderSide: BorderSide(width: 2, color: Colors.teal.shade400),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                                          isExpanded: true,
                                          style: TextStyle(color: primaryColor, fontSize: 17),
                                          value: industry.value,
                                          items: industries.map((value) {
                                            return DropdownMenuItem<String>(value: value, child: Text(value, textScaleFactor: 1, style: TextStyle(color: Colors.black)));
                                          }).toList(),
                                          onChanged: (value) => industry.value,
                                        ),
                                        label: 'Industry/Sector *'),
                                    CustomTextField(label: 'Building/Street Name *', hint: 'Enter name', controller: buildingNameTEC, textInputType: TextInputType.text),
                                    CustomTextField(label: 'Town *', hint: 'Enter town', controller: townTEC, textInputType: TextInputType.text),
                                    CustomTextField(label: 'Postcode *', hint: 'Enter postcode', controller: postCodeTEC, textInputType: TextInputType.text),
                                    CustomTextField(label: 'Telephone Number *', hint: 'Enter telephone number', controller: telephoneTEC, textInputType: TextInputType.phone),
                                    CustomTextField(label: 'No. of Employees *', hint: 'Enter No. of Employees', controller: employeesCountTEC, textInputType: TextInputType.numberWithOptions(signed: false, decimal: false)),
                                    CustomTextField(label: 'Company Registration No. (Optional)', hint: 'Company Registration No.', controller: regNoTEC, textInputType: TextInputType.name),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                                      child: Text('Business Type'),
                                    ),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(50.0),
                                            borderSide: BorderSide(width: 2, color: Colors.teal.shade400),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                                      isExpanded: true,
                                      style: TextStyle(color: primaryColor, fontSize: 17),
                                      value: businessType,
                                      items: [
                                        DropdownMenuItem(child: Text('Independent Business', textScaleFactor: 1, style: TextStyle(color: Colors.black)), value: 'Independent Business'),
                                        DropdownMenuItem(child: Text('Small Chain', textScaleFactor: 1, style: TextStyle(color: Colors.black)), value: 'Small Chain'),
                                        DropdownMenuItem(child: Text('National Chain', textScaleFactor: 1, style: TextStyle(color: Colors.black)), value: 'National Chain'),
                                      ],
                                      onChanged: (value) => businessType = value!,
                                    ),
                                    SizedBox(height: 15),
                                    Obx(() {
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: isBusinessUnder3Years.value,
                                                focusColor: Colors.teal,
                                                activeColor: Colors.green,
                                                onChanged: (bool? newValue) => isBusinessUnder3Years.value = !isBusinessUnder3Years.value,
                                              ),
                                              Expanded(
                                                flex: 8,
                                                child: Text('Business is under 3 years', textScaleFactor: 0.95),
                                              ),
                                            ],
                                          ),
                                          if (isBusinessUnder3Years.value) dobText(context),
                                        ],
                                      );
                                    }),
                                    Row(
                                      children: [
                                        Obx(
                                          () => Checkbox(
                                            value: isCharity.value,
                                            focusColor: Colors.teal,
                                            activeColor: Colors.green,
                                            onChanged: (bool? newValue) => isCharity.value = !isCharity.value,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child: Text('We are a Charity', textScaleFactor: 0.95),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    if (isBusinessUnder3Years.value) equalityFields(),
                                    if (isBusinessUnder3Years.value) SizedBox(height: 15),
                                    ListTile(
                                      contentPadding: const EdgeInsets.only(top: 10, left: 20, bottom: 20),
                                      title: InkWell(
                                        onTap: () => utilService.openLink('https://eatoutroundabout.co.uk/legals/privacy-policy/'),
                                        child: Text(
                                          'To understand more about how we will use your information please see our privacy policy.',
                                          textScaleFactor: 0.95,
                                          maxLines: 4,
                                          style: TextStyle(color: Colors.teal, decoration: TextDecoration.underline),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Obx(
                                          () => Checkbox(
                                            value: tnc.value,
                                            focusColor: Colors.teal,
                                            activeColor: Colors.green,
                                            onChanged: (bool? newValue) => tnc.value = !tnc.value,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child: InkWell(
                                            onTap: () => utilService.openLink(widget.isVenueAccount! ? 'https://eatoutroundabout.co.uk/legals/hospitality-terms-and-conditions/' : 'https://eatoutroundabout.co.uk/legals/purchaser-terms-and-conditions/'),
                                            child: Text('I agree to the ${widget.isVenueAccount! ? 'Venue' : 'Business'} Terms and Conditions', textScaleFactor: 0.95),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (widget.isVenueAccount!)
                                      Row(
                                        children: [
                                          Obx(
                                            () => Checkbox(
                                              value: billing.value,
                                              focusColor: Colors.teal,
                                              activeColor: Colors.green,
                                              onChanged: (bool? newValue) => billing.value = !billing.value,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: InkWell(
                                              onTap: () => utilService.openLink('https://eatoutroundabout.co.uk/legals/self-billing-invoicing-agreement/'),
                                              child: Text('I agree to the terms of Self-Billing Invoicing', textScaleFactor: 0.95),
                                            ),
                                          ),
                                        ],
                                      ),
                                    SizedBox(height: 15),
                                    ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(primaryColor)),
                                      child: Text('Create Account'),
                                      onPressed: () async {
                                        if (!formKey.currentState!.validate()) return showRedAlert('Please fill the necessary details');
                                        if (!tnc.value) return showRedAlert('Please accept the Terms and Conditions to proceed');
                                        if (isBusinessUnder3Years.value) if (dobTEC.text.isEmpty) return showRedAlert('Please enter the date of staring business');
                                        if (telephoneTEC.text.startsWith("0")) telephoneTEC.text = telephoneTEC.text.substring(1, telephoneTEC.text.length);
                                        if (!telephoneTEC.text.startsWith("+44")) telephoneTEC.text = "+44" + telephoneTEC.text;
                                        //if (sex.value == 'Select' || sexAtBirth.value == 'Select' || age.value == 'Select' || ethnicity.value == 'Select' || disabled.value == 'Select' || employed.value == 'Select') return showRedAlert('Please fill the necessary details');
                                        String accountID = Uuid().v1();
                                        Map parameters = {
                                          'accountID': accountID,
                                          'accountAdmin': userController.currentUser.value.userID,
                                          'accountApproved': widget.isVenueAccount! ? false : true,
                                          'bankName': '',
                                          'accountName': companyNameTEC.text,
                                          'industry': industry.value,
                                          'accountNo': '',
                                          'accountSortCode': '',
                                          'companyRegNo': regNoTEC.text,
                                          'accountType': null,
                                          'email': userController.currentUser.value.email,
                                          'isVenueAccount': widget.isVenueAccount,
                                          'noEmployees': int.parse(employeesCountTEC.text),
                                          'orderIDs': [],
                                          'postcode': postCodeTEC.text.replaceAll(" ", "").toLowerCase(),
                                          'streetAddress': buildingNameTEC.text,
                                          'telephone': telephoneTEC.text,
                                          'townCity': townTEC.text,
                                          'isCharity': isCharity.value,
                                          'isBusinessUnder3Years': isBusinessUnder3Years.value,
                                          'businessStartDate': isBusinessUnder3Years.value ? dobTEC.text : null,
                                          'userIDs': [userController.currentUser.value.userID],
                                          'businessType': businessType,
                                          'acceptPrivacyPolicy': true,
                                          'acceptTermsAndConditions': true,
                                          'acceptSelfBillingTerms': true,
                                        };
                                        if (isBusinessUnder3Years.value) {
                                          parameters['sex'] = sex.value;
                                          parameters['sexAtBirth'] = sexAtBirth.value;
                                          parameters['age'] = age.value;
                                          parameters['ethnicity'] = ethnicity.value;
                                          parameters['disabled'] = disabled.value;
                                          parameters['employed'] = employed.value;
                                        }
                                        await cloudFunction(
                                          functionName: 'addAccount',
                                          parameters: parameters,
                                          action: () async {
                                            await firestoreService.updateUser({'accountID': accountID});
                                            Get.back();
                                            Get.defaultDialog(
                                              radius: padding / 2,
                                              titlePadding: const EdgeInsets.all(padding),
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                              barrierDismissible: false,
                                              title: 'Account Created',
                                              content: Text(widget.isVenueAccount! ? 'You can start adding venues after your account is approved. Our team will be in contact within the next 2 working days.' : 'You can access the business features in the Dashboard section'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                      Get.offAll(() => SplashScreen());
                                                    },
                                                    child: const Text('OK'))
                                              ],
                                            );
                                          },
                                        );
                                        //await firestoreService.updateUser({'accountID': accountID});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                    }),
                  ),
                ],
              ),
            ),
          );
      },
    );
  }

  dobText(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 5),
          child: Text(
            'Date of starting business',
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: 45,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(padding / 2)),
            color: Colors.white,
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: DateTimePicker(
              controller: dobTEC,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: 'Select the date',
                isDense: true,
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(Duration(days: 1095)),
              //3 years
              lastDate: DateTime.now(),
              dateLabelText: 'Date',
              onChanged: (val) {
                dobTEC.text = val;
                businessStartDate = DateFormat().parse(val);
                print(val);
              },
              validator: (val) {
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Rx<String> sex = 'Select'.obs, sexAtBirth = 'Select'.obs, age = 'Select'.obs, ethnicity = 'Select'.obs, disabled = 'Select'.obs, employed = 'Select'.obs;

  bool isExpanded = false;

  equalityFields() {
    return Column(
      children: [
        Divider(height: padding),
        SizedBox(height: padding),
        Text('Help us make Eat Out Round About more inclusive', style: TextStyle(fontWeight: FontWeight.bold, color: greenColor)),
        SizedBox(height: padding),
        dropDown('What is your sex?', ['Select', 'Male', 'Female', 'Prefer not to say'], 0),
        dropDown('Is the gender you identify with the same as your sex registered at birth?', ['Select', 'Yes', 'No', 'Prefer not to say'], 1),
        dropDown('How old are you?', ['Select', '18-24', '25-29', '30-34', '35-39', '40-44', '45-49', '50-54', '55-59', '60-64', '65-69', '70+', 'Prefer not to say'], 2),
        dropDown('What is your ethnicity?', ['Select', 'White', 'Mixed', 'Asian', 'African', 'Other', 'Prefer not to say'], 3),
        dropDown('Do you identify as disabled?', ['Select', 'Yes', 'No', 'Prefer not to say'], 4),
        dropDown('Are you employed?', ['Select', 'Yes', 'No', 'Prefer not to say'], 5),
      ],
    );
  }

  dropDown(String title, List items, int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
          child: Text(title),
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide(width: 2, color: Colors.teal.shade400),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 20)),
          isExpanded: true,
          style: TextStyle(color: primaryColor, fontSize: 17),
          value: getValue(i),
          items: items.map((value) {
            return DropdownMenuItem<String>(value: value, child: Text(value, textScaleFactor: 1, style: TextStyle(color: Colors.black)));
          }).toList(),
          onChanged: (value) => setValue(i, value!),
        ),
      ],
    );
  }

  getValue(int i) {
    switch (i) {
      case 0:
        return sex.value;
      case 1:
        return sexAtBirth.value;
      case 2:
        return age.value;
      case 3:
        return ethnicity.value;
      case 4:
        return disabled.value;
      case 5:
        return employed.value;
    }
  }

  setValue(int i, String value) {
    switch (i) {
      case 0:
        return sex.value = value;
      case 1:
        return sexAtBirth.value = value;
      case 2:
        return age.value = value;
      case 3:
        return ethnicity.value = value;
      case 4:
        return disabled.value = value;
      case 5:
        return employed.value = value;
    }
  }
}
