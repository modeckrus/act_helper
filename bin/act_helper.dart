// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:act_helper/act_helper.dart';

void main(List<String> arguments) {
  final CsvDecoder csvDecoder = CsvDecoder();
  var timeLogs = csvDecoder.parse('in.csv');
  final map = <int, TimeLog>{};
  for (final timeLog in timeLogs) {
    if (map.containsKey(timeLog.id)) {
      final existingTimeLog = map[timeLog.id]!;
      final newTimeLog = existingTimeLog.copyWith(
          hours: existingTimeLog.hours + timeLog.hours);
      map[timeLog.id] = newTimeLog;
    } else {
      map[timeLog.id] = timeLog;
    }
  }
  timeLogs = map.values.toList();
  // print(jsonEncode(timeLogs.map((e) => e.toMap()).toList()));
  final totalHours = timeLogs.fold<double>(
      0, (previousValue, element) => previousValue + element.hours);
  final totalPay = totalHours * 1100;
  print('Total hours: $totalHours');

  print('Total pay: $totalPay');

  final ids = timeLogs.map((e) => e.id).join(', ');
  print('Ids: $ids');

  final out = File('out.txt');
  String buff = "";
  for (final timeLog in timeLogs) {
    buff += '${timeLog.id};${timeLog.name};${timeLog.hours.toInt()}\r';
  }
  out.writeAsStringSync(buff);
}
