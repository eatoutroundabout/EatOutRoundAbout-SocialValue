import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecommendVenue extends StatelessWidget {
  final TextEditingController emailTEC = TextEditingController();
  //final TextEditingController mobileTEC = TextEditingController();
  final TextEditingController venueNameTEC = TextEditingController();
  //final TextEditingController contactNameTEC = TextEditingController();
  final TextEditingController websiteTEC = TextEditingController();
  final userController = Get.find<UserController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orangeColor,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'RECOMMEND A VENUE'),
          Expanded(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  children: [
                    CustomTextField(labelColor: Colors.white, validate: true, label: 'Venue Name *', hint: 'Enter Name', controller: venueNameTEC),
                    //CustomTextField(labelColor: Colors.white, controller: emailTEC, label: 'Venue Email Address', hint: 'Enter email address', textInputType: TextInputType.emailAddress),
                    CustomTextField(labelColor: Colors.white, controller: websiteTEC, label: 'Venue Website *', hint: 'Enter website', validate: true, textInputType: TextInputType.url),
                    // CustomTextField(
                    //     labelColor: Colors.white,
                    //     controller: mobileTEC,
                    //     label: 'Venue Mobile Number *',
                    //     hint: 'Enter mobile number',
                    //     validate: true,
                    //     textInputType: TextInputType.phone),
                    // CustomTextField(
                    //     labelColor: Colors.white,
                    //     controller: contactNameTEC,
                    //     label: 'Venue Contact Name *',
                    //     hint: 'Enter name',
                    //     validate: true,
                    //     textInputType: TextInputType.name),
                    SizedBox(height: 25),
                    CustomButton(
                      color: primaryColor,
                      function: () async {
                        if (!formKey.currentState!.validate()) {
                          showRedAlert('Please fill the necessary details');
                          return;
                        }

                        await cloudFunction(
                            functionName: 'recommendVenue',
                            parameters: {
                              'userID': userController.currentUser.value.userID,
                              'venueName': venueNameTEC.text,
                              'email': '',
                              'mobile': 'N/A', //mobileTEC.text,
                              'website': websiteTEC.text,
                              'contactName': 'N/A', //contactNameTEC.text,
                            },
                            action: () => Get.back());
                      },
                      text: 'Recommend',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
