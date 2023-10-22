import 'package:eatoutroundabout/models/account_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_list_tile.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ApproveAccounts extends StatefulWidget {
  @override
  State<ApproveAccounts> createState() => _ApproveAccountsState();
}

class _ApproveAccountsState extends State<ApproveAccounts> {
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'APPROVE ACCOUNTS'),
          Expanded(
            child: showAccountsList(),
          ),
        ],
      ),
    );
  }

  showAccountsList() {
    return PaginateFirestore(
      isLive: true,
      key: GlobalKey(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      itemBuilderType: PaginateBuilderType.listView,
      itemBuilder: (context, documentSnapshot, i) {
        Account account = documentSnapshot[i].data() as Account;
        return CustomListTile(
          title: Text(account.accountName!),
          trailing: Text('VIEW', textScaleFactor: 0.8, style: TextStyle(color: greenColor)),
          onTap: () {
            final dialogService = Get.find<UtilService>();

            Get.defaultDialog(
              radius: padding / 2,
              title: 'Account Information',
              content: Text(
                'Company Name:${account.accountName}\n\n' + 'Building Name:${account.streetAddress}\n\n' + 'Town:${account.townCity}\n\n' + 'PostCode:${account.postcode}\n\n' + 'Telephone Number:${account.telephone}\n\n' + 'Employees Count:${account.noEmployees}\n\n' + 'BusinessType: ${account.businessType}\n\n' + 'RegNo:${account.companyRegNo};',
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      Get.back();
                      dialogService.showLoading();
                      await cloudFunction(functionName: 'approveAccount', parameters: {'accountID': account.accountID}, action: () => Get.back());
                    },
                    child: Text('APPROVE')),
                TextButton(
                    onPressed: () async {
                      Get.back();
                    },
                    child: Text('CANCEL', style: TextStyle(color: Colors.grey))),
              ],
            );
          },
        );
      },
      query: firestoreService.getUnapprovedAccountsQuery(),
      onEmpty: EmptyBox(text: 'No accounts to show'),
      itemsPerPage: 10,
      bottomLoader: LoadingData(),
      initialLoader: LoadingData(),
    );
  }
}
