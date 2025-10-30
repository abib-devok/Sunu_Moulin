import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'chapter_model.g.dart';

@HiveType(typeId: 1)
class ChapterModel extends Equatable {
  @HiveField(0)
  final String slug;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String section;
  @HiveField(3)
  final String content;
  @HiveField(4)
  final int order;

  const ChapterModel({
    required this.slug,
    required this.title,
    required this.section,
    required this.content,
    required this.order,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      slug: json['slug'],
      title: json['title'],
      section: json['section'],
      content: json['content'] ?? '',
      order: json['order'] ?? 99,
    );
  }

  @override
  List<Object?> get props => [slug, title, section, content, order];
}