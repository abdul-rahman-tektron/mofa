// To parse this JSON data, do
//
//     final searchCommentResponse = searchCommentResponseFromJson(jsonString);

import 'dart:convert';

SearchCommentResponse searchCommentResponseFromJson(String str) => SearchCommentResponse.fromJson(json.decode(str));

String searchCommentResponseToJson(SearchCommentResponse data) => json.encode(data.toJson());

class SearchCommentResponse {
  SearchCommentResult? result;
  int? statusCode;
  String? message;
  bool? status;

  SearchCommentResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory SearchCommentResponse.fromJson(Map<String, dynamic> json) => SearchCommentResponse(
    result: json["result"] == null ? null : SearchCommentResult.fromJson(json["result"]),
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

class SearchCommentResult {
  List<SearchCommentData>? data;
  SearchCommentPagination? pagination;

  SearchCommentResult({
    this.data,
    this.pagination,
  });

  factory SearchCommentResult.fromJson(Map<String, dynamic> json) => SearchCommentResult(
    data: json["data"] == null ? [] : List<SearchCommentData>.from(json["data"]!.map((x) => SearchCommentData.fromJson(x))),
    pagination: json["pagination"] == null ? null : SearchCommentPagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class SearchCommentData {
  int? nId;
  int? nAppointmentId;
  int? nRoleId;
  String? sRoleNameEn;
  String? sRoleNameAr;
  int? nUserId;
  String? sUsername;
  int? nCommentType;
  String? sCommentTypeEn;
  String? sCommentTypeAr;
  String? sComment;
  String? sCommentDate;

  SearchCommentData({
    this.nId,
    this.nAppointmentId,
    this.nRoleId,
    this.sRoleNameEn,
    this.sRoleNameAr,
    this.nUserId,
    this.sUsername,
    this.nCommentType,
    this.sCommentTypeEn,
    this.sCommentTypeAr,
    this.sComment,
    this.sCommentDate,
  });

  factory SearchCommentData.fromJson(Map<String, dynamic> json) => SearchCommentData(
    nId: json["n_ID"],
    nAppointmentId: json["n_AppointmentID"],
    nRoleId: json["n_RoleID"],
    sRoleNameEn: json["s_RoleName_En"],
    sRoleNameAr: json["s_RoleName_Ar"],
    nUserId: json["n_UserID"],
    sUsername: json["s_Username"],
    nCommentType: json["n_CommentType"],
    sCommentTypeEn: json["s_CommentType_En"],
    sCommentTypeAr: json["s_CommentType_Ar"],
    sComment: json["s_Comment"],
    sCommentDate: json["s_CommentDate"],
  );

  Map<String, dynamic> toJson() => {
    "n_ID": nId,
    "n_AppointmentID": nAppointmentId,
    "n_RoleID": nRoleId,
    "s_RoleName_En": sRoleNameEn,
    "s_RoleName_Ar": sRoleNameAr,
    "n_UserID": nUserId,
    "s_Username": sUsername,
    "n_CommentType": nCommentType,
    "s_CommentType_En": sCommentTypeEn,
    "s_CommentType_Ar": sCommentTypeAr,
    "s_Comment": sComment,
    "s_CommentDate": sCommentDate,
  };
}

class SearchCommentPagination {
  int? pageNumber;
  int? pageSize;
  int? count;
  int? pages;

  SearchCommentPagination({
    this.pageNumber,
    this.pageSize,
    this.count,
    this.pages,
  });

  factory SearchCommentPagination.fromJson(Map<String, dynamic> json) => SearchCommentPagination(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    count: json["count"],
    pages: json["pages"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "count": count,
    "pages": pages,
  };
}
