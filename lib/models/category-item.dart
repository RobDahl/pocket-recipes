import 'package:pocket_recipes/models/model.dart';

class CategoryItem extends Model {

  static String table = 'category_items';

  int id;
  String title;

  CategoryItem({ this.id, this.title});

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'title': title
    };

    if (id != null) { map['id'] = id; }
    return map;
  }

  static CategoryItem fromMap(Map<String, dynamic> map) {

    return CategoryItem(
        id: map['id'],
        title: map['title']
    );
  }
}