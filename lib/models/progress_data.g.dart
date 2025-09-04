// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressDataAdapter extends TypeAdapter<ProgressData> {
  @override
  final int typeId = 0;

  @override
  ProgressData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressData()
      ..date = fields[0] as DateTime
      ..mood = fields[1] as String
      ..confidence = fields[2] as double
      ..challenges = (fields[3] as List).cast<String>()
      ..goal = fields[4] as String
      ..notes = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, ProgressData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.mood)
      ..writeByte(2)
      ..write(obj.confidence)
      ..writeByte(3)
      ..write(obj.challenges)
      ..writeByte(4)
      ..write(obj.goal)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
