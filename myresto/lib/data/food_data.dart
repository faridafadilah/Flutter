import 'package:myresto/model/food.dart';

class FoodData {
  static List<Food> getFoods() {
    //object
    List<Food> _foods = [];
    //data food
    _foods.add(Food(
        name: 'Pizza Chesse',
        description: 'Pizza dengan lelehan chesse',
        image: 'food1.jpg',
        price: 60000,
        fullDescription:
            'Pizza Chesse yang bisa anda pilih toping nya, ada Captain, Chicken, Crabs. Jika anda beli 5 maka gratis 1.'));
    _foods.add(Food(
        name: 'Fruit Growing',
        description: 'Makanan cocok untuk diet dan breakfast',
        image: 'food2.jpg',
        price: 40000,
        fullDescription:
            'Fruit Growing yang enak dan jangan takut karena ini sangat sehat dan cocok buat kamu yang lagi diet.'));
    _foods.add(Food(
        name: 'Mango Blesssed',
        description: 'Minuman enak dan segar untuk buka puasa',
        image: 'drink1.jpg',
        price: 23000,
        fullDescription:
            'Minuman segar yang diambil langsung dari mangga yang asli dan bisa memanjakan lidah anda. Pas untuk kalangan apapun.'));
    _foods.add(Food(
        name: 'Es Campur',
        description: 'Es Campur yang segala ada untuk mu',
        image: 'drink2.jpg',
        price: 26000,
        fullDescription:
            'Es Campur yang legend dikalangan anak muda, dengan varian buah dan agar-agar yang bisa membua kamu kenyang.'));

    return _foods;
  }
}
