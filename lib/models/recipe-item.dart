import 'package:pocket_recipes/models/model.dart';

class RecipeItem extends Model {

  static String table = 'recipe_items';

  int id;
  String title;
  String category;


  RecipeItem({ this.id, this.title, this.category});

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'title': title,
      'category': category
    };

    if (id != null) { map['id'] = id; }
    return map;
  }

  static RecipeItem fromMap(Map<String, dynamic> map) {

    return RecipeItem(
        id: map['id'],
        title: map['title'],
        category: map['category']
    );
  }
}