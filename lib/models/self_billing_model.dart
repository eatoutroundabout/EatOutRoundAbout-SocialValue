import 'package:cloud_firestore/cloud_firestore.dart';

class SelfBilling {
  final String? accountID;
  final String? batchNumber;
  final num? invoiceRef;
  final bool? paid;
  final num? total;
  final vat;
  final Timestamp? date;

  SelfBilling({
    this.accountID,
    this.batchNumber,
    this.invoiceRef,
    this.paid,
    this.total,
    this.vat,
    this.date,
  });

  factory SelfBilling.fromDocument(Map<String, dynamic> doc) {
    try {
      DateTime date = DateTime(2021);
      return SelfBilling(
        accountID: doc['accountID'] as String?? '',
        batchNumber: doc['batchNumber'] as String?? '',
        invoiceRef: doc['invoiceRef'] as num?? 0,
        paid: doc['paid'] as bool?? false,
        total: doc['total'] as  num?? 0,
        vat: doc['vat'] ?? null,
        date: doc['date'] as Timestamp?? Timestamp.fromDate(date),
      );
    } catch (e) {
      print('****** SELF BILLING MODEL ******');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'accountID': accountID!,
      'batchNumber': batchNumber!,
      'invoiceRef': invoiceRef!,
      'paid': paid!,
      'total': total!,
      'vat': vat,
      'date': date!,
    };
  }
}
