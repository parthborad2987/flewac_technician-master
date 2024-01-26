// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:core';

Attendance attendanceModelFromJson(String str) =>
    Attendance.fromJson(json.decode(str));
String attendanceModelToJson(Attendance data) => json.encode(data.toJson());

class Attendance{
  Attendance({
    required this.date,
    required this.punchin,
    required this.punchout,
  });

  String date;
  String punchin;
  String punchout;

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
        date: json['date'],
        punchin: json['punchin'],
        punchout: json['punchout'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'date': jsonEncode(date),
        'punchin': jsonEncode(punchin),
        'punchout': jsonEncode(punchout),
      };

}