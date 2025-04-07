// class ResponseModel {
//   int? statusCode;
//   String? message;
//   int? success;
//
//   // dynamic data;
//   ResponseModel(this.statusCode, this.message, this.success);
//
//   factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
//     json['status_code']?.toInt(),
//     json['msg']?.toString(),
//     json['success']?.toInt(),
//     // json['result'] ?? json['data'],
//   );
// }

// To parse this JSON data, do
//
//     final responseModel = responseModelFromJson(jsonString);

import 'dart:convert';

ResponseModel responseModelFromJson(String str) =>
    ResponseModel.fromJson(json.decode(str));

String responseModelToJson(ResponseModel data) => json.encode(data.toJson());

class ResponseModel {
  int? statusCode;
  String? msg;
  int? success;
  int? userId;
  int? verified;
  dynamic plan;
  dynamic expiryDate;
  dynamic invoiceDate;
  dynamic invoicePlanName;
  dynamic invoicePlanAmount;
  dynamic data;

  ResponseModel({
    this.statusCode,
    this.msg,
    this.success,
    this.data,
    this.verified,
    this.userId,
    this.plan,
    this.expiryDate,
    this.invoiceDate,
    this.invoicePlanAmount,
    this.invoicePlanName,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    statusCode: json["status_code"],
    msg: json["msg"],
    success: json["success"],
    verified: json["verified"],
    userId: json["user_id"],
    plan: json["current_plan"],
    expiryDate: json["expired_date"],
    invoicePlanName: json["last_invoice_plan_name"],
    invoicePlanAmount: json["last_invoice_plan_amount"],
    invoiceDate: json["last_invoice_date"],
    data:
        json["data"] ??
        json['PINCODES'] ??
        json['DESIGNATION'] ??
        json['JOBS_APP'],
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "msg": msg,
    "success": success,
    "verified": verified,
    "user_id": userId,
    "current_plan": plan,
    "expired_date": expiryDate,
    "last_invoice_date": invoiceDate,
    "last_invoice_plan_amount": invoicePlanAmount,
    "last_invoice_plan_name": invoicePlanName,
    "data": data,
  };
}
