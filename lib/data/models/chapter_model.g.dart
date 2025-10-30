// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChapterModelAdapter extends TypeAdapter<ChapterModel> {
  @override
  final int typeId = 1;

  @override
  ChapterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChapterModel(
      slug: fields[0] as String,
      title: fields[1] as String,
      section: fields[2] as String,
      content: fields[3] as String,
      order: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ChapterModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.slug)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.section)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
