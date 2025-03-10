import 'package:cloud_firestore/cloud_firestore.dart';

class VirtualProduct
{
  String? itemID;
  String? itemName;
  String? itemDescription;
  String? itemImage;
  String? sellerName;
  String? sellerPhone;
  String? itemPrice;
  Timestamp? publishedDate;
  String? status;

  VirtualProduct({
    this.itemID,
    this.itemName,
    this.itemDescription,
    this.itemImage,
    this.sellerName,
    this.sellerPhone,
    this.itemPrice,
    this.publishedDate,
    this.status,
  });

  VirtualProduct.fromJson(Map<String, dynamic> json)
  {
    itemID = json["itemID"];
    itemName = json["itemName"];
    itemDescription = json["itemDescription"];
    itemImage = json["itemImage"];
    sellerName = json["sellerName"];
    sellerPhone = json["sellerPhone"];
    itemPrice = json["itemPrice"];
    publishedDate = json["publishedDate"];
    status = json["status"];
  }
}