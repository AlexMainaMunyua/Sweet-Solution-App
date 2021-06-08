import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String? title;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? productId;
  int? discount;
  String? longDescription;
  String? status;
  int? price;

  ItemModel({
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.productId,
    this.thumbnailUrl,
    this.discount,
    this.longDescription,
    this.status,
  });

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    productId = json['productId'];
    status = json['status'];
    discount = json['discount'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['shortInfo'] = this.shortInfo;
    data['price'] = this.price;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['productId'] = this.productId;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['discount'] = this.discount;
    data['longDescription'] = this.longDescription;
    data['status'] = this.status;
    return data;
  }
}

class PublishedDate {
  String? date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
