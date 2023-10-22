import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/services/authentication_service.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/storage_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController firstNameTEC = TextEditingController();
  TextEditingController lastNameTEC = TextEditingController();
  TextEditingController postCodeTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController mobileTEC = TextEditingController();
  TextEditingController dobTEC = TextEditingController();

  TextEditingController bioTEC = TextEditingController();
  TextEditingController jobTitleTEC = TextEditingController();
  TextEditingController helpYouTEC = TextEditingController();

  final TextEditingController passwordTEC = TextEditingController();
  final TextEditingController confirmTEC = TextEditingController();
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();

  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  final authService = Get.find<AuthService>();
  final storageService = Get.find<StorageService>();
  final utilService = Get.find<UtilService>();
  Rx<File> image = File('').obs;
  Rx<String> jobFunction = 'None'.obs;
  Rx<String> jobLevel = 'None'.obs;

  List jobFunctions = [];
  List jobLevels = [];
  bool isLoading = true;

  @override
  void initState() {
    firstNameTEC.text = userController.currentUser.value.firstName!;
    lastNameTEC.text = userController.currentUser.value.lastName!;
    postCodeTEC.text = userController.currentUser.value.livePostcodeDocId!.toUpperCase();
    emailTEC.text = userController.currentUser.value.email!;
    mobileTEC.text = userController.currentUser.value.mobile!;
    bioTEC.text = userController.currentUser.value.userBio!;
    helpYouTEC.text = userController.currentUser.value.helpYou!;
    jobTitleTEC.text = userController.currentUser.value.jobTitle!;
    jobLevel.value = userController.currentUser.value.jobLevel!;
    jobFunction.value = userController.currentUser.value.jobFunction!;
    String decoded = utf8.decode(base64.decode(userController.currentUser!.value.dob!)); // username:password
    dobTEC.text = decoded;
    getValues();
    super.initState();
  }

  getValues() async {
    DocumentSnapshot doc = await firestoreService.getConstants();
    Map<String, dynamic> snapshot = doc.data() as Map<String,dynamic>;
    jobFunctions = snapshot.containsKey('jobFunctions') ? doc.get('jobFunctions') : ['None'];
    jobLevels = snapshot.containsKey('jobLevel') ? doc.get('jobLevel') : ['None'];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'EDIT PROFILE'),
          Divider(height: 1),
          Expanded(
            child: isLoading
                ? LoadingData()
                : SingleChildScrollView(
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Container(
                        color: appBackground,
                        padding: const EdgeInsets.only(left: padding, right: padding, top: 25, bottom: 25),
                        child: Column(children: [
                          Text('My Details', textScaleFactor: 1.25, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                          SizedBox(height: 15),
                          Obx(
                            () => InkWell(
                              onTap: () async {
                                image.value = await storageService.pickImage();
                                if (image.value == null) image.value = File('');
                              },
                              child: Stack(
                                children: [
                                  CachedImage(
                                    roundedCorners: true,
                                    url: userController.currentUser.value.photoURL ?? '',
                                    imageFile: image.value.path == '' ? null : image.value,
                                    height: MediaQuery.of(context).size.height * 0.25,
                                    circular: false,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.height * 0.25,
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
                          ),
                          CustomTextField(validate: true, hint: 'First Name', label: 'First Name', controller: firstNameTEC),
                          CustomTextField(validate: true, hint: 'Last Name', label: 'Last Name', controller: lastNameTEC),
                          CustomTextField(validate: true, hint: 'Home Postcode', label: 'Home Postcode', controller: postCodeTEC),
                          dobText(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: CustomButton(
                              text: 'Update My Details',
                              function: () async {
                                if (firstNameTEC.text.isNotEmpty && lastNameTEC.text.isNotEmpty && postCodeTEC.text.isNotEmpty) {
                                  utilService.showLoading();
                                  DocumentSnapshot q = await firestoreService.getPostCodeDocID(postCodeTEC.text.replaceAll(" ", "").toLowerCase());
                                  if (q.exists) {
                                    String url = 'profile';
                                    if (image.value.path != '') url = await storageService.uploadImage(image.value);

                                    String encoded = base64.encode(utf8.encode(dobTEC.text));
                                    await cloudFunction(
                                        functionName: 'updateUser',
                                        parameters: {
                                          'userID': userController.currentUser.value.userID,
                                          'firstName': firstNameTEC.text,
                                          'lastName': lastNameTEC.text,
                                          'livePostcodeDocId': postCodeTEC.text.replaceAll(" ", "").toLowerCase(),
                                          'dob': encoded,
                                          'photoURL': url,
                                        },
                                        action: () async {
                                          await firestoreService.getCurrentUser();
                                          Get.back();
                                          showGreenAlert('Updated successfully');
                                        });
                                  } else
                                    showRedAlert('Please enter the correct postcode');
                                  Get.back();
                                } else
                                  showRedAlert('Please enter all the fields');
                              },
                            ),
                          ),
                          Divider(height: 100, color: Colors.grey),
                          Text('Contact Details', textScaleFactor: 1.25, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                          CustomTextField(validate: true, hint: 'Email address', label: 'Email address', controller: emailTEC, isEmail: true),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15, top: 25, bottom: 10),
                                child: Text(
                                  'Mobile Number',
                                  style: TextStyle(color: Colors.teal),
                                ),
                              ),
                              TextFormField(
                                enabled: false,
                                maxLines: 1,
                                style: TextStyle(color: Colors.black),
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: mobileTEC,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 15),
                                  hintText: 'Mobile number',
                                  fillColor: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          CustomButton(
                            text: 'Update Contact Details',
                            function: () async {
                              if (emailTEC.text.isNotEmpty && mobileTEC.text.isNotEmpty) {
                                utilService.showLoading();
                                await firestoreService.updateUser({
                                  'email': emailTEC.text,
                                });
                                Get.back();

                                Get.back();
                              } else
                                showRedAlert('Please enter a valid email and mobile number');
                            },
                          ),
                          Divider(height: 100, color: Colors.grey),
                          Text('More Details', textScaleFactor: 1.25, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                          Column(
                            children: [
                              CustomTextField(controller: jobTitleTEC, label: 'Job Title *', hint: 'Enter title', validate: true),
                              CustomTextField(dropdown: dropDown(jobFunctions, 0), label: 'Job Function *'),
                              CustomTextField(dropdown: dropDown(jobLevels, 1), label: 'Job Level *'),
                              CustomTextField(controller: bioTEC, label: 'My Bio *', maxLines: 4, hint: 'Enter bio', validate: true, textInputType: TextInputType.text),
                              //CustomTextField(controller: industryTEC, label: 'My Industries *', maxLines: 4, hint: 'Enter industries', validate: true, textInputType: TextInputType.text),
                              //CustomTextField(controller: helpYouTEC, label: 'How Can I Help? *', maxLines: 4, hint: 'Enter services', validate: true, textInputType: TextInputType.text),
                              SizedBox(height: 25),
                              CustomButton(
                                function: () async {
                                  if (bioTEC.text.isNotEmpty && jobTitleTEC.text.isNotEmpty) {
                                    utilService.showLoading();
                                    await firestoreService.updateUser({
                                      'jobTitle': jobTitleTEC.text,
                                      'jobLevel': jobLevel.value,
                                      //'helpYou': helpYouTEC.text,
                                      'jobFunction': jobFunction.value,
                                      'userBio': bioTEC.text,
                                    });
                                    await firestoreService.getCurrentUser();

                                    Get.back();
                                  } else
                                    showRedAlert('Please enter all the fields');
                                },
                                text: 'Update Details',
                              ),
                            ],
                          ),
                          // Form(
                          //   key: passwordKey,
                          //   child: Column(
                          //     children: [
                          //       CustomTextField(controller: passwordTEC, label: 'Password *', hint: 'Enter password', validate: true, isPassword: true, textInputType: TextInputType.text),
                          //       CustomTextField(controller: confirmTEC, label: 'Confirm password *', hint: 'Re-enter password', validate: true, isPassword: true, textInputType: TextInputType.text),
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(height: 25),
                          // ElevatedButton(onPressed: () => changePassword(), child: Text('Change Password')),
                        ]),
                      ),
                    ]),
                  ),
          ),
        ],
      ),
    );
  }

  dropDown(List items, int i) {
    return DropdownButtonFormField<String>(
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
    );
  }

  getValue(int i) {
    switch (i) {
      case 0:
        return jobFunction.value;
      case 1:
        return jobLevel.value;
    }
  }

  setValue(int i, String value) {
    switch (i) {
      case 0:
        return jobFunction.value = value;
      case 1:
        return jobLevel.value = value;
    }
  }

  dobText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 25),
          child: Text(
            'Date of birth',
            //style: TextStyle(color: Colors.teal),
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
                hintText: 'Date of birth',
                isDense: true,
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
              initialDate: DateTime(1990),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              dateLabelText: 'Date',
              onChanged: (val) {
                dobTEC.text = val;
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

  changePassword() async {
    if (!passwordKey.currentState!.validate()) {
      showRedAlert('Please fill the necessary details');
      return;
    }
    if (passwordTEC.text != confirmTEC.text) {
      showRedAlert('Passwords do not match');
      return;
    }
    utilService.showLoading();
    authService.changePassword(passwordTEC.text.trim());
  }
}
