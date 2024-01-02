// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:core';

ToDayAttendance todayattendanceModelFromJson(String str) =>
    ToDayAttendance.fromJson(json.decode(str));
String todayattendanceModelToJson(ToDayAttendance data) => json.encode(data.toJson());

class ToDayAttendance{
  ToDayAttendance({
    required this.today,
  });

  List<dynamic> today;

  factory ToDayAttendance.fromJson(Map<String, dynamic> json) {
    return ToDayAttendance(

        today: json['today']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'today': jsonEncode(today)
      };
}