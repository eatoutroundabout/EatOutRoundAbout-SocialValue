import 'package:cloud_firestore/cloud_firestore.dart';

class SocialValue {
  String? businessProfileID;
  num? un1poverty;
  num? un2hunger;
  num? un3wellbeing;
  num? un4education;
  num? un5genderFounder;
  num? un5genderSchools;
  num? un8economicJobs;
  num? un8economicMultiplierX;
  num? in8economicIndependent;
  num? un8economicMultiplierValue;
  num? un9innovation;
  num? un10inequalities;
  num? un11citiesValue;
  num? un11LocalTowns;
  num? un12Consumption;
  num? un13ClimateAction;
  num? un14BelowWater;
  num? un15LifeOnGround;
  num? un17partnerships;
  num? ukT1covid;
  num? ukT2economicInd;
  num? ukT2economicFem;
  num? ukT3climate;
  num? ukT4equalOp;
  num? ukT5wellBeing;
  num? economicImpactMultiplier;
  num? economicImpactValue;

  SocialValue({
    this.businessProfileID,
    this.un1poverty,
    this.un2hunger,
    this.un3wellbeing,
    this.un4education,
    this.un5genderFounder,
    this.un5genderSchools,
    this.un8economicJobs,
    this.un8economicMultiplierX,
    this.in8economicIndependent,
    this.un8economicMultiplierValue,
    this.un9innovation,
    this.un10inequalities,
    this.un11citiesValue,
    this.un11LocalTowns,
    this.un12Consumption,
    this.un13ClimateAction,
    this.un14BelowWater,
    this.un15LifeOnGround,
    this.un17partnerships,
    this.ukT1covid,
    this.ukT2economicInd,
    this.ukT2economicFem,
    this.ukT3climate,
    this.ukT4equalOp,
    this.ukT5wellBeing,
    this.economicImpactMultiplier,
    this.economicImpactValue,
  });

  factory SocialValue.fromDocument(Map<String, dynamic> doc) {
    return SocialValue(
      businessProfileID: doc['businessProfileID'] ?? '',
      un1poverty: doc['un1poverty'] ?? '',
      un2hunger: doc['un1poverty'] ?? '',
      un3wellbeing: doc['un1poverty'] ?? '',
      un4education: doc['un1poverty'] ?? '',
      un5genderFounder: doc['un1poverty'] ?? '',
      un5genderSchools: doc['un1poverty'] ?? '',
      un8economicJobs: doc['un1poverty'] ?? '',
      un8economicMultiplierX: doc['un1poverty'] ?? '',
      in8economicIndependent: doc['un1poverty'] ?? '',
      un8economicMultiplierValue: doc['un1poverty'] ?? '',
      un9innovation: doc['un1poverty'] ?? '',
      un10inequalities: doc['un1poverty'] ?? '',
      un11citiesValue: doc['un1poverty'] ?? '',
      un11LocalTowns: doc['un1poverty'] ?? '',
      un12Consumption: doc['un1poverty'] ?? '',
      un13ClimateAction: doc['un1poverty'] ?? '',
      un14BelowWater: doc['un1poverty'] ?? '',
      un15LifeOnGround: doc['un1poverty'] ?? '',
      un17partnerships: doc['un1poverty'] ?? '',
      ukT1covid:doc['ukT1covid'] ?? '',
      ukT2economicInd:doc['ukT2economicInd'] ?? '',
      ukT2economicFem:doc['ukT2economicFem'] ?? '',
      ukT3climate:doc['ukT3climate'] ?? '',
      ukT4equalOp:doc['ukT4equalOp'] ?? '',
      ukT5wellBeing:doc['ukT5wellBeing'] ?? '',
      economicImpactMultiplier:doc['economicImpactMultiplier'] ?? '',
      economicImpactValue:doc['economicImpactValue'] ?? '',
    );
    try {
      return SocialValue(
        businessProfileID: doc['businessProfileID'] ?? '',
        un1poverty: doc['un1poverty'] ?? '',
        un2hunger: doc['un1poverty'] ?? '',
        un3wellbeing: doc['un1poverty'] ?? '',
        un4education: doc['un1poverty'] ?? '',
        un5genderFounder: doc['un1poverty'] ?? '',
        un5genderSchools: doc['un1poverty'] ?? '',
        un8economicJobs: doc['un1poverty'] ?? '',
        un8economicMultiplierX: doc['un1poverty'] ?? '',
        in8economicIndependent: doc['un1poverty'] ?? '',
        un8economicMultiplierValue: doc['un1poverty'] ?? '',
        un9innovation: doc['un1poverty'] ?? '',
        un10inequalities: doc['un1poverty'] ?? '',
        un11citiesValue: doc['un1poverty'] ?? '',
        un11LocalTowns: doc['un1poverty'] ?? '',
        un12Consumption: doc['un1poverty'] ?? '',
        un13ClimateAction: doc['un1poverty'] ?? '',
        un14BelowWater: doc['un1poverty'] ?? '',
        un15LifeOnGround: doc['un1poverty'] ?? '',
        un17partnerships: doc['un1poverty'] ?? '',
        ukT1covid:doc['ukT1covid'] ?? '',
        ukT2economicInd:doc['ukT2economicInd'] ?? '',
        ukT2economicFem:doc['ukT2economicFem'] ?? '',
        ukT3climate:doc['ukT3climate'] ?? '',
        ukT4equalOp:doc['ukT4equalOp'] ?? '',
        ukT5wellBeing:doc['ukT5wellBeing'] ?? '',
        economicImpactMultiplier:doc['economicImpactMultiplier'] ?? '',
        economicImpactValue:doc['economicImpactValue'] ?? '',
      );
    } catch (e) {
      print(e);
      return null!;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'businessProfileID':businessProfileID,
      'un1poverty':un1poverty,
      'un2hunger':un2hunger,
      'un3wellbeing':un3wellbeing,
      'un4education':un4education,
      'un5genderFounder':un5genderFounder,
      'un5genderSchools':un5genderSchools,
      'un8economicJobs':un8economicJobs,
      'un8economicMultiplierX':un8economicMultiplierX,
      'in8economicIndependent':in8economicIndependent,
      'un8economicMultiplierValue':un8economicMultiplierValue,
      'un9innovation':un9innovation,
      'un10inequalities':un10inequalities,
      'un11citiesValue':un11citiesValue,
      'un11LocalTowns':un11LocalTowns,
      'un12Consumption':un12Consumption,
      'un13ClimateAction':un13ClimateAction,
      'un14BelowWater':un14BelowWater,
      'un15LifeOnGround':un15LifeOnGround,
      'un17partnerships':un17partnerships,
      'ukT1covid':ukT1covid,
      'ukT2economicInd':ukT2economicInd,
      'ukT2economicFem':ukT2economicFem,
      'ukT3climate':ukT3climate,
      'ukT4equalOp':ukT4equalOp,
      'ukT5wellBeing':ukT5wellBeing,
      'economicImpactMultiplier':economicImpactMultiplier,
      'economicImpactValue':economicImpactValue,
    };
  }
}