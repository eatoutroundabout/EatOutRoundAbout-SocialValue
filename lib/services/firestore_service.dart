import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/account_model.dart';
import 'package:eatoutroundabout/models/badge_model.dart';
import 'package:eatoutroundabout/models/book_table_model.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/community_members_model.dart';
import 'package:eatoutroundabout/models/community_model.dart';
import 'package:eatoutroundabout/models/connection_model.dart';
import 'package:eatoutroundabout/models/conversation_model.dart';
import 'package:eatoutroundabout/models/discount_codes_model.dart';
import 'package:eatoutroundabout/models/event_model.dart';
import 'package:eatoutroundabout/models/favorites_model.dart';
import 'package:eatoutroundabout/models/offer_model.dart';
import 'package:eatoutroundabout/models/post_code_model.dart';
import 'package:eatoutroundabout/models/product_model.dart';
import 'package:eatoutroundabout/models/review_model.dart';
import 'package:eatoutroundabout/models/self_billing_model.dart';
import 'package:eatoutroundabout/models/social_value.dart';
import 'package:eatoutroundabout/models/supplier_model.dart';
import 'package:eatoutroundabout/models/user_vouchers_model.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/models/voucher_campaigns_model.dart';
import 'package:eatoutroundabout/models/voucher_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/utils/preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';


class FirestoreService {
  /* * * * * * * * * * * * * * * * DECLARATION SECTION * * * * * * * * * * * * * * * * */

  final userController = Get.find<UserController>();
  final ref = FirebaseFirestore.instance;
  final accountRef = FirebaseFirestore.instance.collection('accounts').withConverter<Account>(fromFirestore: (snapshots, _) => Account.fromDocument(snapshots.data() as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final badgesRef = FirebaseFirestore.instance.collection('badges').withConverter<Badge>(fromFirestore: (snapshots, _) => Badge.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final venueRef = FirebaseFirestore.instance.collection('venues').withConverter<Venue>(fromFirestore: (snapshots, _) => Venue.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final reviewRef = FirebaseFirestore.instance.collection('reviews').withConverter<Review>(fromFirestore: (snapshots, _) => Review.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final savedRef = FirebaseFirestore.instance.collection('saved').withConverter<Favorite>(fromFirestore: (snapshots, _) => Favorite.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final userRef = FirebaseFirestore.instance.collection('users').withConverter<User>(fromFirestore: (snapshots, _) => User.fromDocument(snapshots.data() as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final voucherRef = FirebaseFirestore.instance.collection('vouchers').withConverter<Voucher>(fromFirestore: (snapshots, _) => Voucher.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final voucherCampaignRef = FirebaseFirestore.instance.collection('voucherCampaigns').withConverter<VoucherCampaign>(fromFirestore: (snapshots, _) => VoucherCampaign.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final userVoucherRef = FirebaseFirestore.instance.collection('userVouchers').withConverter<UserVoucher>(fromFirestore: (snapshots, _) => UserVoucher.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final discountRef = FirebaseFirestore.instance.collection('discountCodes').withConverter<DiscountCode>(fromFirestore: (snapshots, _) => DiscountCode.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final postCodeRef = FirebaseFirestore.instance.collection('postcodeData').withConverter<PostCode>(fromFirestore: (snapshots, _) => PostCode.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final conversationRef = FirebaseFirestore.instance.collection('chats').withConverter<Conversation>(fromFirestore: (snapshots, _) => Conversation.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final communityRef = FirebaseFirestore.instance.collection('community').withConverter<Community>(fromFirestore: (snapshots, _) => Community.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final communityMembersRef = FirebaseFirestore.instance.collection('community_members').withConverter<CommunityMember>(fromFirestore: (snapshots, _) => CommunityMember.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final bookTableRef = FirebaseFirestore.instance.collection('bookings').withConverter<BookTableModel>(fromFirestore: (snapshots, _) => BookTableModel.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final eventRef = FirebaseFirestore.instance.collection('events').withConverter<Event>(fromFirestore: (snapshots, _) => Event.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final productRef = FirebaseFirestore.instance.collection('products').withConverter<Product>(fromFirestore: (snapshots, _) => Product.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final offerRef = FirebaseFirestore.instance.collection('offers').withConverter<Offer>(fromFirestore: (snapshots, _) => Offer.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final selfBillingRef = FirebaseFirestore.instance.collection('selfBillingInvoices').withConverter<SelfBilling>(fromFirestore: (snapshots, _) => SelfBilling.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final supplierRef = FirebaseFirestore.instance.collection('buyingGroupProducts').withConverter<Supplier>(fromFirestore: (snapshots, _) => Supplier.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final connectionRef = FirebaseFirestore.instance.collection('connections').withConverter<Connection>(fromFirestore: (snapshots, _) => Connection.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final businessRef = FirebaseFirestore.instance.collection('businessProfiles').withConverter<BusinessProfile>(fromFirestore: (snapshots, _) => BusinessProfile.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());
  final socialValueRef = FirebaseFirestore.instance.collection('socialValue').withConverter<SocialValue>(fromFirestore: (snapshots, _) => SocialValue.fromDocument(snapshots.data()as Map<String,dynamic>), toFirestore: (doc, _) => doc.toJson());

  /* * * * * * * * * * * * * * * * ACCOUNT SECTION * * * * * * * * * * * * * * * * */

  Query getUnapprovedAccountsQuery() => accountRef.where('accountApproved', isEqualTo: false);

  Future<DocumentSnapshot<Account>> checkIfVerifiedAccount() async => await accountRef.doc(userController.currentUser.value.accountID).get();

  Future<DocumentSnapshot<Account>> getMyAccount() async => await accountRef.doc(userController.currentUser.value.accountID).get();

  Future<QuerySnapshot<SelfBilling>> getInvoicesForAccount() async => await selfBillingRef.where('accountID', isEqualTo: userController.currentUser.value.accountID).orderBy('date', descending: true).get();

  Query<Supplier> getFindSuppliersQuery() => supplierRef.orderBy('createdDate', descending: true);

  Future updateAccount(Account account) async => await accountRef.doc(userController.currentUser.value.accountID).update(account.toJson());

  /* * * * * * * * * * * * * * * * BADGE SECTION * * * * * * * * * * * * * * * * */

  Future<DocumentSnapshot<Badge>> getBadgesCounts() async => await badgesRef.doc(userController.currentUser.value.userID).get();

  Future<void> updateBadgeCounts(Map<String, dynamic> data) async => await badgesRef.doc(userController.currentUser.value.userID).update(data);

  /* * * * * * * * * * * * * * * * VENUE SECTION * * * * * * * * * * * * * * * * */

  Future<QuerySnapshot> getAllVenues() async => venueRef.where('approved', isEqualTo: true).get();

  Query<Venue> getLocalImpactVenues(String laua) => venueRef.where('approved', isEqualTo: true).where('localAuthRestricted', isEqualTo: laua).orderBy('lm3ImpactValue', descending: true);

  Query<Venue> getPopularVenues(String laua) => venueRef.where('approved', isEqualTo: true).where('localAuthRestricted', isEqualTo: laua).orderBy('totalRatingsCount', descending: true);

  Query<Venue> getRatedVenues(String laua) => venueRef.where('approved', isEqualTo: true).where('localAuthRestricted', isEqualTo: laua).orderBy('averageRating', descending: true);

  Query<Venue> getPreTheatreDiningVenues(String laua) => venueRef.where('approved', isEqualTo: true).where('localAuthRestricted', isEqualTo: laua).where('preTheatreDining', isEqualTo: true);

  Future<DocumentSnapshot<Venue>> getVenueByVenueID(String venueID) async => await venueRef.doc(venueID).get();

  Query<Venue> getRestrictedVenues(String name, String value) => venueRef.where(name, isEqualTo: value).where('approved', isEqualTo: true);

  Stream<QuerySnapshot> getStaffForVenue(String venueID) => userRef.where('venueStaff', arrayContains: venueID).snapshots();

  Stream<QuerySnapshot> getVenueAdminForVenue(String venueID) => userRef.where('venueAdmin', arrayContains: venueID).snapshots();

  /* * * * * * * * * * * * * * * * REVIEW SECTION * * * * * * * * * * * * * * * * */

  Future<QuerySnapshot<Review>> getMyReviewForVenue(String venueID) async => await reviewRef.where('venueID', isEqualTo: venueID).where('userID', isEqualTo: userController.currentUser.value.userID).get();

  Stream<QuerySnapshot<Review>> getReviewsForVenue(String venueID, int limit) => reviewRef.where('venueID', isEqualTo: venueID).orderBy('creationDate', descending: true).limit(limit).snapshots();

  /* * * * * * * * * * * * * * * * SAVED SECTION * * * * * * * * * * * * * * * * */

  Future<void> unSaveVenue(String venueID) async => await savedRef.doc(userController.currentUser.value.userID! + '|' + venueID).delete();

  Stream<QuerySnapshot<Favorite>> getSavedVenues(String userID) => savedRef.where('userID', isEqualTo: userID).snapshots();

  Stream<DocumentSnapshot<Favorite>> getVenueSavedStatus(String venueID) => savedRef.doc(userController.currentUser.value.userID! + '|' + venueID).snapshots();

  Future<void> saveVenue(Favorite favorite) async => await savedRef.doc('${userController.currentUser.value.userID}|${favorite.venueID}').set(favorite);

  /* * * * * * * * * * * * * * * * VOUCHER SECTION * * * * * * * * * * * * * * * * */

  Future<DocumentSnapshot<Voucher>> getVoucherByVoucherID(String voucherID) async => await voucherRef.doc(voucherID).get();

  Future<QuerySnapshot> getVoucherByPromoCode(String promoCode) => voucherRef.where('promoCode', isEqualTo: promoCode).get();

  Stream<DocumentSnapshot<Voucher>> getVoucherByVoucherIDStream(String voucherID) => voucherRef.doc(voucherID).snapshots();

  Query<Voucher> getClaimVouchersQuery() => voucherRef.where('userID', arrayContains: userController.currentUser.value.userID).where('definedExpiryDate', isGreaterThanOrEqualTo: Timestamp.now()).orderBy('definedExpiryDate', descending: true);

  Future<QuerySnapshot<DiscountCode>> getDiscountFromDiscountCode(String code) async => await discountRef.where('discountCode', isEqualTo: code).get();

  Query<Voucher> getAccountVouchers() => voucherRef.where('accountID', isEqualTo: userController.currentAccount.value.accountID);

  Future<VoucherCampaign> getVoucherCampaign(String campaignID) async => (( await voucherCampaignRef.where('campaignID', isEqualTo: campaignID).get()).docs[0]).data();

  /* * * * * * * * * * * * * * * * USER VOUCHER SECTION * * * * * * * * * * * * * * * * */

  Future<QuerySnapshot> getVoucherByUniqueID(String redemptionCode) => userVoucherRef.where('voucherRedemptionCode', isEqualTo: redemptionCode).get();

  Stream<QuerySnapshot<UserVoucher>> getMyVouchers() => userVoucherRef.where('userID', isEqualTo: userController.currentUser.value.userID).where('redeemed', isEqualTo: false).where('expiryDate', isGreaterThan: Timestamp.now()).orderBy('expiryDate').orderBy('claimedDate', descending: true).snapshots();

  Stream<QuerySnapshot> getRedeemedVouchers() => userVoucherRef.where('userID', isEqualTo: userController.currentUser.value.userID).where('redeemed', isEqualTo: true).orderBy('redeemedDate', descending: true).snapshots();

  Query<UserVoucher> getMyVouchersQuery(bool redeemed) => userVoucherRef.where('userID', isEqualTo: userController.currentUser.value.userID).where('redeemed', isEqualTo: redeemed).where('expiryDate', isGreaterThan: Timestamp.now()).orderBy('expiryDate').orderBy('claimedDate', descending: true);

  Query<UserVoucher> getRedeemedVouchersQuery() => userVoucherRef.where('userID', isEqualTo: userController.currentUser.value.userID).where('redeemed', isEqualTo: true).orderBy('redeemedDate', descending: true);

  Future<DocumentSnapshot<UserVoucher>> checkIfVoucherClaimed(String voucherID) async => await userVoucherRef.doc(userController.currentUser.value.userID! + "|" + voucherID).get();

  Future<DocumentSnapshot<UserVoucher>> getUserVoucher(String userVoucherDocID) => userVoucherRef.doc(userVoucherDocID).get();

  Future<QuerySnapshot> getUserVouchersForVoucherID(String userID, String voucherID) async => await userVoucherRef.where('userID', isEqualTo: userID).where('voucherID', isEqualTo: voucherID).get();

  Stream<QuerySnapshot<UserVoucher>> getVenueVouchers(String venueID) => userVoucherRef.where('redeemedVenueID', isEqualTo: venueID).orderBy('redeemedDate', descending: true).snapshots();

  Stream<QuerySnapshot<UserVoucher>> getMyRedemptions(String venueID) => userVoucherRef.where('redeemedVenueID', isEqualTo: venueID).where('redeemedVenueUserID', isEqualTo: userController.currentUser.value.userID).orderBy('redeemedDate', descending: true).snapshots();

  Future<QuerySnapshot> getVouchersForBatchNo(String batchNo) async => await userVoucherRef.where('batchNo', isEqualTo: batchNo).where('invoiceAccountID', isEqualTo: userController.currentUser.value.accountID).orderBy('redeemedDate', descending: true).get();

  Future<DocumentSnapshot> getPostCodeData(String postCode) async => await postCodeRef.doc(postCode).get();

  /* * * * * * * * * * * * * * * * USER SECTION * * * * * * * * * * * * * * * * */

  Future<DocumentSnapshot<User>> getUser(id) async => await userRef.doc(id).get();

  Stream<DocumentSnapshot<User>> getUserStream(id) => userRef.doc(id).snapshots();

  Future<QuerySnapshot<User>> getUserViaMobile(String mobile) async => await userRef.where('mobile', isEqualTo: mobile).get();

  Future registerFirebase() async => await cloudFunctionUpdateUser(functionName: 'updateUser', parameters: {'token': await FirebaseMessaging.instance.getToken()}, action: () {});

  Future<User> setCurrentUserViaMobile(String mobile) async => userController.currentUser.value = ((await userRef.where('mobile', isEqualTo: mobile).get()).docs[0]).data();

  Future<User> getCurrentUser() async => userController.currentUser.value = (await userRef.doc(await Preferences.getUser()).get()).data() as User;

  Future<Account> getCurrentAccount() async => userController.currentAccount.value = (await getMyAccount()).data() as Account;

  Future updateUser(Map data) async => await cloudFunctionUpdateUser(functionName: 'updateUser', parameters: data, action: () async => await getCurrentUser());

  Future<void> updateOtherUser(data) async => await cloudFunctionUpdateUser(functionName: 'updateUser', parameters: data, action: () async => await getCurrentUser());

  /* * * * * * * * * * * * * * * * CHAT SECTION * * * * * * * * * * * * * * * * */

  Stream<QuerySnapshot<Conversation>> getConversations() => conversationRef.where('users', arrayContains: userController.currentUser.value.userID).orderBy('lastMessageTime', descending: true).snapshots();

  Stream<QuerySnapshot> getMessages(String chatRoomID) => conversationRef.doc(chatRoomID).collection('messages').orderBy('time').snapshots();

  Future<void> addMessage(String chatRoomID, chatMessageData) async => await conversationRef.doc(chatRoomID).collection('messages').add(chatMessageData).then((value) async => await conversationRef.doc(chatRoomID).update({'lastMessage': chatMessageData['message'], 'lastMessageTime': DateTime.now().millisecondsSinceEpoch}));

  Future<void> createChatRoom(Conversation conversation) async => await conversationRef.doc(conversation.chatRoomID).set(conversation);

  /* * * * * * * * * * * * * * * * COMMUNITY SECTION * * * * * * * * * * * * * * * * */

  Future<void> createCommunity(Community community) async => await communityRef.doc(community.communityID).set(community);

  Future<void> addToCommunity(CommunityMember communityMember) async => await communityMembersRef.doc(communityMember.communityID! + "|" + userController.currentUser.value.userID!).set(communityMember);

  Future<DocumentSnapshot> getCommunityByCommunityID(String communityID) async => communityRef.doc(communityID).get();

  Stream<DocumentSnapshot<Community>> getCommunityByCommunityIDStream(String communityID) => communityRef.doc(communityID).snapshots();

  Stream<DocumentSnapshot<CommunityMember>> checkIfJoinedCommunity(String communityID) => communityMembersRef.doc(communityID + "|" + userController.currentUser.value.userID!).snapshots();

  Stream<QuerySnapshot> searchCommunities(String query) => communityRef.where('nameSearch', arrayContains: query).snapshots();

  Query<Community> searchCommunitiesQuery(String query) => communityRef.where('nameSearch', arrayContains: query).orderBy('communityName');

  Query<Community> getAllCommunitiesQuery() => communityRef.orderBy('communityName');

  Query<CommunityMember> getUserCommunitiesQuery(String query) => communityMembersRef.where('userID', isEqualTo: userController.currentUser.value.userID);

  Query<Community> getMyCommunitiesQuery(String businessProfileID) => communityRef.where('businessProfileID', isEqualTo: businessProfileID);

  Stream<QuerySnapshot> getUserCommunities() => communityMembersRef.where('userID', isEqualTo: userController.currentUser.value.userID).snapshots();

  Future<void> joinCommunity(Community community, CommunityMember communityMember) async => await addToCommunity(communityMember);

  Future approveMember(Community community, String userID) => communityMembersRef.doc(community.communityID! + "|" + userID).update({'approved': true}).then((value) => communityRef.doc(community.communityID).update({'membersCount': FieldValue.increment(1)}).then((value) => showGreenAlert('Request approved')));

  Future rejectMember(Community community, String userID) => communityMembersRef.doc(community.communityID! + "|" + userID).delete().then((value) => showGreenAlert('Request rejected'));

  Future<void> exitCommunity(Community community) async => await communityMembersRef.doc(community.communityID! + "|" + userController.currentUser.value.userID!).delete().then((value) async => await communityRef.doc(community.communityID).update({'membersCount': FieldValue.increment(-1)}).then((value) async => await communityRef.doc(community.communityID).update({
        'admin': FieldValue.arrayRemove([userController.currentUser.value.userID])
      })));

  Future<QuerySnapshot<CommunityMember>> getCommunityMembers(Community community) => communityMembersRef.where('communityID', isEqualTo: community.communityID).where('approved', isEqualTo: true).get();

  Query<CommunityMember> getCommunityMembersQuery(Community community) => communityMembersRef.where('communityID', isEqualTo: community.communityID).where('approved', isEqualTo: true);

  Query<CommunityMember> getCommunityRequestsQuery(Community community) => communityMembersRef.where('communityID', isEqualTo: community.communityID).where('approved', isEqualTo: false);

  Stream<QuerySnapshot<CommunityMember>> getCommunityRequests(Community community) => communityMembersRef.where('communityID', isEqualTo: community.communityID).where('approved', isEqualTo: false).snapshots();

  Future<void> editCommunityInfo(String key, var value, String communityID) async => await communityRef.doc(communityID).update({key: value});

  Future<void> removeCommunityMember(String communityID, String userID) async => await communityRef.doc(communityID + "|" + userID).delete().then((value) async => await communityRef.doc(communityID).update({'membersCount': FieldValue.increment(-1)}));

  Future<void> makeAnAdmin(Community community, userID) async => await communityRef.doc(community.communityID).update({'admin': FieldValue.arrayUnion(community.admin!)});

  /* * * * * * * * * * * * * * * * BOOKING AND EVENT SECTION * * * * * * * * * * * * * * * * */

  Query<BookTableModel> getMyBookings() => bookTableRef.where('userID', isEqualTo: userController.currentUser.value.userID);

  Future<void> addEvent(Event event) async => await eventRef.doc(event.eventID).set(event);

  Future<void> editEvent(Event event) async => await eventRef.doc(event.eventID).update(event.toJson());

  Query<Event> getEvents() => eventRef.where('eventDateTimeTo', isGreaterThanOrEqualTo: Timestamp.now()).orderBy('eventDateTimeTo');

  Query<Event> getMyAttendingEvents() => eventRef.where('attendeeUserIDs', arrayContains: userController.currentUser.value.userID);

  Query<Event> getMyEvents() => eventRef.where('userID', isEqualTo: userController.currentUser.value.userID);

  Future<DocumentSnapshot<Event>> getEventByEventID(String eventID) => eventRef.doc(eventID).get();

  Stream<DocumentSnapshot<Event>> getEventByEventIDStream(String eventID) => eventRef.doc(eventID).snapshots();

  Future<DocumentSnapshot<BookTableModel>> getBookingByBookingID(String eventID) => bookTableRef.doc(eventID).get();

  Future updateEventRequest(BookTableModel event, bool status, String notificationID) async => await eventRef.doc(event.eventID).update({'confirmed': status}).then((value) async => await ref.collection('notifications').doc(notificationID).delete().then((value) => status ? showGreenAlert('Accepted request') : showGreenAlert('Rejected request')));

  /* * * * * * * * * * * * * * * * PRODUCT AND OFFER SECTION * * * * * * * * * * * * * * * * */

  Future<void> addProduct(Product product) async => await productRef.doc(product.productID).set(product);

  Future<void> editProduct(Product product) async => await productRef.doc(product.productID).update(product.toJson());

  Stream<QuerySnapshot<Product>> getProducts(String accountID, int limit) => productRef.where('venues', arrayContains: accountID).orderBy('creationDate', descending: true).limit(limit).snapshots();

  Query getAllProductsQuery() => productRef;

  Query getMyProducts(String businessProfileID) => productRef.where('businessProfileID', isEqualTo: businessProfileID);

  Query getBusinessProductsQuery(String businessProfileID) => productRef.where('businessProfileID', isEqualTo: businessProfileID);

  Future<QuerySnapshot<Product>> getBusinessProducts(String businessProfileID) => productRef.where('businessProfileID', isEqualTo: businessProfileID).get();

  Future<void> updateProductForVenues(Product product) async => await productRef.doc(product.productID).update({'venues': product.venues});

  Future<void> addOffer(Offer offer) async => await offerRef.doc(offer.offerID).set(offer);

  Future<void> editOffer(Offer offer) async => await offerRef.doc(offer.offerID).update(offer.toJson());

  Query getBusinessOffersQuery(String businessProfileID) => offerRef.where('businessProfileID', isEqualTo: businessProfileID);

  Future<QuerySnapshot<Offer>> getBusinessOffers(String businessProfileID) => offerRef.where('businessProfileID', isEqualTo: businessProfileID).get();

  /* * * * * * * * * * * * * * * * POSTCODE SECTION * * * * * * * * * * * * * * * * */

  Future<DocumentSnapshot<PostCode>> getPostCodeDocID(String postCode) async => await postCodeRef.doc(postCode).get();

  Future<DocumentSnapshot> getVenueCoordinates(String postCode) async => await postCodeRef.doc(postCode.toLowerCase().replaceAll(" ", "")).get();

  Future getLAUAForPostcode(String postCode) async => (await getVenueCoordinates(postCode))['laua']?.toUpperCase();

  /* * * * * * * * * * * * * * * * CONNECTION SECTION * * * * * * * * * * * * * * * * */

  Stream<DocumentSnapshot<Connection>> checkIfConnected(id) => connectionRef.doc(userController.currentUser.value.userID).snapshots();

  Future<DocumentSnapshot<Connection>> getUserConnections(String userID) async => connectionRef.doc(userID).get();

  /* * * * * * * * * * * * * * * * BUSINESS SECTION * * * * * * * * * * * * * * * * */

  Query getSocialValue(String businessProfileID) => socialValueRef.where('businessProfileID', isEqualTo: businessProfileID);


  Future<DocumentSnapshot<SocialValue>> getMySocialValueForBusProfile(String businessProfileID) async => await socialValueRef.doc(businessProfileID).get();

  Future<QuerySnapshot<BusinessProfile>> getPoweredBy() => businessRef.where('featured', isEqualTo: true).orderBy('lm3ImpactValue', descending: true).get();

  Future<DocumentSnapshot<BusinessProfile>> getBusinessByBusinessID(String businessID) async => await businessRef.doc(businessID).get();


  Future<void> addBusinessProfile(BusinessProfile businessProfile) async => await businessRef.doc(businessProfile.businessProfileID).set(businessProfile);

  Future<void> editBusinessProfile(BusinessProfile businessProfile) async => await businessRef.doc(businessProfile.businessProfileID).update(businessProfile.toJson());

  Stream<QuerySnapshot> getStaffForBusinessProfile(String businessProfileID) => userRef.where('businessProfileStaff', arrayContains: businessProfileID).snapshots();

  Future<void> addBusinessStaff(String userID, String businessProfileID) async => await userRef.doc(userID).update({
        'businessProfileStaff': FieldValue.arrayUnion([userID])
      });

  Future<void> addBusinessAdmin(String userID, String businessProfileID) async => await userRef.doc(userID).update({
        'businessProfileAdmin': FieldValue.arrayUnion([userID])
      });



  Future<String> checkIfChatRoomExists(String userID) async {
    try {
      bool chatRoomExists = false;
      QuerySnapshot querySnapshot = await conversationRef.where('users', arrayContains: userController.currentUser.value.userID).get();
      if (querySnapshot.docs.isNotEmpty) {
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          if (querySnapshot.docs[i].id.contains(userID)) {
            chatRoomExists = true;
            return querySnapshot.docs[i].id;
          }
        }
        if (!chatRoomExists) {
          await createChatRoom(Conversation(chatRoomID: userController.currentUser.value.userID! + "|" + userID, lastMessage: '', lastMessageTime: DateTime.now().millisecondsSinceEpoch, users: [userController.currentUser.value.userID, userID]));
          return userController.currentUser.value.userID! + "|" + userID;
        } else {
          return '';
        }
      } else {
        await createChatRoom(Conversation(chatRoomID: userController.currentUser.value.userID! + "|" + userID, lastMessage: '', lastMessageTime: DateTime.now().millisecondsSinceEpoch, users: [userController.currentUser.value.userID, userID]));
        return userController.currentUser.value.userID! + "|" + userID;
      }
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getConstants() async => await ref.collection('constants').doc('constants').get();

  Future<bool> updateVersion() async {
    DocumentSnapshot documentSnapshot = await ref.collection('versions').doc('version').get();
    num android = documentSnapshot.get('android');
    num iOS = documentSnapshot.get('iOS');
    if (Platform.isAndroid)
      return ANDROID_VERSION < android;
    else
      return IOS_VERSION < iOS;
  }
}
