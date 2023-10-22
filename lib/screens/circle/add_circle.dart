import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddCircle extends StatefulWidget {
  @override
  State<AddCircle> createState() => _AddCircleState();
}

class _AddCircleState extends State<AddCircle> {
  final TextEditingController circleNameTEC = TextEditingController();

  final TextEditingController summaryTEC = TextEditingController();

  final TextEditingController descriptionTEC = TextEditingController();

  final TextEditingController aboutTEC = TextEditingController();

  TextEditingController buildingNameTEC = TextEditingController();

  TextEditingController streetTEC = TextEditingController();

  TextEditingController townTEC = TextEditingController();

  TextEditingController postCodeTEC = TextEditingController();

  TextEditingController websiteTEC = TextEditingController();

  TextEditingController fbTEC = TextEditingController();

  TextEditingController instaTEC = TextEditingController();

  TextEditingController twTEC = TextEditingController();

  TextEditingController liTEC = TextEditingController();

  TextEditingController youtubeTEC = TextEditingController();

  int b2b = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'ADD CIRCLE PROFILE'),
          Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CustomTextField(labelColor: Colors.white, validate: true, label: 'Circle Profile Name *', hint: 'Enter Name', controller: circleNameTEC),
                  CustomTextField(validate: true, hint: '\nSummary', label: 'Summary *', textInputType: TextInputType.text, controller: summaryTEC, labelColor: Colors.white, maxLines: 3),
                  CustomTextField(validate: true, hint: '\nDescription', label: 'Description *', textInputType: TextInputType.text, controller: descriptionTEC, labelColor: Colors.white, maxLines: 3),
                  CustomTextField(validate: true, hint: '\nAbout', label: 'About *', textInputType: TextInputType.text, controller: aboutTEC, labelColor: Colors.white, maxLines: 3),
                  CustomTextField(validate: true, hint: 'Building Name', label: 'Building Name *', textInputType: TextInputType.text, controller: buildingNameTEC, labelColor: Colors.white),
                  CustomTextField(validate: true, hint: 'Street', label: 'Street *', textInputType: TextInputType.text, controller: streetTEC, labelColor: Colors.white),
                  CustomTextField(validate: true, hint: 'Town', label: 'Town/City *', textInputType: TextInputType.text, controller: townTEC, labelColor: Colors.white),
                  CustomTextField(validate: true, hint: 'Postcode', label: 'Postcode *', textInputType: TextInputType.text, controller: postCodeTEC, labelColor: Colors.white),
                  CustomTextField(controller: websiteTEC, hint: 'Enter Website Link', label: 'Website Link', textInputType: TextInputType.url, labelColor: Colors.white),
                  CustomTextField(controller: fbTEC, hint: 'Enter Facebook Link', label: 'Facebook Link', textInputType: TextInputType.url, labelColor: Colors.white),
                  CustomTextField(controller: instaTEC, hint: 'Enter Instagram Link', label: 'Instagram Link', textInputType: TextInputType.url, labelColor: Colors.white),
                  CustomTextField(controller: twTEC, hint: 'Enter Twitter Link', label: 'Twitter Link', textInputType: TextInputType.url, labelColor: Colors.white),
                  CustomTextField(controller: liTEC, hint: 'Enter LinkedIn Link', label: 'LinkedIn Link', textInputType: TextInputType.url, labelColor: Colors.white),
                  CustomTextField(controller: youtubeTEC, hint: 'Enter YouTube Link', label: 'YouTube Link', textInputType: TextInputType.url, labelColor: Colors.white),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
                    child: Text('Do you want your circle profile to be visible in app business to business or business to consumer?', style: new TextStyle(color: Colors.white)),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: [
                            Radio(value: 0, groupValue: b2b, onChanged: (value) => setState(() => b2b = value!), fillColor: MaterialStateProperty.all(Colors.white), activeColor: Colors.white),
                            Text('B2B', style: new TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          children: [
                            Radio(value: 1, groupValue: b2b, onChanged: (value) => setState(() => b2b = value!), fillColor: MaterialStateProperty.all(Colors.white), activeColor: Colors.white),
                            Text('B2C', style: new TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: CustomButton(
                      function: () async {
                        final userController = Get.find<UserController>();

                        await cloudFunction(
                            functionName: 'addCircleProfile',
                            parameters: {
                              'circleProfileName': circleNameTEC.text,
                              'circleProfileSummary': summaryTEC.text,
                              'circleProfileDescription': descriptionTEC.text,
                              // 'circleProfileBannerImage': '',
                              // 'industry': string
                              'accountID': userController.currentUser.value.accountID,
                              // 'isCommunity': string
                              'circleProfileID': Uuid().v1(),
                              'streetAddress': streetTEC.text,
                              'townCity': townTEC.text,
                              'postCode': postCodeTEC.text,
                              'facebookLink': fbTEC.text,
                              'linkedInLink': liTEC.text,
                              'instagramLink': instaTEC.text,
                              'twitterLink': twTEC.text,
                              'youtubeLink': youtubeTEC.text,
                              'websiteURL': websiteTEC.text,
                            },
                            action: () => Get.back());
                      },
                      text: 'Create Circle Profile',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
