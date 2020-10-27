import 'package:dharma_deshana/models/savable.dart';

class MusicCategory extends Savable  {
  static String tableName = 'CATEGORIES';

  final int categoryId;
  final String category;
  final String categoryName;
  final String imageUrl;

  MusicCategory({
    this.categoryId,
    this.category,
    this.categoryName,
    this.imageUrl,
  });

  factory MusicCategory.fromJson(dynamic json, int categoryId) {
    return MusicCategory(
      categoryId: categoryId,
      category: json['category'],
      categoryName: json['category_name'],
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
    map['CATEGORY_NAME'] = categoryName;
    map['IMAGE_URL'] = imageUrl;
    return map;
  }

  factory MusicCategory.fromMapObject(Map<String, dynamic> map) {
    return MusicCategory(
      categoryId: map['CATEGORY_ID'],
      category: map['CATEGORY'],
      categoryName: map['CATEGORY_NAME'],
      imageUrl: map['IMAGE_URL'],
    );
  }
}
