import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/account_model.dart';
import 'package:eatoutroundabout/models/users_model.dart' as u;
import 'package:eatoutroundabout/screens/admin/account/add_account.dart';
import 'package:eatoutroundabout/screens/admin/account/approve_accounts.dart';
import 'package:eatoutroundabout/screens/admin/admin_home.dart';
import 'package:eatoutroundabout/screens/admin/business/add_business_profile.dart';
import 'package:eatoutroundabout/screens/auth/login.dart';
import 'package:eatoutroundabout/screens/buy/buy_greetings.dart';
import 'package:eatoutroundabout/screens/circle/circle_home.dart';
import 'package:eatoutroundabout/screens/home/notifications_feed.dart';
import 'package:eatoutroundabout/screens/home/show_venues.dart';
import 'package:eatoutroundabout/screens/messages/conversations.dart';
import 'package:eatoutroundabout/screens/profile/my_impact.dart';
import 'package:eatoutroundabout/screens/profile/profile.dart';
import 'package:eatoutroundabout/screens/vouchers/add_voucher.dart';
import 'package:eatoutroundabout/screens/vouchers/claim_vouchers.dart';
import 'package:eatoutroundabout/screens/vouchers/my_vouchers.dart';
import 'package:eatoutroundabout/services/authentication_service.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/location_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/utils/preferences.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:store_launcher_nullsafe/store_launcher_nullsafe.dart';
//import 'package:store_launcher/store_launcher.dart';

class HomeController extends GetxController {
  var tabIndex = 2;

  changeTabIndex(index) {
    tabIndex = index;
    update();
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final firestoreService = Get.find<FirestoreService>();
  final authService = Get.find<AuthService>();
  final userController = Get.find<UserController>();
  final utilService = Get.find<UtilService>();
  final controller = Get.put(HomeController());

  @override
  void initState() {
    final locationService = Get.find<LocationService>();

    locationService.determinePosition();
    if (showDashboard())
      controller.tabIndex = 2;
    else
      controller.tabIndex = 1;

    Future.delayed(Duration(seconds: 5), () async {
      if (await Preferences.getBusinessPopup())
        utilService.showConfirmationDialog(
            title: 'Own a business?',
            contentText: 'Do you own or run a business?',
            confirm: () async {
              Get.back();
              await Preferences.setBusinessPopup(false);
              await cloudFunctionUpdateUser(
                  functionName: 'updateUser',
                  parameters: {'noBusiness': false},
                  action: () async {
                    if (userController.currentUser.value.accountID != null && userController.currentUser.value.accountID != '') {
                      Get.to(() => AddBusinessProfile());
                    } else
                      addAccount(context, true);
                  });
            },
            cancel: () async {
              Get.back();
              await Preferences.setBusinessPopup(false);
              await cloudFunctionUpdateUser(functionName: 'updateUser', parameters: {'noBusiness': true}, action: () {});
            });
    });
    super.initState();
  }

  getAccountStatus() async {
    final firestoreService = Get.find<FirestoreService>();
    bool isAccountApproved = false;

    utilService.showLoading();

    DocumentSnapshot doc = await firestoreService.getMyAccount();
    if (doc != null) {
      Account account = doc.data() as Account;
      isAccountApproved = account.accountApproved!;
    }
    Get.back();

    return isAccountApproved;
  }

  addAccount(context, isVenueAccount) {
    Get.defaultDialog(
      radius: padding / 2,
      contentPadding: const EdgeInsets.all(padding),
      title: 'Create account?',
      content: Text(
        'To proceed further, you need to create an account. Would you like to create an account now?',
        textAlign: TextAlign.center,
      ),
      actions: [
        CustomButton(
          function: () {
            Get.back();
            Get.to(() => AddAccount(isVenueAccount: false));
          },
          text: 'Yes',
          color: primaryColor,
        ),
        CustomButton(
          function: () => Get.back(),
          text: 'No',
          color: Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (HomeController controller) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(visualDensity: VisualDensity.compact, icon: Icon(Icons.menu), onPressed: () => _scaffoldKey.currentState!.openDrawer()),
                Obx(
                  () => IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(FontAwesomeIcons.comment, size: 20),
                        if (userController.currentUser.value.unreadMessages!) Align(alignment: Alignment.bottomCenter, child: CircleAvatar(radius: 5, backgroundColor: redColor)),
                      ],
                    ),
                    onPressed: () async {
                      Get.to(() => Conversations());
                      userController.currentUser.value.unreadMessages = false;
                      await firestoreService.updateUser({'unreadMessages': false});
                    },
                  ),
                ),
                Expanded(child: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
                Obx(
                  () => IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(child: Icon(Icons.notifications_none_outlined)),
                        if (userController.currentUser.value.unreadNotifications!) Align(alignment: Alignment.bottomCenter, child: CircleAvatar(radius: 5, backgroundColor: redColor)),
                      ],
                    ),
                    onPressed: () async {
                      Get.to(() => NotificationsFeed());
                      userController.currentUser.value.unreadNotifications = false;
                      await firestoreService.updateUser({'unreadNotifications': false});
                    },
                  ),
                ),
                InkWell(
                  onTap: () => addVoucherDialog(),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: redColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.qr_code, color: Colors.white),
                  ),
                ),
                //   IconButton(visualDensity: VisualDensity.compact, icon: Icon(FontAwesomeIcons.comment, size: 20), onPressed: () => Get.to(() => Conversations())),
              ],
            ),
          ),
          drawer: Drawer(
            width: Get.width * 0.8,
            child: Container(
              color: primaryColor,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        InkWell(
                          onLongPress: () {
                            if (FirebaseAuth.instance.currentUser!.phoneNumber == '+447786060113' || FirebaseAuth.instance.currentUser!.phoneNumber == '+448805575606') adminControls(context);
                          },
                          onTap: () => Get.back(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 75),
                            child: Image.asset('assets/images/applogo.png', height: 150),
                          ),
                        ),
                        Divider(color: Colors.white30, height: padding),
                        ListTile(
                          leading: Icon(Icons.verified_user_outlined, color: greenColor),
                          title: Text('My Impact', textScaleFactor: 1.25, style: TextStyle(color: greenColor)),
                          onTap: () async {
                            goto(MyImpact());
                            await firestoreService.updateUser({'unreadBadges': false});
                          },
                          trailing: userController.currentUser.value.unreadBadges! ? Container(width: 10, height: 10, child: CircleAvatar(radius: 4, backgroundColor: greenColor)) : Container(width: 10, height: 10),
                        ),
                        if (FirebaseAuth.instance.currentUser!.phoneNumber == '+447786060113' || FirebaseAuth.instance.currentUser!.phoneNumber == '+448805575606') ListTile(leading: Icon(Icons.dialpad, color: Colors.white), title: Text('Approve Accounts', textScaleFactor: 1.25, style: TextStyle(color: Colors.white)), onTap: () => goto(ApproveAccounts())),
                        Divider(color: Colors.white30, height: padding),
                        //ListTile(leading: Icon(Icons.local_offer_outlined, color: Colors.white), title: Text(getUserType() == 0 ? 'Offers' : 'Staff Offers', textScaleFactor: 1.25, style: TextStyle(color: Colors.white)), onTap: () => goto(Offers(userType: getUserType()))),
                        ListTile(
                          leading: Icon(Icons.qr_code, color: Colors.white),
                          title: Text('Claim Vouchers', textScaleFactor: 1.25, style: TextStyle(color: Colors.white)),
                          onTap: () async {
                            goto(ClaimVouchers());
                            await firestoreService.updateUser({'unreadClaims': false});
                            userController.currentUser.value.unreadClaims = false;
                          },
                        ),
                        Divider(color: Colors.white30, height: padding),
                        // ListTile(leading: Icon(Icons.card_giftcard_outlined, color: Colors.white), title: Text('Send Vouchers', textScaleFactor: 1.25, style: TextStyle(color: Colors.white)), onTap: () => goto(BuyGreetings(venueID: ''))),
                        ListTile(leading: Icon(Icons.dialpad, color: Colors.white), title: Text('Promo Code', textScaleFactor: 1.25, style: TextStyle(color: Colors.white)), onTap: () => utilService.showPromoCodeDialog()),
                        Divider(color: Colors.white30, height: padding),
                        ListTile(
                          leading: Icon(Icons.logout, color: orangeColor),
                          title: Text('Logout', textScaleFactor: 1.25, style: TextStyle(color: orangeColor)),
                          onTap: () => utilService.showLogoutDialog(),
                        ),
                        Divider(color: Colors.white30, height: padding),
                        ListTile(
                          leading: Icon(Icons.delete_forever, color: orangeColor),
                          title: Text('Delete Account', textScaleFactor: 1.25, style: TextStyle(color: orangeColor)),
                          onTap: () => utilService.showConfirmationDialog(
                              title: 'Do you want to delete your account?',
                              contentText: 'This action is irreversible. Your data will be queued for deletion in the next 30 days. You can contact us before 30 days in case you change your mind. Would you like to delete your account now?',
                              confirm: () async {
                                Get.back();
                                await firestoreService.updateUser({'deletionRequestedDate': DateTime.now().toString()});
                                await authService.signOut();
                                Get.offAll(() => Login());
                                showGreenAlert('Your account will be deleted completely in the next 30 days');
                              }),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async => await StoreLauncher.openWithStore('com.eatoutroundabout').then((value) => firestoreService.updateBadgeCounts({'ratedApp': 1})),
                          child: Column(
                            children: [
                              Icon(Icons.star, color: Colors.white),
                              SizedBox(height: 5),
                              Text('Rate', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async => await Share.share('Let’s Eat Out Round About Together. Download the app and have a chance to win £10 off your next meal out. \nhttps://eatoutroundabout.co.uk').then((value) => firestoreService.updateBadgeCounts({'sharedApp': 1})),
                          child: Column(
                            children: [
                              Icon(Icons.share, color: Colors.white),
                              SizedBox(height: 5),
                              Text('Share', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => utilService.openLink('https://wa.me/message/DT4CD67J67LNK1'),
                          child: Column(
                            children: [
                              Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                              SizedBox(height: 5),
                              Text('Help', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              if (showDashboard()) BottomNavigationBarItem(label: 'Admin', icon: Icon(Icons.dashboard, size: MediaQuery.of(context).size.height * 0.020), activeIcon: Icon(Icons.dashboard)),
              BottomNavigationBarItem(label: 'Circle', icon: Icon(Icons.refresh, size: MediaQuery.of(context).size.height * 0.020), activeIcon: Icon(Icons.refresh)),
              BottomNavigationBarItem(label: 'Eat Out', icon: Icon(FontAwesomeIcons.utensils, size: MediaQuery.of(context).size.height * 0.020), activeIcon: Icon(FontAwesomeIcons.utensils)),
              BottomNavigationBarItem(label: 'Vouchers', icon: Icon(FontAwesomeIcons.qrcode, size: MediaQuery.of(context).size.height * 0.020), activeIcon: Icon(FontAwesomeIcons.qrcode)),
              BottomNavigationBarItem(label: 'Me', icon: Icon(Icons.account_circle_outlined, size: MediaQuery.of(context).size.height * 0.020), activeIcon: Icon(Icons.account_circle_outlined)),
            ],
            currentIndex: controller.tabIndex,
            onTap: (demo) => controller.changeTabIndex(demo),
          ),
          body: IndexedStack(
            children: userPages(),
            index: controller.tabIndex,
          ),
        );
      },
    );
  }

  getUserType() {
    if (userController.currentUser.value.venueStaff!.isNotEmpty || userController.currentUser.value.venueAdmin!.isNotEmpty || userController.currentUser.value.businessProfileAdmin!.isNotEmpty || userController.currentUser.value.businessProfileStaff!.isNotEmpty || userController.currentUser.value.accountAdmin!.isNotEmpty)
      return 1;
    else
      return 0;
  }

  userPages() {
    return [
      if (showDashboard()) AdminHome(),
      CircleHome(),
      ShowVenues(),
      MyVouchers(),
      Profile(),
    ];
  }

  showDashboard() {
    if (userController.currentUser.value.accountID != null || userController.currentUser.value.accountAdmin!.length > 0 || userController.currentUser.value.venueAdmin!.length > 0 || userController.currentUser.value.venueStaff!.length > 0 || userController.currentUser.value.businessProfileAdmin!.length > 0) {
      return true;
    } else
      return false;
  }

  goto(Widget widget) {
    Get.back();
    Get.to(() => widget);
  }

  adminControls(BuildContext context) async {
    TextEditingController staffTEC = TextEditingController();
    Get.defaultDialog(
      radius: padding / 2,
      title: 'Login As',
      content: CustomTextField(label: 'Enter Mobile Number', hint: '10 digit mobile number', labelColor: greenColor, controller: staffTEC, maxLines: 1, validate: true, isEmail: false, textInputType: TextInputType.phone),
      actions: [
        CustomButton(
          function: () async {
            Get.back();
            showGreenAlert('Please wait...');
            String mobile = staffTEC.text.trim();
            if (mobile.startsWith("0")) mobile = mobile.substring(1, mobile.length);
            if (!mobile.startsWith("+44")) mobile = "+44" + mobile;
            QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('mobile', isEqualTo: mobile).get();
            if (querySnapshot.docs.isNotEmpty) {
              userController.currentUser.value = u.User.fromDocument(querySnapshot.docs[0].data()as Map<String,Object>);
              await Preferences.setUser(userController.currentUser.value.userID!);
              await firestoreService.getCurrentUser();
              await firestoreService.getCurrentAccount();
              await Preferences.setUserRole(SELECT_ROLE);
              //Get.offAll(() => SplashScreen());
              showRedAlert('You are now logged in as ' + userController.currentUser.value.firstName! + ' ' + userController.currentUser.value.lastName!);
            } else
              showRedAlert('User does not exist. Please check the mobile number');
            Get.back();
          },
          text: 'Login',
          color: primaryColor,
        ),
        CustomButton(text: 'Cancel', color: Colors.grey, function: () => Get.back()),
      ],
    );
  }

  addVoucherDialog() {
    Get.defaultDialog(
      radius: padding / 2,
      title: 'Add a Voucher',
      contentPadding: const EdgeInsets.all(padding),
      content: Center(child: Text('Choose an option to add a voucher to your collection')),
      actions: [
        CustomButton(text: 'Scan a QR Code', color: redColor, function: () => goto(AddVoucher())),
        CustomButton(text: 'Enter a Promo Code', function: () => utilService.showPromoCodeDialog()),
      ],
    );
  }
}
