// To parse this JSON data, do
//
//     final dashboardKpiResponse = dashboardKpiResponseFromJson(jsonString);

import 'dart:convert';

DashboardKpiResponse dashboardKpiResponseFromJson(String str) => DashboardKpiResponse.fromJson(json.decode(str));

String dashboardKpiResponseToJson(DashboardKpiResponse data) => json.encode(data.toJson());

class DashboardKpiResponse {
  KpiResult? result;
  int? statusCode;
  String? message;
  bool? status;

  DashboardKpiResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory DashboardKpiResponse.fromJson(Map<String, dynamic> json) => DashboardKpiResponse(
    result: json["result"] == null ? null : KpiResult.fromJson(json["result"]),
    statusCode: json["statusCode"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
    "statusCode": statusCode,
    "message": message,
    "status": status,
  };
}

class KpiResult {
  int? totalPassToday;
  int? totalPassMonth;
  int? totalPassYear;
  int? totalPasses;

  KpiResult({
    this.totalPassToday,
    this.totalPassMonth,
    this.totalPassYear,
    this.totalPasses,
  });

  factory KpiResult.fromJson(Map<String, dynamic> json) => KpiResult(
    totalPassToday: json["totalPassToday"],
    totalPassMonth: json["totalPassMonth"],
    totalPassYear: json["totalPassYear"],
    totalPasses: json["totalPasses"],
  );

  Map<String, dynamic> toJson() => {
    "totalPassToday": totalPassToday,
    "totalPassMonth": totalPassMonth,
    "totalPassYear": totalPassYear,
    "totalPasses": totalPasses,
  };
}
