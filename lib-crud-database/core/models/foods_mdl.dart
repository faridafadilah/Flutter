class FoodModel {
  String id;
  String title;
  String description;
  int price;
  String image;
  String fullDescription;

  //constructor
  FoodModel(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.price,
      this.fullDescription});

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
        id: map['id'].toString(),
        title: map['title'],
        description: map['description'],
        image: map['image'],
        price: map['price'],
        fullDescription: map['full_description']);
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['description'] = description;
    map['full_description'] = fullDescription;
    map['price'] = price;
    map['image'] = image;

    return map;
  }
}
