import 'package:dharma_deshana/models/savable.dart';

class MusicCategory extends Savable  {
  static String tableName = 'CATEGORIES';

  final int categoryId;
  final String category;
  final String imageUrl;

  MusicCategory({
    this.categoryId,
    this.category,
    this.imageUrl,
  });

  factory MusicCategory.fromJson(dynamic json, int categoryId) {
    return MusicCategory(
      categoryId: categoryId,
      category: json['category'],
      imageUrl: json['image'],
    );
  }

  @override
  String getTableName() {
    return tableName;
  }

  @override
  String getArgs() {
    return 'CATEGORY_ID = ?';
  }

  @override
  List<dynamic> getArgValues() {
    return [categoryId];
  }

  @override
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['CATEGORY_ID'] = categoryId;
    map['CATEGORY'] = category;
    map['IMAGE_URL'] = imageUrl;
    return map;
  }

  factory MusicCategory.fromMapObject(Map<String, dynamic> map) {
    return MusicCategory(
      categoryId: map['CATEGORY_ID'],
      category: map['CATEGORY'],
      imageUrl: map['IMAGE_URL'],
    );
  }
}
