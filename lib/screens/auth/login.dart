import 'package:cloud_functions/cloud_functions.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/screens/auth/signup.dart';
import 'package:eatoutroundabout/screens/auth/verify_login.dart';
import 'package:eatoutroundabout/services/authentication_service.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  final GlobalKey<FormState> mobileLoginKey = GlobalKey<FormState>();
  final GlobalKey<FormState> emailLoginKey = GlobalKey<FormState>();
  final TextEditingController mobileTEC = TextEditingController();
  final authService = Get.find<AuthService>();
  final firestoreService = Get.find<FirestoreService>();
  String userType = 'Select';
  final TextEditingController passwordTEC = TextEditingController();
  final TextEditingController emailTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(systemOverlayStyle: SystemUiOverlayStyle.dark, backgroundColor: Colors.transparent),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: Get.width/2,
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Center(child: Text('LOGIN', textScaleFactor: 2, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontFamily: 'Font1'))),
              mobileLogin(),
              TextButton(onPressed: () => Get.offAll(() => SignUp()), child: Text('Create an account')),
            ],
          ),
        ),
      ),
    );
  }

  mobileLogin() {
    return Form(
      key: mobileLoginKey,
      child: Column(
        children: [
          CustomTextField(controller: mobileTEC, label: 'Mobile Number *', hint: 'Enter mobile number', validate: true, textInputType: TextInputType.phone),
          SizedBox(height: 25),
          CustomButton(function: () => login(), text: 'Login'),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  emailLogin() {
    return Form(
      key: emailLoginKey,
      child: Column(
        children: [
          CustomTextField(controller: emailTEC, label: 'Email Address *', hint: 'Enter email address', validate: true, isEmail: true, textInputType: TextInputType.emailAddress),
          CustomTextField(controller: passwordTEC, label: 'Password *', hint: 'Enter password', validate: true, isPassword: true, textInputType: TextInputType.text),
          SizedBox(height: 25),
          ElevatedButton(onPressed: () => login(), child: Text('Login')),
          SizedBox(height: 15),
          TextButton(
              onPressed: () async {
                if (emailTEC.text.isNotEmpty)
                  await authService.resetPassword(emailTEC.text.trim());
                else
                  showRedAlert('Please enter your email');
              },
              child: Text('Forgot Password')),
        ],
      ),
    );
  }

  login() async {
    if (!mobileLoginKey.currentState!.validate()) {
      showRedAlert('Please fill the necessary details');
      return;
    }
    if (mobileTEC.text.startsWith("0")) mobileTEC.text = mobileTEC.text.substring(1, mobileTEC.text.length).trim();
    if (!mobileTEC.text.startsWith("+44")) mobileTEC.text = "+44" + mobileTEC.text.trim();
    mobileTEC.text = mobileTEC.text.replaceAll(" ", "");

    HttpsCallableResult? result = await cloudFunctionValueReturn(functionName: 'appLogin', parameters: {'mobile': mobileTEC.text});
    if (result!.data['success'])
      Get.to(() => VerifyLogin(user: User(mobile: mobileTEC.text.trim())));
    else
      showRedAlert('User does not exist with this mobile number. Please create an account.');
  }
}
