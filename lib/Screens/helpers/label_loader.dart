import 'package:flutter/services.dart';

Future<List<String>> loadLabels() async {
  final String labelsData = await rootBundle.loadString('assets/labels.txt');
  return labelsData.split('\n'); // Split labels by newline
}
