import 'package:hive/hive.dart';

part 'progress_data.g.dart';

@HiveType(typeId: 0)
class ProgressData extends HiveObject {
  @HiveField(0)
  late DateTime date;

  @HiveField(1)
  late String mood;

  @HiveField(2)
  late double confidence;

  @HiveField(3)
  late List<String> challenges;

  @HiveField(4)
  late String goal;

  @HiveField(5)
  late String notes;
}
