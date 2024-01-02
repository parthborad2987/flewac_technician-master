// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:core';

import 'package:flewac_technician/jobs/job_review.dart';

Jobreview todayattendanceModelFromJson(String str) =>
    Jobreview.fromJson(json.decode(str));
String todayattendanceModelToJson(Jobreview data) => json.encode(data.toJson());

class Jobreview{
  Jobreview({
    required this.id,
    required this.cname,
    required this.site_adr,
    required this.problem,
    required this.technician,
    required this.helper,
    required this.start_at,
    required this.end_at,
    required this.resolve,
    required this.payment,
    required this.review,
    required this.signature,
    required this.apic,
    required this.dpic,
  });

  String id;
  String cname;
  String site_adr;
  String problem;
  String technician;
  String helper;
  String start_at;
  String end_at;
  String resolve;
  String payment;
  String review;
  String signature;
  String apic;
  String dpic;

  factory Jobreview.fromJson(Map<String, dynamic> json) {
    return Jobreview(
      id: json['id'],
      cname: json['cname'],
      site_adr: json['site_adr'],
      problem: json['problem'],
      technician: json['technician'],
      helper: json['helper'],
      start_at: json['start_at'],
      end_at: json['end_at'],
      resolve: json['resolve'],
      payment: json['payment'],
      review: json['review'],
      signature: json['signature'],
      apic: json['apic'],
      dpic: json['dpic'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': jsonEncode(id),
        'cname': jsonEncode(cname),
        'site_adr': jsonEncode(site_adr),
        'problem': jsonEncode(problem),
        'technician': jsonEncode(technician),
        'helper': jsonEncode(helper),
        'start_at': jsonEncode(start_at),
        'end_at': jsonEncode(end_at),
        'resolve': jsonEncode(resolve),
        'payment': jsonEncode(payment),
        'review': jsonEncode(review),
        'signature': jsonEncode(signature),
        'apic': jsonEncode(apic),
        'dpic': jsonEncode(dpic),
      };
}