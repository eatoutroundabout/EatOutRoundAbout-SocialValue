import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String? userID;
  final String? reviewID;
  final String? venueID;
  final String? comment;
  final bool? flagged;
  final num? rating;
  final Timestamp? creationDate;

  Review({
    this.userID,
    this.reviewID,
    this.venueID,
    this.comment,
    this.flagged,
    this.rating,
    this.creationDate,
  });

  factory Review.fromDocument(Map<String, dynamic> doc) {
    try {
      DateTime date = DateTime(2021);
      return Review(
        userID: doc['userID'] as String?? '',
        reviewID: doc['reviewID'] as String?? '',
        venueID: doc['venueID'] as String?? '',
        comment: doc['comment'] as String?? '',
        flagged: doc['flagged'] as bool?? false,
        rating: doc['rating'] as num?? 0,
        creationDate: doc['creationDate'] as Timestamp?? Timestamp.fromDate(date),
      );
    } catch (e) {
      print('****** REVIEW MODEL ******');
      print(e);
      return null!;
    }
  }

  Map<String, Object> toJson() {
    return {
      'userID': userID!,
      'reviewID': reviewID!,
      'venueID': venueID!,
      'comment': comment!,
      'flagged': flagged!,
      'rating': rating!,
      'creationDate': creationDate!,
    };
  }
}
