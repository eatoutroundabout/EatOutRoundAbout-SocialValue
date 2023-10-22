import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/account_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  Account? account;
  final loading = true.obs;
  TextEditingController companyNameTEC = TextEditingController();
  TextEditingController buildingNameTEC = TextEditingController();
  TextEditingController townTEC = TextEditingController();
  TextEditingController postCodeTEC = TextEditingController();
  TextEditingController employeesCountTEC = TextEditingController();
  TextEditingController regNoTEC = TextEditingController();
  TextEditingController bankNameTEC = TextEditingController();
  TextEditingController sortCodeTEC = TextEditingController();
  TextEditingController accountNoTEC = TextEditingController();
  TextEditingController telephoneTEC = TextEditingController();
  String businessType = 'Independent Business';
  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    getData();
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  getData() async {
    if (userController.currentUser.value.accountID != null) {
      DocumentSnapshot documentSnapshot = await firestoreService.getMyAccount();
      account = documentSnapshot.data() as Account;
      if (account != null) {
        telephoneTEC.text = '+44';
        companyNameTEC.text = account!.accountName!;
        buildingNameTEC.text = account!.streetAddress!;
        townTEC.text = account!.townCity!;
        postCodeTEC.text = account!.postcode!;
        employeesCountTEC.text = account!.noEmployees.toString();
        businessType = account!.businessType!;
        regNoTEC.text = account!.companyRegNo!;
        bankNameTEC.text = account!.bankName!;
        sortCodeTEC.text = account!.accountSortCode!;
        accountNoTEC.text = account!.accountNo!;
        telephoneTEC.text = account!.telephone!;
        sex.value = account!.sex!;
        sexAtBirth.value = account!.sexAtBirth!;
        age.value = account!.age!;
        ethnicity.value = account!.ethnicity!;
        disabled.value = account!.disabled!;
        employed.value = account!.employed!;
      }
    }
    loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor, centerTitle: true),
      body: Obx(() {
        if (loading.value)
          return LoadingData();
        else
          return Form(
            key: formKey,
            child: Column(
              children: [
                Heading(title: 'ACCOUNT DETAILS'),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(padding),
                    color: appBackground,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(label: 'Company Name *', hint: 'Enter Company Name', controller: companyNameTEC, textInputType: TextInputType.text),
                          CustomTextField(label: 'Building/Street Name *', hint: 'Enter Name', controller: buildingNameTEC, textInputType: TextInputType.text),
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
                          Divider(height: 75),
                          if (account!.isVenueAccount!)
                            Column(
                              children: [
                                Center(child: Text('Bank Details so we can pay you', textScaleFactor: 1.25, style: TextStyle(fontWeight: FontWeight.bold))),
                                CustomTextField(label: 'Bank Name *', hint: 'Enter Bank Name', controller: bankNameTEC, textInputType: TextInputType.name),
                                CustomTextField(label: 'Sort Code *', hint: 'Enter Sort Code', controller: sortCodeTEC, textInputType: TextInputType.name),
                                CustomTextField(label: 'Account Number *', hint: 'Enter Account Number', controller: accountNoTEC, textInputType: TextInputType.name),
                              ],
                            ),
                          Divider(height: 75),
                          equalityFields(),
                          SizedBox(height: 30),
                          CustomButton(
                            color: primaryColor,
                            text: 'Update Details',
                            function: () async {
                              if (!formKey.currentState!.validate()) return showRedAlert('Please fill the necessary details');

                              // if (isExpanded) {
                              //   if (sex.value == 'Select' || sexAtBirth.value == 'Select' || age.value == 'Select' || ethnicity.value == 'Select' || disabled.value == 'Select' || employed.value == 'Select') return showRedAlert('Please fill the necessary details');
                              // }
                              Map parameters = {
                                'accountID': account!.accountID,
                                'accountName': companyNameTEC.text,
                                'bankName': bankNameTEC.text,
                                'accountNo': accountNoTEC.text,
                                'accountSortCode': sortCodeTEC.text,
                                'companyRegNo': regNoTEC.text,
                                'noEmployees': int.parse(employeesCountTEC.text),
                                'postcode': postCodeTEC.text,
                                'streetAddress': buildingNameTEC.text,
                                'telephone': telephoneTEC.text,
                                'townCity': townTEC.text,
                                //'under50PaymentFee': under50.value,
                                'businessType': businessType,
                              };

                              if (isExpanded) {
                                parameters['sex'] = sex.value;
                                parameters['sexAtBirth'] = sexAtBirth.value;
                                parameters['age'] = age.value;
                                parameters['ethnicity'] = ethnicity.value;
                                parameters['disabled'] = disabled.value;
                                parameters['employed'] = employed.value;
                              }

                              await cloudFunction(functionName: 'updateAccount', parameters: parameters, action: () => Get.back());
                            },
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
      }),
    );
  }

  Rx<String> sex = 'Select'.obs, sexAtBirth = 'Select'.obs, age = 'Select'.obs, ethnicity = 'Select'.obs, disabled = 'Select'.obs, employed = 'Select'.obs;
  bool isExpanded = true;

  equalityFields() {
    return Column(
      children: [
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
