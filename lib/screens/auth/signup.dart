import 'package:cloud_functions/cloud_functions.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/screens/auth/login.dart';
import 'package:eatoutroundabout/screens/auth/verify_login.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  final User? user;

  SignUp({this.user});

  final TextEditingController firstNameTEC = TextEditingController();
  final TextEditingController lastNameTEC = TextEditingController();
  final TextEditingController postCodeTEC = TextEditingController();
  final TextEditingController emailTEC = TextEditingController();
  final TextEditingController mobileTEC = TextEditingController();
  final TextEditingController promoCodeTEC = TextEditingController();
  final checkTnC = false.obs;
  final preferences = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 25),
                Center(
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset('assets/images/logo.png', width: Get.width / 2, fit: BoxFit.contain, height: MediaQuery.of(context).size.height * 0.2),
                  ),
                ),
                SizedBox(height: 15),
                Center(child: Text('REGISTRATION', textScaleFactor: 2, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontFamily: 'Font1'))),
                SizedBox(height: 15),
                Center(child: Text('Please fill in all the fields', style: TextStyle(color: orangeColor))),
                Row(
                  children: [
                    Expanded(child: CustomTextField(controller: firstNameTEC, label: 'First Name *', hint: 'First Name', validate: true)),
                    SizedBox(width: 15),
                    Expanded(child: CustomTextField(controller: lastNameTEC, label: 'Last Name *', hint: 'Last Name', validate: true)),
                  ],
                ),
                CustomTextField(controller: mobileTEC, label: 'Mobile Number *', hint: 'Enter mobile number', validate: true, textInputType: TextInputType.phone),
                CustomTextField(controller: emailTEC, label: 'Email Address *', hint: 'Enter email address', validate: true, isEmail: true, textInputType: TextInputType.emailAddress),
                CustomTextField(controller: postCodeTEC, label: 'Home Postcode *', hint: 'Enter Postcode', validate: true),
                CustomTextField(controller: promoCodeTEC, label: 'Promo Code', hint: 'Enter promo code'),
                Obx(() {
                  return CheckboxListTile(
                    contentPadding: const EdgeInsets.only(top: 20),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: InkWell(
                      onTap: () => utilService.openLink('https://eatoutroundabout.co.uk/legals/app-terms-and-conditions/'),
                      child: Text(
                        'I accept the Terms & Conditions of use of this app',
                        textScaleFactor: 0.95,
                        maxLines: 2,
                        style: TextStyle(color: Colors.teal, decoration: TextDecoration.underline),
                      ),
                    ),
                    value: checkTnC.value,
                    onChanged: (bool? value) {
                      checkTnC.value = value!;
                    },
                  );
                }),
                Obx(() {
                  return CheckboxListTile(
                    contentPadding: const EdgeInsets.only(top: 10),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      'I have special dietary preferences, allergies or intolerances',
                      textScaleFactor: 0.95,
                      maxLines: 4,
                      style: TextStyle(color: Colors.teal),
                    ),
                    value: preferences.value,
                    onChanged: (bool? value) {
                      preferences.value = value!;
                    },
                  );
                }),
                ListTile(
                  contentPadding: const EdgeInsets.only(top: 10, bottom: 20),
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
                CustomButton(function: () => signUp(), text: 'Sign Up'),
                SizedBox(height: 15),
                TextButton(onPressed: () => Get.offAll(() => Login()), child: Text('I already have an account')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signUp() async {
    if (!formKey.currentState!.validate()) {
      showRedAlert('Please fill the necessary details');
      return;
    }
    if (!checkTnC.value) {
      showRedAlert('Please accept the terms and conditions to continue');
      return;
    }
    if (mobileTEC.text.startsWith("0")) mobileTEC.text = mobileTEC.text.substring(1, mobileTEC.text.length).trim();
    if (!mobileTEC.text.startsWith("+44")) mobileTEC.text = "+44" + mobileTEC.text.trim();
    mobileTEC.text = mobileTEC.text.replaceAll(" ", "");

    HttpsCallableResult? result = await cloudFunctionValueReturn(functionName: 'checkRegistration', parameters: {
      'mobile': mobileTEC.text,
      'email': emailTEC.text.trim(),
      'postCode': postCodeTEC.text.trim(),
      'promoCode': promoCodeTEC.text.trim(),
    });
    if (!result!.data!['success'])
      showRedAlert(result.data!['message']);
    else
      Get.to(() => VerifyLogin(
            preferences: preferences.value,
            user: User(
              email: emailTEC.text,
              firstName: firstNameTEC.text,
              lastName: lastNameTEC.text,
              livePostcodeDocId: postCodeTEC.text.replaceAll(" ", "").toLowerCase(),
              mobile: mobileTEC.text,
              usedPromoCodes: promoCodeTEC.text.isEmpty ? [] : [promoCodeTEC.text],
            ),
          ));
  }
}
