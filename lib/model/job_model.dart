// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:core';

Job jobModelFromJson(String str) =>
    Job.fromJson(json.decode(str));
String jobModelToJson(Job data) => json.encode(data.toJson());

class Job{
  Job({
    required this.id,
    required this.cname,
    required this.site_adr,
    required this.mobile,
    required this.phone,
    required this.remark,
    required this.payment,
    required this.items,
    required this.status
  });

  String id;
  String cname;
  String site_adr;
  String mobile;
  String phone;
  String remark;
  String payment;
  List<dynamic> items;
  int status;

  factory Job.fromJson(Map<String, dynamic> json) {
   return Job(
        id: json['id'].toString(),
        cname: json['cname'],
        site_adr: json['site_adr'],
        mobile: json['mobile'],
        phone: json['phone'],
        remark: json['remark'],
        payment: json['payment'],
        items: json['items'],
        status: json['status']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'cname': jsonEncode(cname),
        'site_adr': jsonEncode(site_adr),
        'mobile': jsonEncode(mobile),
        'phone': jsonEncode(phone),
        'remark': jsonEncode(remark),
        'payment': jsonEncode(payment),
        'items' : jsonEncode(items),
        'status': jsonEncode(status)
      };
}