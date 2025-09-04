import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/progress_data.dart';

class ProgressProvider with ChangeNotifier {
  final Box<ProgressData> _progressBox = Hive.box<ProgressData>('progress');

  List<ProgressData> get progressData => _progressBox.values.toList();

  void addProgress(ProgressData data) {
    _progressBox.add(data);
    notifyListeners();
  }
}
