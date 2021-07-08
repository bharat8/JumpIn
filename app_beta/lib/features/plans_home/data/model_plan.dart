import 'package:JumpIn/features/user_utilities/data/model_connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Plan {
  int id;
  String category;
  String planTitle;
  String locationName;
  int ageRestriction;
  Map<String, dynamic> creator;
  String privacy; //public plan or private plan
  int locationDistance;
  int totalSpots;
  int entryFee;
  int remainingSpots;
  Timestamp startTime;
  List<ConnectionUser> whoElseGoing;
  DateTime startDate;
  DateTime endDate;
  List<String> photoList;
  static String private = "private";
  static String public = "public";
  Plan(
      {this.id,
      this.planTitle,
      this.locationName,
      this.locationDistance,
      this.totalSpots,
      this.creator,
      this.category,
      this.ageRestriction,
      this.remainingSpots,
      this.whoElseGoing,
      this.startDate,
      this.entryFee,
      this.endDate,
      this.photoList,
      this.startTime,
      this.privacy});

  static Map<String, dynamic> toJson(Plan plan) => {
        'id': plan.id,
        'planTitle': plan.planTitle,
        'category': plan.category,
        'locationName': plan.locationName,
        'totalSpots': plan.totalSpots,
        'ageRestriction': plan.ageRestriction,
        'whoElseGoing': plan.whoElseGoing,
        'startDate': plan.startDate,
        'endDate': plan.endDate,
        'startTime': plan.startTime,
        'privacy': plan.privacy,
        'photoList': plan.photoList,
        'entryFee': plan.entryFee
      };

  static Map<String, dynamic> toJsonWithCreator(Plan plan) => {
        'id': plan.id,
        'planTitle': plan.planTitle,
        'creator': plan.creator,
        'category': plan.category,
        'locationName': plan.locationName,
        'totalSpots': plan.totalSpots,
        'ageRestriction': plan.ageRestriction,
        'whoElseGoing': plan.whoElseGoing,
        'startDate': plan.startDate,
        'endDate': plan.endDate,
        'startTime': plan.startTime,
        'privacy': plan.privacy,
        'photoList': plan.photoList,
        'entryFee': plan.entryFee
      };

  static Plan fromJson(Map<String, dynamic> json) {
    Plan plan = Plan();
    plan.id = json['id'] as int;
    plan.category = json['category'] as String;
    plan.planTitle = json['planTitle'] as String;
    plan.locationName = json['locationName'] as String;
    plan.ageRestriction = json['ageRestriction'] as int;
    plan.creator = json['creator'] as Map<String, dynamic>;
    plan.privacy = json['privacy'] as String;
    plan.totalSpots = json['totalSpots'] as int;
    plan.entryFee = json['entryFee'] as int;
    plan.startTime = json['startTime'] as Timestamp;
    // plan.whoElseGoing =
    //     List<ConnectionUser>.from(json['whoElseGoing'] as Iterable);
    plan.startDate = (json['startDate'] as Timestamp).toDate();
    plan.endDate = (json['endDate'] as Timestamp).toDate();
    plan.photoList = List.from(json['photoList'] as Iterable);

    return plan;
  }
}
