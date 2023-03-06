import 'dart:io';

import 'package:equatable/equatable.dart';
import 'dart:convert';

class CsvDecoder {
  List<TimeLog> parse(String path) {
    final content = File(path).readAsStringSync();
    final lines = LineSplitter().convert(content);
    final headers = lines.first.split(';');
    final data = lines.skip(1).map((line) => line.split(';'));
    return data
        .map((row) => TimeLog(
              id: parseId(row[7]),
              name: parseName(row[7]),
              hours: parseHours(row[13]),
            ))
        .toList();
  }
}

//remove all non numeric characters and parse int
int parseId(String str) {
  str = str.split(': ').first;
  return int.parse(str.replaceAll(RegExp(r'[^0-9]'), ''));
}

//split by ": "  and get last part
String parseName(String str) {
  return str.split(": ").last;
}

double parseHours(String str) {
  str = str.replaceAll(',', '.');
  return double.parse(str);
}

class TimeLog extends Equatable {
  final int id;
  final String name;
  final double hours;
  TimeLog({
    required this.id,
    required this.name,
    required this.hours,
  });

  @override
  List<Object?> get props => [id, name, hours];

  TimeLog copyWith({
    int? id,
    String? name,
    double? hours,
  }) {
    return TimeLog(
      id: id ?? this.id,
      name: name ?? this.name,
      hours: hours ?? this.hours,
    );
  }

  @override
  String toString() {
    return 'TimeLog(id: $id, name: $name, hours: $hours)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'hours': hours,
    };
  }

  factory TimeLog.fromMap(Map<String, dynamic> map) {
    return TimeLog(
      id: map['id'] as int,
      name: map['name'] as String,
      hours: map['hours'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeLog.fromJson(String source) =>
      TimeLog.fromMap(json.decode(source) as Map<String, dynamic>);
}
